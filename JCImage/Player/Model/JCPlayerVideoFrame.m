//
//  JCPlayerVideoFrame.m
//  JCImage
//
//  Created by jaycehan on 2024/2/4.
//

#import <UIKit/UIKit.h>
#import "JCPlayerVideoFrame.h"

@interface JCPlayerVideoFrame ()

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) uint8_t **data;

@property (nonatomic, strong) NSData *luma;

@property (nonatomic, strong) NSData *chromaB;

@property (nonatomic, strong) NSData *chromaR;

@property (nonatomic, assign) AVFrame *avFrame;

@end

@implementation JCPlayerVideoFrame

- (instancetype)initWithAVFrame:(AVFrame *)frame {
    self = [super init];
    self.height = frame->height;
    self.width = frame->width;
//    self.data = (uint8_t **)malloc(sizeof(uint8_t *));
//    for (int i = 0; i < 3; i++) {
//        self.data[i] = (uint8_t *)malloc(AV_NUM_DATA_POINTERS * sizeof(uint8_t));
//        memcpy(self.data[i], frame->data[i], frame->width);
//    }
    self.avFrame = frame;
    return self;
}

- (uint8_t **)data {
    return self.avFrame->data;
}

@end
