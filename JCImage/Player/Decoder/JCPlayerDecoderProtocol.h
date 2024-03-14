//
//  JCPlayerDecoderProtocol.h
//  JCImage
//
//  Created by jaycehan on 2024/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JCPlayerDecoder <NSObject>

/**
 * @brief 当前视频文件音频或视频是否有效
 */
@property (nonatomic, assign, readonly) BOOL valid;

/**
 * @brief 读取视频文件数据
 * @param filePath 视频文件路径
 * @param error 错误信息
 */
- (void)openFileWithFilePath:(NSString *)filePath error:(NSError **)error;

@end


@protocol JCPlayerVideoDecoder <JCPlayerDecoder>


@end


@protocol JCPlayerAudioDecoder <JCPlayerDecoder>

@end

NS_ASSUME_NONNULL_END
