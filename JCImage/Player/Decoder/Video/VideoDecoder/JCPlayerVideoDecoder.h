//
//  JCPlayerVideoDecoder.h
//  JCImage
//
//  Created by jaycehan on 2023/12/28.
//

#import <Foundation/Foundation.h>
#import "JCVideoDecoder.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCPlayerVideoDecoder : NSObject <JCVideoDecoder>

@property (nonatomic, copy, readonly) NSArray<id<JCVideoFrame>> *frameBuffer;

@end

NS_ASSUME_NONNULL_END
