//
//  JCPlayerVideoInfo.h
//  JCImage
//
//  Created by jaycehan on 2024/3/8.
//

#import <Foundation/Foundation.h>
#import "JCVideoFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCPlayerVideoInfo : NSObject <JCVideoInfo>

// 视频时长（毫秒）
@property (nonatomic, assign) NSTimeInterval duration;

// 视频宽度
@property (nonatomic, assign) NSUInteger width;

// 视频高度
@property (nonatomic, assign) NSUInteger height;

// 视频帧率
@property (nonatomic, assign) NSUInteger fps;

@end

NS_ASSUME_NONNULL_END