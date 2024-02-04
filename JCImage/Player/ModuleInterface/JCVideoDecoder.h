//
//  JCVideoDecoder.h
//  JCImage
//
//  Created by jaycehan on 2024/2/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JCVideoDecoder <NSObject>

- (void)decodeVideoFrameWithURL:(NSString *)URL;

@end

NS_ASSUME_NONNULL_END
