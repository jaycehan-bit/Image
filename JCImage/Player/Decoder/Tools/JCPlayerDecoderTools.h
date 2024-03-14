//
//  JCPlayerDecoderTools.h
//  JCImage
//
//  Created by jaycehan on 2024/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCPlayerDecoderTools : NSObject

/**
 * @brief 获取视频文件制定格式的流索引
 * @param format_context 文件格式上下文
 * @param media_type 需要寻找的媒体类型
 * @return NSArray<NSNumber *> 索引列表
 */
static NSArray<NSNumber *> *findStreamIndex(const AVFormatContext *format_context, const enum AVMediaType media_type);

@end

NS_ASSUME_NONNULL_END
