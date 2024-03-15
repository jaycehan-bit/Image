//
//  JCPlayerVideoDecoder.m
//  JCImage
//
//  Created by jaycehan on 2023/12/28.
//

#import <libavutil/frame.h>
#import "avformat.h"
#import "JCPlayerAsynModuleDefine.h"
#import "JCPlayerDecoderTools.h"
#import "JCPlayerVideoDecoder.h"
#import "JCPlayerVideoFrame+Writable.h"

@interface JCPlayerVideoDecoder ()

@property (nonatomic, assign) AVFormatContext *format_context;

@property (nonatomic, assign) AVCodecContext *codec_context;

@property (nonatomic, assign) NSInteger stream_index;

@property (nonatomic, assign) CGFloat timeBase;

@property (nonatomic, assign) CGFloat FPS;

@end

@implementation JCPlayerVideoDecoder

@dynamic valid;

- (instancetype)init {
    self = [super init];
    if (self) {
        _stream_index = JCPlayerInvalidStreamIndex;
    }
    return self;
}

#pragma make - <JCPlayerVideoDecoder>

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
    }
}

- (id<JCFrame>)decodeVideoFrameWithPacket:(AVPacket)packet error:(NSError *__autoreleasing  _Nullable *)error {
    JCPlayerVideoFrame *videoFrame = nil;
    int packetSize = packet.size;
    int send_packet_result = avcodec_send_packet(self.codec_context, &packet);
    AVFrame *frame = av_frame_alloc();
    int receive_frame_result = avcodec_receive_frame(self.codec_context, frame);
    
    if (receive_frame_result == AVERROR(EAGAIN)) {
        // 解码数据不够，需继续send_packet
        NSLog(@"⚠️⚠️⚠️ Fail to receive frame with AVERROR error : %d", receive_frame_result);
        *error = [NSError errorWithDomain:NSCocoaErrorDomain code:JCDecodeErrorCodeEAGAIN userInfo:@{NSLocalizedFailureReasonErrorKey : @"EAGAIN Error"}];
    } else if (receive_frame_result != 0) {
        NSLog(@"❌❌❌ Fail to receive frame with error code : %d", receive_frame_result);
        *error = [NSError errorWithDomain:NSCocoaErrorDomain code:receive_frame_result userInfo:@{NSLocalizedFailureReasonErrorKey : @"Receive frame Error"}];
    } else {
        NSLog(@"✅✅✅ Receive frame success");
        JCPlayerVideoFrame *videoFrame = [[JCPlayerVideoFrame alloc] initWithAVFrame:frame];
        videoFrame.duration = frame->pkt_duration * self.timeBase;
        videoFrame.position = frame->pkt_pos * self.timeBase;
        return videoFrame;
    }
    return nil;
}

@end
