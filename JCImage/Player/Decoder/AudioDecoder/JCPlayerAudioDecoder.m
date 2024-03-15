//
//  JCPlayerAudioDecoder.m
//  JCImage
//
//  Created by jaycehan on 2024/1/15.
//

#import <libavformat/avformat.h>
#import <libavutil/samplefmt.h>
#import <libswresample/swresample.h>
#import "avformat.h"
#import "JCPlayerAsynModuleDefine.h"
#import "JCPlayerAudioDecoder.h"
#import "JCPlayerAudioFrame+Writable.h"
#import "JCPlayerDecoderTools.h"

@interface JCPlayerAudioDecoder ()

@property (nonatomic, assign) AVFormatContext *format_context;

@property (nonatomic, assign) AVCodecContext *codec_context;

@property (nonatomic, assign) SwrContext *swr_context;

@property (nonatomic, assign) NSInteger stream_index;

@property (nonatomic, assign) CGFloat timeBase;

@property (nonatomic, assign) CGFloat FPS;

@end

@implementation JCPlayerAudioDecoder

@dynamic valid;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stream_index = JCPlayerInvalidStreamIndex;
    }
    return self;
}

#pragma mark - <JCPlayerAudioDecoder>

- (BOOL)valid {
    return self.stream_index != JCPlayerInvalidStreamIndex;
}

- (void)openFileWithFilePath:(NSString *)filePath error:(NSError **)error {
    if (!filePath.length) {
        *error = [NSError errorWithDomain:NSCocoaErrorDomain code:JCDecodeErrorCodeInvalidPath userInfo:@{NSLocalizedFailureReasonErrorKey : @"Invalid File Path"}];
        return;
    }
    self.format_context = formate_context(filePath);
    self.stream_index = findStreamIndex(self.format_context, AVMEDIA_TYPE_VIDEO).firstObject.integerValue;
    AVStream *stream = self.format_context->streams[self.stream_index];
    streamFPSTimeBase(stream, &_FPS, &_timeBase);
    
    AVCodec *codec = avcodec_find_decoder(stream->codecpar->codec_id);
    self.codec_context = avcodec_alloc_context3(codec);
    avcodec_parameters_to_context(self.codec_context, stream->codecpar);

    int avcodec_open2_result = avcodec_open2(self.codec_context, codec, NULL);
    if (avcodec_open2_result != 0) {
        *error = [NSError errorWithDomain:NSCocoaErrorDomain code:JCDecodeErrorCodecOpenCodecError userInfo:@{NSLocalizedFailureReasonErrorKey : @"Open Codec Error"}];
        NSLog(@"❌❌❌ Failed to open codec");
    }
    [self configSwtContextIfNeeded];
}

- (NSArray<id<JCFrame>> *)decodeVideoFrameWithPacket:(AVPacket)packet error:(NSError **)error {
    NSMutableArray<id<JCFrame>> *frameBuffer = [NSMutableArray array];
    int packetSize = packet.size;
    AVFrame *frame = av_frame_alloc();
    while (packetSize > 0) {
        int send_packet_result = avcodec_send_packet(self.codec_context, &packet);
        if (send_packet_result == AVERROR_EOF) {
            NSLog(@"✅✅✅ Send audio packet finish");
        } else if (send_packet_result != 0) {
            NSLog(@"❌❌❌ Fail to send audio packet with error code : %d", send_packet_result);
        } else {
            NSLog(@"✅✅✅ Send audio packet success");
        }
        int receive_frame_result = avcodec_receive_frame(self.codec_context, frame);
        if (receive_frame_result == AVERROR(EAGAIN)) {
            // 解码数据不够，需继续send_packet
            NSLog(@"⚠️⚠️⚠️ Fail to receive frame with AVERROR error : %d", receive_frame_result);
            *error = [NSError errorWithDomain:NSCocoaErrorDomain code:JCDecodeErrorCodeEAGAIN userInfo:@{NSLocalizedFailureReasonErrorKey : @"EAGAIN Error"}];
            break;
        } else if (receive_frame_result != 0) {
            NSLog(@"❌❌❌ Fail to receive audio frame with error code : %d", receive_frame_result);
            break;
        } else {
            NSLog(@"✅✅✅ Receive audio frame success");
            JCPlayerAudioFrame *audioFrame = [self convertAudioFrameWithAVFrame:frame];
            if (audioFrame) {
                [frameBuffer addObject:audioFrame];
                packetSize -= audioFrame.duration;
            } else {
                break;
            }
        }
    }
    return frameBuffer;
}

#pragma mark - Private

- (JCPlayerAudioFrame *)convertAudioFrameWithAVFrame:(AVFrame *)frame {
    if (frame->data[0] == NULL) {
        return nil;
    }
    uint8_t *audioData;
    int numberOfFrame = 0;
    if (self.swr_context) {
        numberOfFrame = swr_convert(self.swr_context, &audioData, (int)(frame->nb_samples * 2), (const uint8_t **)frame->data, frame->nb_samples);
    } else {
        audioData = frame->data[0];
        numberOfFrame = frame->nb_samples;
    }
    const NSUInteger numberOfElement = numberOfFrame * frame->channels;
    NSMutableData *pcm = [NSMutableData data];
    memcmp(pcm.mutableBytes, audioData, numberOfElement * sizeof(SInt16));
    JCPlayerAudioFrame *audioFrame = [[JCPlayerAudioFrame alloc] initWithAVFrame:frame];
    audioFrame.position = frame->pkt_pos * self.timeBase;
    audioFrame.duration = frame->pkt_duration * self.timeBase;
    audioFrame.sampleData = pcm.copy;
    return audioFrame;
}

- (void)configSwtContextIfNeeded {
    if (self.codec_context->sample_fmt == AV_SAMPLE_FMT_S16) {
        return;
    }
    enum AVSampleFormat in_format = self.codec_context->sample_fmt;
    int in_sample_rate = self.codec_context->sample_rate;
    uint64_t in_ch_layout = self.codec_context->channel_layout;
    
    enum AVSampleFormat out_format = AV_SAMPLE_FMT_S16;
    int out_sample_rate = 44100;
    uint64_t out_ch_layout = av_get_default_channel_layout(self.codec_context->channels);
    
    self.swr_context = swr_alloc_set_opts(NULL, 
                                         out_ch_layout,
                                         out_format,
                                         out_sample_rate,
                                         in_ch_layout,
                                         in_format,
                                         in_sample_rate,
                                         0, NULL);
    if (!self.swr_context) {
        NSLog(@"❌❌❌ Create swr_context failed");
        return;
    }
    if (!swr_init(self.swr_context)) {
        NSLog(@"❌❌❌ Init swr_context failed");
        swr_free(&_swr_context);
        return;
    }
}

@end
