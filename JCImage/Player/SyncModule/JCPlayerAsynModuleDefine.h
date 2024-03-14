//
//  JCPlayerAsynModuleDefine.h
//  JCImage
//
//  Created by jaycehan on 2024/3/14.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JCPlayerOpenFileStatus) {
    JCPlayerOpenFileStatusSuccess = 0,  // 打开成功
    JCPlayerOpenFileStatusFailed = 1,   // 打开失败
};

typedef NS_ENUM(NSInteger, JCDecodeErrorCode) {
    JCDecodeErrorCodeSuccess = 0,       // 成功
    JCDecodeErrorCodeInvalidPath = 1,   // 错误路径
    JCDecodeErrorCodeInvalidFile = 2,   // 无效视频文件
    JCDecodeErrorCodeInvalidStream = 3, // 无效视频流
    JCDecodeErrorCodecContextError = 4, // 解码器上下文错误
};
