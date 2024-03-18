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
 * @brief 开始解码
 */
- (void)run;

/**!
 * @brief 终止解码，清空上下文
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
