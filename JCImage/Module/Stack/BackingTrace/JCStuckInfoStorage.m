//
//  JCStuckInfoStorage.m
//  JCImage
//
//  Created by jaycehan on 2024/1/31.
//

#import "JCStuckInfoStorage.h"

@interface JCStuckModel ()

@property (nonatomic, copy) NSString *stackInfo;

@end

@implementation JCStuckModel

@end

@interface JCStuckInfoStorage ()

@end

@implementation JCStuckInfoStorage

void storage(const uintptr_t *symbol, const Dl_info *symbolicated, const uint32_t symbol_count) {
    NSMutableString *string = [NSMutableString stringWithString:@"\n"];
    for (NSUInteger index = 0; index < symbol_count; index ++) {
        [string appendString:symbolSummary(symbol[index], symbolicated[index])];
    }
    [string appendString:@"\n"];
    JCStuckModel *model = [[JCStuckModel alloc] init];
    model.stackInfo = string.copy;
    NSLog(@"%@", model.stackInfo);
}

NSString *symbolSummary(const uintptr_t address, const Dl_info dlInfo) {
    if (dlInfo.dli_sname == NULL) {
        return @"";
    }
    NSString *summary = @"";
    // strrchr 查找某字符在字符串中最后一次出现的位置
    char *file = strrchr(dlInfo.dli_fname, '/');
    if (file == NULL) {
        summary = [NSString stringWithFormat:@"%-30s",dlInfo.dli_fname];
    } else {
        summary = [NSString stringWithFormat:@"%-30s",file + 1];
    }
    uintptr_t offset = address - (uintptr_t)dlInfo.dli_saddr;
    return [NSString stringWithFormat:@"%@ 0x%08" PRIxPTR " %s + %lu\n", summary, (uintptr_t)address, dlInfo.dli_sname, offset];
}

@end
