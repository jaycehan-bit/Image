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

@property (nonatomic, assign, readonly) CGFloat height;

@property (nonatomic, assign, readonly) CGFloat width;

@property (nonatomic, assign, readonly) uint8_t **data;

@property (nonatomic, strong, readonly) NSData *luma;

@property (nonatomic, strong, readonly) NSData *chromaB;

@property (nonatomic, strong, readonly) NSData *chromaR;

@property (nonatomic, assign, readonly) AVFrame *avFrame;

@end

NS_ASSUME_NONNULL_END
