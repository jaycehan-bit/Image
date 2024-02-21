//
//  JCPlayerAudioDecoder.m
//  JCImage
//
//  Created by jaycehan on 2024/1/15.
//

#import "avformat.h"
#import "JCPlayerAudioDecoder.h"

@implementation JCPlayerAudioDecoder

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

@end
