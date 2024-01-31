//
//  JCSymbolParser.h
//  JCImage
//
//  Created by jaycehan on 2023/12/11.
//

#import <Foundation/Foundation.h>
#import <dlfcn.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCSymbolParser : NSObject

void parse(uintptr_t *symbol, Dl_info *symbolicated, uint32_t symbol_count);

@end

NS_ASSUME_NONNULL_END
