//
//  JCPlayerDecoder.m
//  JCImage
//
//  Created by jaycehan on 2024/2/21.
//

#import "avformat.h"
#import "JCPlayerAudioDecoder.h"
#import "JCPlayerAsynModuleDefine.h"
#import "JCPlayerDecoder.h"
#import "JCPlayerDecoderProtocol.h"
#import "JCPlayerVideoDecoder.h"
#import "JCPlayerVideoInfo.h"

@interface JCPlayerDecoder ()

@property (nonatomic, strong) id<JCPlayerAudioDecoder> audioDecoder;

@property (nonatomic, strong) id<JCPlayerVideoDecoder> videoDecoder;

@property (nonatomic, assign) AVFormatContext *formatContext;

@end

@implementation JCPlayerDecoder

- (id<JCVideoInfo>)openFileWithFilePath:(NSString *)filePath error:(NSError **)error {
    if (!filePath.length) {
        *error = [NSError errorWithDomain:NSURLErrorDomain code:JCDecodeErrorCodeInvalidPath userInfo:@{NSLocalizedFailureReasonErrorKey : @"Invalid file path"}];
        return nil;
    }
    self.formatContext = formate_context(filePath);
    if (!self.formatContext) {
        *error = [NSError errorWithDomain:NSURLErrorDomain code:JCDecodeErrorCodeInvalidFile userInfo:@{NSLocalizedFailureReasonErrorKey : @"Invalid video file"}];
        return nil;
    }
    
    
    
    int stream_index = -1;
    for (int index = 0; index < self.formatContext->nb_streams; index ++) {
        if (self.formatContext->streams[index]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
            stream_index = index;
            break;
        }
    }
    if (stream_index == -1) {
        NSLog(@"❌❌❌ Find video stream index failed");
    }
    // 获取解码器
    AVCodec *codec = avcodec_find_decoder(self.formatContext->streams[stream_index]->codecpar->codec_id);
    // 创建解码器上下文
    AVCodecContext *codec_context = avcodec_alloc_context3(codec);
    // 复制解码器参数到解码器上下文
    int result = avcodec_parameters_to_context(codec_context, self.formatContext->streams[stream_index]->codecpar);
    if (result < 0) {
        *error = [NSError errorWithDomain:NSURLErrorDomain code:JCDecodeErrorCodecContextError userInfo:@{NSLocalizedFailureReasonErrorKey : @"Failed to copy codecContext"}];
        return nil;
    }
    AVStream *videoStream = self.formatContext->streams[stream_index];
    JCPlayerVideoInfo *videoInfo = [[JCPlayerVideoInfo alloc] init];
    videoInfo.fps = av_q2d(videoStream->avg_frame_rate);
    videoInfo.duration = (NSTimeInterval)videoStream->duration / av_q2d(videoStream->avg_frame_rate);
    videoInfo.width = codec_context->width;
    videoInfo.height = codec_context->height;
    return videoInfo;
}

#pragma mark - Control

- (void)run {
    if (!self.formatContext) {
        return;
    }
}

- (void)pause {
    
}

- (void)stop {
    
}

#pragma mark - Decode

- (void)decode {
    
}

#pragma mark - Helper

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
    
    if (node_result < 0) {
        avformat_close_input(&formatContext);
        avformat_free_context(formatContext);
    }
    return formatContext;
}

static NSArray * detachStreams(AVFormatContext *format_context, enum AVMediaType media_type) {
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger stream_index = 0; stream_index < format_context->nb_streams; stream_index ++) {
        if (format_context->streams[stream_index]->codecpar->codec_type == media_type) {
            [array addObject:@(stream_index)];
        }
    }
    return array.copy;
}

#pragma mark - Init

- (id<JCPlayerVideoDecoder>)videoDecoder {
    if (!_videoDecoder) {
        _videoDecoder = [[JCPlayerVideoDecoder alloc] init];
    }
    return _videoDecoder;
}

- (id<JCPlayerAudioDecoder>)audioDecoder {
    if (!_audioDecoder) {
        _audioDecoder = [[JCPlayerAudioDecoder alloc] init];
    }
    return _audioDecoder;
}

@end
