//
//  JCStuckDetector.h
//  JCImage
//
//  Created by jaycehan on 2024/1/2.
//

#import <Foundation/Foundation.h>
#import "JCStuckModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCStuckDetector : NSObject <JCStuckModule>

// 探测间隔，默认为100
@property (nonatomic, assign) NSTimeInterval detectInterval;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
