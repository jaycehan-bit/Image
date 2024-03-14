//
//  JCPlayerSyncController.h
//  JCImage
//
//  Created by jaycehan on 2024/3/13.
//

#import <Foundation/Foundation.h>
#import "JCPlayerAsynModuleDefine.h"
#import "JCVideoFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCPlayerSyncController : NSObject

/**!
 * @brief 打开目标视频文件，并读取信息
 * @param filePath 视频文件路径
 * @return 视频上下文，nil表示打开/读取视频文件失败
 */
- (id<JCVideoInfo>)openFileWithFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
