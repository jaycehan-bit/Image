//
//  JCPlayerAudioFrame.m
//  JCImage
//
//  Created by jaycehan on 2024/3/15.
//

#import "JCPlayerAudioFrame.h"

@interface JCPlayerAudioFrame ()

@property (nonatomic, assign) JCFrameType type;

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, assign) CGFloat position;

@property (nonatomic, strong) NSDate *sampleData;

@property (nonatomic, assign) NSUInteger channel;

@end

@implementation JCPlayerAudioFrame

- (instancetype)initWithAVFrame:(AVFrame *)frame {
    self = [super init];
    self.channel = frame->channels;
    return self;
}

#pragma mark - Getter

- (JCFrameType)type {
    return JCFrameTypeAudio;
}

@end
