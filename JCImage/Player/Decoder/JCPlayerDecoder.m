//
//  JCPlayerDecoder.m
//  JCImage
//
//  Created by jaycehan on 2024/2/21.
//

#import "avformat.h"
#import "JCPlayerDecoder.h"
#import "JCPlayerAudioDecoder.h"
#import "JCPlayerVideoDecoder.h"

@interface JCPlayerDecoder ()

@property (nonatomic, strong) JCPlayerAudioDecoder *audioDecoder;

@property (nonatomic, strong) JCPlayerVideoDecoder *videoDecoder;

@property (nonatomic, assign) AVFormatContext *formatContext;

@end

@implementation JCPlayerDecoder

- (void)openFileWithFilePath:(NSString *)filePath error:(NSError **)error {
    if (!filePath.length) {
        *error = [NSError errorWithDomain:NSURLErrorDomain code:-1001 userInfo:@{NSLocalizedFailureReasonErrorKey : @"Invalid file path"}];
        return;
    }
    self.formatContext = formate_context(filePath);
}

- (void)run {
    if (!self.formatContext) {
        return;
    }
    
    
}

- (void)pause {
    
}

- (void)stop {
    
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

- (JCPlayerVideoDecoder *)videoDecoder {
    if (!_videoDecoder) {
        _videoDecoder = [[JCPlayerVideoDecoder alloc] init];
    }
    return _videoDecoder;
}

- (JCPlayerAudioDecoder *)audioDecoder {
    if (!_audioDecoder) {
        _audioDecoder = [[JCPlayerAudioDecoder alloc] init];
    }
    return _audioDecoder;
}

@end
