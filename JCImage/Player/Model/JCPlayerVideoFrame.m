//
//  JCPlayerVideoFrame.m
//  JCImage
//
//  Created by jaycehan on 2024/2/4.
//

#import <UIKit/UIKit.h>
#import "JCPlayerVideoFrame.h"

@interface JCPlayerVideoFrame ()

@property (nonatomic, assign) NSUInteger height;

@property (nonatomic, assign) NSUInteger width;

@property (nonatomic, strong) NSData *luminance;

@property (nonatomic, strong) NSData *chrominance;

@property (nonatomic, strong) NSData *chroma;

@property (nonatomic, assign) AVFrame *avFrame;


// 亮度
@property (nonatomic, assign) uint8_t *__luminance;

// 色度
@property (nonatomic, assign) uint8_t  *__chrominance;

// 浓度
@property (nonatomic, assign) uint8_t *__chroma;

@end

@implementation JCPlayerVideoFrame
 
- (instancetype)initWithAVFrame:(AVFrame *)frame {
    self = [super init];
    self.height = frame->height;
    self.width = frame->width;
    self.luminance = copyFrameData(frame->data[0], frame->linesize[0], frame->width, frame->height);
    self.chrominance = copyFrameData(frame->data[1], frame->linesize[1], frame->width / 2, frame->height / 2);
    self.chroma = copyFrameData(frame->data[2], frame->linesize[2], frame->width / 2, frame->height / 2);
    self.avFrame = frame;
    return self;
}

static NSData * copyFrameData(const uint8_t *src, const uint linesize, const uint width, const uint height) {
    uint min_width = MIN(linesize, width);
    NSMutableData *mutableData = [NSMutableData dataWithLength:min_width * height];
    Byte *dst = mutableData.mutableBytes;
    for (NSUInteger i = 0; i < height; ++i) {
        memcpy(dst, src, min_width);
        dst += min_width;
        src += linesize;
    }
    return mutableData.copy;
}

- (uint8_t *)__luminance {
    return self.avFrame->data[0];
}

- (uint8_t *)__chrominance {
    return self.avFrame->data[1];
}

- (uint8_t *)__chroma {
    return self.avFrame->data[2];
}

@end
