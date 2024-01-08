//
//  MLeaksFinder.m
//  MLeaksFinder
//
//  Created by 李涛 on 2023/7/25.
//  Copyright © 2023 Tencent Inc. All rights reserved.
//

#import "MLeaksFinder.h"

@interface MLeaksFinder ()
@property (nonatomic, strong) NSMutableSet *listeners;
@property (nonatomic, copy  ) NSSet<NSString *> *retainCycleWhiteList;
@end

@implementation MLeaksFinder

+ (instancetype)sharedInstance {
    static MLeaksFinder * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MLeaksFinder alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _listeners = [NSMutableSet set];
    }
    return self;
}

- (void)addMemoryLeakListener:(id<MLFindLeakListener>)listener {
    NSAssert([NSThread isMainThread], @"must be in main thread");
    [self.listeners addObject: listener];
}

- (void)removeMemoryLeakListener:(id<MLFindLeakListener>)listener {
    NSAssert([NSThread isMainThread], @"must be in main thread");
    [self.listeners removeObject: listener];
}

- (void)notifyListenersMemoryLeakOfClassName:(NSString *)className retainCycle:(NSString *)retainCycle {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.listeners enumerateObjectsUsingBlock:^(id<MLFindLeakListener> listener, BOOL * _Nonnull stop) {
            if ([listener respondsToSelector:@selector(findMemoryLeaksOfClassName:retainCycle:)]) {
                [listener findMemoryLeaksOfClassName:className retainCycle:retainCycle];
            }
        }];
        
    });
}

- (void)setupRetainCycleWhiteList:(NSArray<NSString *> *)whiteList {
    if (whiteList.count > 0) {
        self.retainCycleWhiteList = [[NSSet alloc] initWithArray:whiteList];
    }
}

- (BOOL)isInRetainCycleWhiteList:(NSString *)retainCycle {
    __block BOOL isContain = NO;
    [self.retainCycleWhiteList enumerateObjectsUsingBlock:^(NSString * whiteRetain, BOOL * _Nonnull stop) {
        isContain = [retainCycle containsString:whiteRetain];
        if (isContain) {
            *stop = YES;
        }
    }];
    return isContain;
}


@end
