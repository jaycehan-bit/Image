//
//  JCAudioFrame.h
//  JCImage
//
//  Created by jaycehan on 2024/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JCAudioFrame <NSObject>

@property (nonatomic, strong, readonly) id sampleBuffer;

@property (nonatomic, assign, readonly) NSUInteger channel;

@end

NS_ASSUME_NONNULL_END
