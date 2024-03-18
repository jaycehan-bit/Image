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
#import "JCPlayerDecoderTools.h"
#import "JCPlayerVideoDecoder.h"
#import "JCVideoContext.h"

@interface JCPlayerDecoder ()

@property (nonatomic, strong) id<JCPlayerAudioDecoder> audioDecoder;

@property (nonatomic, strong) id<JCPlayerVideoDecoder> videoDecoder;

@property (nonatomic, assign) AVFormatContext *formatContext;

@end

@implementation JCPlayerDecoder

- (id<JCPlayerVideoContext>)openFileWithFilePath:(NSString *)filePath error:(NSError **)error {
    if (!filePath.length) {
        *error = [NSError errorWithDomain:NSURLErrorDomain code:JCDecodeErrorCodeInvalidPath userInfo:@{NSLocalizedFailureReasonErrorKey : @"Invalid file path"}];
        return nil;
    }
    self.formatContext = formate_context(filePath);
    if (!self.formatContext) {
        *error = [NSError errorWithDomain:NSURLErrorDomain code:JCDecodeErrorCodeInvalidFile userInfo:@{NSLocalizedFailureReasonErrorKey : @"Invalid video file"}];
        return nil;
    }
    
    id<JCVideoInfo>videoInfo = (id<JCVideoInfo>)[self.videoDecoder openFileWithFilePath:filePath error:error];
    id<JCAudioInfo>audioInfo = (id<JCAudioInfo>)[self.audioDecoder openFileWithFilePath:filePath error:error];
    if (error) {
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
    JCVideoContext *videoContext = [[JCVideoContext alloc] init];
    videoContext.videoInfo = videoInfo;
    videoContext.audioInfo = audioInfo;
    return videoContext;
}

- (NSArray<id<JCFrame>> *)decodeVideoFramesWithDuration:(CGFloat)duration {
    if (!self.videoDecoder.valid && !self.audioDecoder.valid) {
        return @[];
    }
    NSMutableArray<id<JCFrame>> *frames = [NSMutableArray<id<JCFrame>> array];
    AVPacket packet;
    __block CGFloat decodeDuration = 0;
    BOOL finish = NO;
    while (!finish) {
        if (av_read_frame(self.formatContext, &packet) < 0) {
            break;
        }
        id<JCPlayerDecoder> decoder = [self decoderForPacket:packet];
        if (!decoder) {
            finish = YES;
        }
        NSArray<id<JCFrame>> *videoFrame = [decoder decodeVideoFrameWithPacket:packet error:nil];
        [videoFrame enumerateObjectsUsingBlock:^(id<JCFrame>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            decodeDuration += obj.duration;
        }];
        if (decodeDuration >= duration) {
            finish = YES;
        }
        [frames addObjectsFromArray:videoFrame];
    }
    av_packet_unref(&packet);
    return frames.copy;
}

- (id<JCPlayerDecoder>)decoderForPacket:(const AVPacket)packet {
    if (packet.stream_index == self.videoDecoder.stream_index) {
        return self.videoDecoder;
    }
    if (packet.stream_index == self.audioDecoder.stream_index) {
        return self.audioDecoder;
    }
    return nil;
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
