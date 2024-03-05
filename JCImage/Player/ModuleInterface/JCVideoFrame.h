//
//  JCVideoFrame.h
//  JCImage
//
//  Created by jaycehan on 2024/2/5.
//

#import <Foundation/Foundation.h>
#import "avformat.h"
NS_ASSUME_NONNULL_BEGIN

@protocol JCVideoFrame <NSObject>
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

// 亮度
@property (nonatomic, assign, readonly) uint8_t *__luminance;

// 色度
@property (nonatomic, assign, readonly) uint8_t  *__chrominance;

// 浓度
@property (nonatomic, assign, readonly) uint8_t *__chroma;

@end

NS_ASSUME_NONNULL_END
