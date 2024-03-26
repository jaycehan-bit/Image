//
//  JCPlayerSyncController.h
//  JCImage
//
//  Created by jaycehan on 2024/3/13.
//

#import <Foundation/Foundation.h>
#import "JCPlayerAsynModuleDefine.h"
#import "JCPlayerVideoContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCPlayerSyncController : NSObject

/**!
 * @brief 打开目标视频文件，并读取信息
 * @param filePath 视频文件路径
 * @return 视频上下文，nil表示打开/读取视频文件失败
 */
- (id<JCPlayerVideoContext>)openFileWithFilePath:(NSString *)filePath;

/**!
 * @brief 获取音频渲染数据
 * @param buffer 数据存储队列
 * @param numOfFrames 帧数
 * @param numOfChannels 声道数
 */
- (void)fillAudioRenderDataWithBuffer:(SInt16 *)buffer numOfFrames:(NSUInteger)numOfFrames numOfChannels:(NSUInteger)numOfChannels;

/**!
 * @brief 下一帧被渲染的视频数据
 * @return <JCVideoFrame> 视频帧数据
 */
- (id<JCVideoFrame>)renderedVideoFrame;

/**!
 * @brief 开始解码
 */
- (void)run;

/**!
 * @brief 终止解码，清空上下文
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
