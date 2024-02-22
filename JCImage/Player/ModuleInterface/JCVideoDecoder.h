//
//  JCVideoDecoder.h
//  JCImage
//
//  Created by jaycehan on 2024/2/4.
//

#import <Foundation/Foundation.h>
#import "JCVideoFrame.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JCVideoDecoder <NSObject>

- (void)decodeVideoFrameWithURL:(NSString *)URL;

- (id<JCVideoFrame>)decodeVideoWithAVPacket:(AVPacket)packet size:(NSUInteger)size;

@property (nonatomic, copy, readonly) NSArray<id<JCVideoFrame>> *frameBuffer;

@end

NS_ASSUME_NONNULL_END
