//
//  JCPlayerDecoderTools.m
//  JCImage
//
//  Created by jaycehan on 2024/3/14.
//

#import "avformat.h"
#import "JCPlayerDecoderTools.h"

@implementation JCPlayerDecoderTools

static NSArray *findStreamIndex(const AVFormatContext *format_context, const enum AVMediaType media_type) {
    NSMutableArray *indexArray = [NSMutableArray array];
    for (NSUInteger index = 0; index < format_context->nb_streams; index++) {
        if (format_context->streams[index]->codecpar->codec_type == media_type) {
            [indexArray addObject:@(index)];
        }
    }
    return indexArray.copy;
}

@end
