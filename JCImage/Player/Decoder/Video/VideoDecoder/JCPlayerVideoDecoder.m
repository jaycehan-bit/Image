//
//  JCPlayerVideoDecoder.m
//  JCImage
//
//  Created by jaycehan on 2023/12/28.
//

#import "avformat.h"
#import "JCPlayerAsynModuleDefine.h"
#import "JCPlayerDecoderTools.h"
#import "JCPlayerVideoDecoder.h"

@interface JCPlayerVideoDecoder ()

@property (nonatomic, strong) dispatch_queue_t videoDecodeQueue;

@property (nonatomic, strong) dispatch_semaphore_t decodeSemaphore;


@end

@implementation JCPlayerVideoDecoder

@dynamic valid;

#pragma make - <JCPlayerVideoDecoder>

- (void)openFileWithFilePath:(NSString *)filePath error:(NSError **)error {
    if (!filePath.length) {
        *error = [NSError errorWithDomain:NSCocoaErrorDomain code:JCDecodeErrorCodeInvalidPath userInfo:@{NSLocalizedFailureReasonErrorKey : @"Invalid File Path"}];
        return;
    }
    AVFormatContext *format_context = formate_context(filePath);
    
}

- (id<JCVideoInfo>)decodeVideoInfoWithURL:(NSString *)URL {
    if (!URL.length) {
        return nil;
    }
    AVFormatContext *format_context = formate_context(URL);
    if (!format_context) {
        return nil;
    }
    int stream_index = -1;
    for (int index = 0; index < format_context->nb_streams; index ++) {
        if (format_context->streams[index]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
            stream_index = index;
            break;
        }
    }
    if (stream_index == -1) {
        NSLog(@"❌❌❌ Find stream index failed ");
        return nil;
    }
    
    AVCodec *codec = avcodec_find_decoder(format_context->streams[stream_index]->codecpar->codec_id);
    AVCodecContext *codec_context = avcodec_alloc_context3(codec);
    avcodec_parameters_to_context(codec_context, format_context->streams[stream_index]->codecpar);
    
    AVStream *videoStream = format_context->streams[stream_index];
    JCPlayerVideoInfo *videoInfo = [[JCPlayerVideoInfo alloc] init];
    videoInfo.fps = av_q2d(videoStream->avg_frame_rate);
    videoInfo.duration = (NSTimeInterval)videoStream->duration / av_q2d(videoStream->avg_frame_rate);
    videoInfo.width = codec_context->width;
    videoInfo.height = codec_context->height;
    return videoInfo;
}

- (void)decode {
    AVFormatContext *format_context = formate_context(@"");
    if (!format_context) {
        return;
    }
    int stream_index = -1;
    for (int index = 0; index < format_context->nb_streams; index ++) {
        if (format_context->streams[index]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
            stream_index = index;
            break;
        }
    }
    if (stream_index == -1) {
        NSLog(@"❌❌❌ Find stream index failed ");
        return;
    }
    
    AVCodec *codec = avcodec_find_decoder(format_context->streams[stream_index]->codecpar->codec_id);
    AVCodecContext *codec_context = avcodec_alloc_context3(codec);
    avcodec_parameters_to_context(codec_context, format_context->streams[stream_index]->codecpar);
    
    int avcodec_open2_result = avcodec_open2(codec_context, codec, NULL);
    if (avcodec_open2_result != 0) {
        NSLog(@"❌❌❌ Fail to open avcode with error code : %d", avcodec_open2_result);
        return;
    }
    AVPacket *av_packet = av_malloc(sizeof(AVPacket));
    AVFrame *av_frame = av_frame_alloc();
    NSMutableArray *frameBuffer = [NSMutableArray array];
    while (!av_read_frame(format_context, av_packet)) {
        if (av_packet->stream_index != stream_index) {
            // 存在stream_index不相等的情况0.0
            av_packet_unref(av_packet);
            continue;
        }
        int send_packet_result = avcodec_send_packet(codec_context, av_packet);
        if (send_packet_result == AVERROR_EOF) {
            NSLog(@"✅✅✅ send packet finish ");
        } else if (send_packet_result != 0) {
            NSLog(@"❌❌❌ Fail to send packet with error code : %d", send_packet_result);
            break;
        } else {
            NSLog(@"✅✅✅ send packet success");
        }
        int receive_frame_result = avcodec_receive_frame(codec_context, av_frame);
        if (receive_frame_result == AVERROR(EAGAIN)) {
            // 解码数据不够，需继续send_packet
            NSLog(@"⚠️⚠️⚠️ Fail to receive frame with AVERROR error : %d", receive_frame_result);
            continue;
        } else if (receive_frame_result != 0) {
            NSLog(@"❌❌❌ Fail to receive frame with error code : %d", receive_frame_result);
            break;
        } else {
            NSLog(@"✅✅✅ Receive frame success");
            JCPlayerVideoFrame *videoFrame = [[JCPlayerVideoFrame alloc] initWithAVFrame:av_frame];
            [frameBuffer addObject:videoFrame];
        }
    }
}

static AVFormatContext * formate_context(NSString *URL) {
    AVFormatContext *formatContext = avformat_alloc_context();
    const char *url = [URL UTF8String];
    int node_result = avformat_open_input(&formatContext, url, NULL, NULL);
    if (node_result != 0) {
        NSLog(@"❌❌❌ Open input failed with errorCode:%d", node_result);
    }
    node_result = avformat_find_stream_info(formatContext, NULL);
    if (node_result < 0) {
        NSLog(@"❌❌❌ Find stream info failed with errorCode:%d", node_result);
    }
    return formatContext;
}

- (dispatch_queue_t)videoDecodeQueue {
    if (!_videoDecodeQueue) {
        _videoDecodeQueue = dispatch_queue_create("com.github.jaycehan.bit.JCImage.videoDecode", DISPATCH_QUEUE_SERIAL);
    }
    return _videoDecodeQueue;
}

@end
