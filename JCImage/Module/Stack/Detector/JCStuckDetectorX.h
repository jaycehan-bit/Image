//
//  JCStuckDetectorX.h
//  JCImage
//
//  Created by jaycehan on 2024/1/31.
//

#import <Foundation/Foundation.h>
#import "JCStuckModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCStuckDetectorX : NSObject <JCStuckModule>

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
