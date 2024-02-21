//
//  JCAudioDecoder.h
//  JCImage
//
//  Created by jaycehan on 2024/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JCAudioDecoder <NSObject>

- (void)decodeAudioFrameWithURL:(NSString *)URL;

@end

NS_ASSUME_NONNULL_END
