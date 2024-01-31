//
//  JCStuckInfoStorage.h
//  JCImage
//
//  Created by jaycehan on 2024/1/31.
//

#import <dlfcn.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCStuckModel : NSObject

@property (nonatomic, copy, readonly) NSString *stackInfo;

@end

@interface JCStuckInfoStorage : NSObject

void storage(const uintptr_t *symbol, const Dl_info *symbolicated, const uint32_t symbol_count);

@end

NS_ASSUME_NONNULL_END
