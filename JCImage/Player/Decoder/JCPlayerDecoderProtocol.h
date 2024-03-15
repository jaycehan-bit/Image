//
//  JCPlayerDecoderProtocol.h
//  JCImage
//
//  Created by jaycehan on 2024/3/14.
//

#import <Foundation/Foundation.h>
#import "JCVideoFrame.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JCPlayerDecoder <NSObject>

/**
 * @brief 当前视频文件音频或视频是否有效
 */
@property (nonatomic, assign, readonly) BOOL valid;

/**
 * @brief 视频/音频时间基
 */
@property (nonatomic, assign, readonly) CGFloat timeBase;

/**
 * @brief 视频/音频流索引
 */
@property (nonatomic, assign, readonly) NSInteger stream_index;

/**
 * @brief 视频/音频帧数
 */
@property (nonatomic, assign, readonly) CGFloat FPS;

/**
 * @brief 读取视频文件数据
 * @param filePath 视频文件路径
 * @param error 错误信息
 */
- (void)openFileWithFilePath:(NSString *)filePath error:(NSError **)error;

/**
 * @brief 解码视频帧
 * @param packet 视频帧
 * @param error 错误信息
 */
- (id<JCFrame>)decodeVideoFrameWithPacket:(AVPacket)packet error:(NSError **)error;

@end


@protocol JCPlayerVideoDecoder <JCPlayerDecoder>

/**
 * @brief 解码视频帧
 * @param packet 视频帧
 * @param error 错误信息
 */
//- (id<JCVideoFrame>)decodeVideoFrameWithPacket:(AVPacket)packet error:(NSError **)error;

@end


@protocol JCPlayerAudioDecoder <JCPlayerDecoder>

/**
 * @brief 解码音频帧
 * @param packet 视频帧
 * @param error 错误信息
 */
//- (id<JCAudioFrame>)decodeVideoFrameWithPacket:(AVPacket)packet error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
