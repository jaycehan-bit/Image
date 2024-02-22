//
//  JCPlayerDecoder.h
//  JCImage
//
//  Created by jaycehan on 2024/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCPlayerDecoder : NSObject

- (void)openFileWithFilePath:(NSString *)filePath error:(NSError **)error;

- (void)run;

- (void)pause;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
