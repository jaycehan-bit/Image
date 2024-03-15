//
//  JCPlayerAudioDecoder.m
//  JCImage
//
//  Created by jaycehan on 2024/1/15.
//

#import <libavutil/samplefmt.h>
#import <libswresample/swresample.h>
#import "avformat.h"
#import "JCPlayerAudioDecoder.h"
#import "JCPlayerDecoderTools.h"

@interface JCPlayerAudioDecoder ()

@property (nonatomic, copy) NSString *URL;

@end

@implementation JCPlayerAudioDecoder

@dynamic valid;

#pragma mark - <JCPlayerAudioDecoder>

- (void)openFileWithFilePath:(NSString *)filePath error:(NSError **)error {
    
}

- (void)decodeAudioFrameWithURL:(NSString *)URL {
    AVFormatContext *format_context = formate_context(URL);
    if (!format_context) {
        return;
    }
    int stream_index = -1;
    for (int index = 0; index < format_context->nb_streams; index ++) {
        if (format_context->streams[index]->codecpar->codec_type == AVMEDIA_TYPE_AUDIO) {
            stream_index = index;
            break;
        }
    }
    if (stream_index == -1) {
        NSLog(@"❌❌❌ Find stream index failed ");
        return;
    }
}

- (void)decode {
    if (!self.URL.length) {
        return;
    }
    AVFormatContext *format_context = formate_context(self.URL);
    if (!format_context) {
        return;
    }
    int stream_index = -1;
    for (int index = 0; index < format_context->nb_streams; index ++) {
        if (format_context->streams[index]->codecpar->codec_type == AVMEDIA_TYPE_AUDIO) {
            stream_index = index;
            break;
        }
    }
    if (stream_index == -1) {
        NSLog(@"❌❌❌ Find audio stream index failed ");
        return;
    }
    AVCodec *codec = avcodec_find_decoder(format_context->streams[stream_index]->codecpar->codec_id);
    AVCodecContext *codecContext = avcodec_alloc_context3(codec);
    if (codecContext == NULL) {
        NSLog(@"❌❌❌ Create codec context failed ");
        return;
    }
    avcodec_parameters_to_context(codecContext, format_context->streams[stream_index]->codecpar);
    int avcodec_open2_result = avcodec_open2(codecContext, codec, NULL);
    if (avcodec_open2_result < 0) {
        NSLog(@"❌❌❌ Open AVCodec failed");
        return;
    }
    AVPacket *packet = (AVPacket *)av_malloc(sizeof(AVPacket));
    AVFrame *frame = av_frame_alloc();
    
    SwrContext *swrContext = swr_alloc();
    enum AVSampleFormat inFormat = codecContext->sample_fmt;
    int inSampleRate = codecContext->sample_rate;
    uint64_t in_ch_layout = codecContext->channel_layout;
    
    enum AVSampleFormat outFormat = AV_SAMPLE_FMT_S16;
    int outSampleRate = 44100;
    uint64_t out_ch_layout = AV_CH_LAYOUT_STEREO;
    
    swr_alloc_set_opts(swrContext, out_ch_layout, outFormat, outSampleRate, in_ch_layout, inFormat, inSampleRate, 0, NULL);
    
    swr_init(swrContext);
    // 获取声道数量
    int outChannelCount = av_get_channel_layout_nb_channels(out_ch_layout);
    
    int currentIndex = 0;
    
    // 设置音频缓冲去接16bit 44100 PCM数据 双声道
    uint8_t *outBuffer = (uint8_t *)av_malloc(2 * 44100);
    
    while (av_read_frame(format_context, packet)) {
        if (packet->stream_index != stream_index) {
            av_packet_unref(packet);
            continue;
        }
        int send_packet_result = avcodec_send_packet(codecContext, packet);
        if (send_packet_result == AVERROR_EOF) {
            NSLog(@"✅✅✅ Send audio packet finish");
        } else if (send_packet_result != 0) {
            NSLog(@"❌❌❌ Fail to send audio packet with error code : %d", send_packet_result);
        } else {
            NSLog(@"✅✅✅ Send audio packet success");
        }
        int receive_frame_result = avcodec_receive_frame(codecContext, frame);
        if (receive_frame_result == AVERROR(EAGAIN)) {
            // 解码数据不够，需继续send_packet
            NSLog(@"⚠️⚠️⚠️ Fail to receive audio frame with AVERROR error : %d", receive_frame_result);
            continue;
        } else if (receive_frame_result != 0) {
            NSLog(@"❌❌❌ Fail to receive audio frame with error code : %d", receive_frame_result);
            break;
        } else {
            NSLog(@"✅✅✅ Receive audio frame success");
            swr_convert(swrContext, &outBuffer, 2 * 44100, (const uint8_t **)frame->data, frame->nb_samples);
            // 实际缓存大小
            int out_buffer_size = av_samples_get_buffer_size(NULL, outChannelCount, frame->nb_samples, outFormat, 1);
            
        }
    }
}

@end
