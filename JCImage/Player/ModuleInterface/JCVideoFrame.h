//
//  JCVideoFrame.h
//  JCImage
//
//  Created by jaycehan on 2024/2/5.
//

#import <Foundation/Foundation.h>
#import "avformat.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JCFrameType) {
    JCFrameTypeVideo = 0,   // 视频帧
    JCFrameTypeAudio = 1,   // 音频帧
};

@protocol JCFrame <NSObject>

// 帧类型
@property (nonatomic, assign, readonly) JCFrameType type;

// 帧时长
@property (nonatomic, assign, readonly) CGFloat duration;

// 帧位置
@property (nonatomic, assign, readonly) CGFloat position;

// 构造方法
- (instancetype)initWithAVFrame:(AVFrame *)frame;

@end

@protocol JCVideoFrame <JCFrame>
// 高度
@property (nonatomic, assign, readonly) NSUInteger height;

// 宽度
@property (nonatomic, assign, readonly) NSUInteger width;

// 亮度
@property (nonatomic, strong, readonly) NSData *luminance;

// 色度
@property (nonatomic, strong, readonly) NSData *chrominance;

// 浓度
@property (nonatomic, strong, readonly) NSData *chroma;

@end

@protocol JCAudioFrame <JCFrame>

@property (nonatomic, strong, readonly) NSDate *sampleData;

@property (nonatomic, assign, readonly) NSUInteger channel;

@end

@protocol JCVideoInfo <NSObject>
// 视频时长（毫秒）
@property (nonatomic, assign, readonly) NSTimeInterval duration;

// 视频宽度
@property (nonatomic, assign, readonly) NSUInteger width;

// 视频高度
@property (nonatomic, assign, readonly) NSUInteger height;

// 视频帧率
@property (nonatomic, assign, readonly) NSUInteger fps;

@end


NS_ASSUME_NONNULL_END
