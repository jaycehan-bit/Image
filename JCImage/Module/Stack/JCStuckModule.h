//
//  JCStuckModule.h
//  JCImage
//
//  Created by jaycehan on 2024/1/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JCStuckModule <NSObject>

- (void)run;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
