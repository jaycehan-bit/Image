/**
 * Tencent is pleased to support the open source community by making MLeaksFinder available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 *
 * https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

#import "MLeakedObjectProxy.h"
#import "MLeaksFinder.h"
#import "MLeaksMessenger.h"
#import "NSObject+MemoryLeak.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <pthread.h>

#if _INTERNAL_MLF_RC_ENABLED
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
#endif

static NSMutableSet *leakedObjectPtrs;
static NSMutableSet<NSString *> *leakedRetainCycles;

static pthread_mutex_t _mleakedLock;
@interface MLeakedObjectProxy ()<UIAlertViewDelegate>
@property (nonatomic, weak) id object;
@property (nonatomic, strong) NSNumber *objectPtr;
@property (nonatomic, strong) NSArray *viewStack;
@end

@implementation MLeakedObjectProxy

+ (BOOL)isAnyObjectLeakedAtPtrs:(NSSet *)ptrs {
    NSAssert([NSThread isMainThread], @"Must be in main thread.");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leakedObjectPtrs = [[NSMutableSet alloc] init];
    });
    
    if (!ptrs.count) {
        return NO;
    }
    if ([leakedObjectPtrs intersectsSet:ptrs]) {
        return YES;
    } else {
        return NO;
    }
}
+ (void)addLeakedObject:(id)object {
//    NSAssert([NSThread isMainThread], @"Must be in main thread.");
    __unsafe_unretained Class currentClass = object_getClass(object);
    NSString *className = NSStringFromClass(currentClass);
    
    // filter system class and ignore them
    if ([className hasPrefix:@"UI"] || [className hasPrefix:@"_UI"]) { return; }
    MLeakedObjectProxy *proxy = [[MLeakedObjectProxy alloc] init];
    proxy.object = object;
    proxy.objectPtr = @((uintptr_t)object);
    proxy.viewStack = [object viewStack];
    static const void *const kLeakedObjectProxyKey = &kLeakedObjectProxyKey;
    objc_setAssociatedObject(object, kLeakedObjectProxyKey, proxy, OBJC_ASSOCIATION_RETAIN);
    
    NSSet<NSArray<FBObjectiveCGraphElement *> *> *retainCycles = [self tryFindRetainCycleFromObj:object];
    NSLog(@"⚠️Leaks⚠️\n%@", retainCycles);
//    NSSet<NSString *> *formatedCycleStrSet = [self parseRetainCycleFromSet:retainCycles forClassName:className];
//    [formatedCycleStrSet enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
//
//        if ([[MLeaksFinder sharedInstance] isInRetainCycleWhiteList: obj]) {
//            return;
//        }
//
//        [self checkToNotifyFindMemoryLeakOfClassName:className retainCycleStr:obj proxy:proxy];
//    }];

}

+ (void)checkToNotifyFindMemoryLeakOfClassName:(NSString *)className
                         retainCycleStr:(NSString *)retainCycleStr
                                  proxy:(MLeakedObjectProxy *)proxy {
    
    if ([self checkIfRecorded: retainCycleStr]) { return; }
    
    if (retainCycleStr.length) {
        [leakedObjectPtrs addObject:proxy.objectPtr];
//        NSLog(@"memory leak: %@",formatedCycleStr);
        [[MLeaksFinder sharedInstance] notifyListenersMemoryLeakOfClassName:className retainCycle:retainCycleStr];
    }
    if (!retainCycleStr.length) {
        // Possibly Memory Leak.
        return;
    }
    
    if ([MLeaksFinder sharedInstance].disableAlert) { return; }
    dispatch_async(dispatch_get_main_queue(), ^{
#if _INTERNAL_MLF_RC_ENABLED
    [MLeaksMessenger alertWithTitle:@"Memory Leak"
                            message:[NSString stringWithFormat:@"leak object: %@, \nretain cycle: \n%@",className, retainCycleStr]
                           delegate:proxy
              additionalButtonTitle:@"Retain Cycle"];
#else
    [MLeaksMessenger alertWithTitle:@"Memory Leak"
                            message:[NSString stringWithFormat:@"%@", proxy.viewStack]];
#endif // _INTERNAL_MLF_RC_ENABLED
    });
}

+ (BOOL)checkIfRecorded:(NSString *)retainCycleStr {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pthread_mutex_init(&_mleakedLock, NULL);
        leakedRetainCycles = [NSMutableSet set];
    });
    
    pthread_mutex_lock(&_mleakedLock);
    BOOL recorded = [leakedRetainCycles containsObject:retainCycleStr];
    
    if (recorded) {
        pthread_mutex_unlock(&_mleakedLock);
        return YES;
    }
    
    [leakedRetainCycles addObject:retainCycleStr];
    pthread_mutex_unlock(&_mleakedLock);
    return NO;
}

+ (NSSet<NSString *> *)parseRetainCycleFromSet:(NSSet<NSArray<FBObjectiveCGraphElement *> *> *)set forClassName:(NSString *)className {
    if (!set || set.count == 0) { return nil; }
    NSMutableSet *retainCycleStrSet = [[NSMutableSet alloc] init];
    
    [set enumerateObjectsUsingBlock:^(NSArray<FBObjectiveCGraphElement *> * _Nonnull retainCycleArray, BOOL * _Nonnull stop) {
       
        NSMutableString *curRetainCycleStr = [[NSMutableString alloc] init];
        [retainCycleArray enumerateObjectsUsingBlock:^(FBObjectiveCGraphElement * element, NSUInteger idx, BOOL * _Nonnull stop) {
            // if element.namePath = nil, this class name is a internal class, or a key in dict, we need parse the name by object_getClass()
            if ((!element.namePath || !element.namePath.count) && element.object) {
                Class className = object_getClass(element.object);
                [curRetainCycleStr appendFormat:@"-> %@", className];
                return;
            }
            // element.namePath is generally an ivar of object in the retain cycle
            [element.namePath enumerateObjectsUsingBlock:^(NSString * _Nonnull namePath, NSUInteger namePathIdx, BOOL * _Nonnull stop) {
                if (namePath.length) {
                    [curRetainCycleStr appendFormat:@"-> %@",namePath];
                }
             
            }];
         
        }];
        
        if (curRetainCycleStr.length) {
            [curRetainCycleStr insertString:className atIndex:0];
            [curRetainCycleStr appendFormat:@"->%@",className];
            [curRetainCycleStr appendString:@";\n"];
            [retainCycleStrSet addObject:curRetainCycleStr];
        }
        
    }];

    return retainCycleStrSet;
}

+ (NSSet<NSArray<FBObjectiveCGraphElement *> *> *)tryFindRetainCycleFromObj:(id)object {
    FBRetainCycleDetector *detector = [FBRetainCycleDetector new];
    [detector findRetainCyclesWithMaxCycleLength:20];
    [detector addCandidate:object];
    NSSet *retainCycles = [detector findRetainCycles];
//    NSLog(@"retainCycles : %@", retainCycles);
    return retainCycles;
}

- (void)dealloc {
    NSNumber *objectPtr = _objectPtr;
//    NSArray *viewStack = _viewStack;
    dispatch_async(dispatch_get_main_queue(), ^{
        [leakedObjectPtrs removeObject:objectPtr];
//        [MLeaksMessenger alertWithTitle:@"Object Deallocated"
//                                message:[NSString stringWithFormat:@"%@", viewStack]];
    });
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!buttonIndex) {
        return;
    }
    
    id object = self.object;
    if (!object) {
        return;
    }
    
#if _INTERNAL_MLF_RC_ENABLED
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        FBRetainCycleDetector *detector = [FBRetainCycleDetector new];
        [detector addCandidate:self.object];
        NSSet *retainCycles = [detector findRetainCyclesWithMaxCycleLength:20];
        
        BOOL hasFound = NO;
        for (NSArray *retainCycle in retainCycles) {
            NSInteger index = 0;
            for (FBObjectiveCGraphElement *element in retainCycle) {
                if (element.object == object) {
                    NSArray *shiftedRetainCycle = [self shiftArray:retainCycle toIndex:index];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MLeaksMessenger alertWithTitle:@"Retain Cycle"
                                                message:[NSString stringWithFormat:@"%@", shiftedRetainCycle]];
                    });
                    hasFound = YES;
                    break;
                }
                
                ++index;
            }
            if (hasFound) {
                break;
            }
        }
        if (!hasFound) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MLeaksMessenger alertWithTitle:@"Retain Cycle"
                                        message:@"Fail to find a retain cycle"];
            });
        }
    });
#endif
}

- (NSArray *)shiftArray:(NSArray *)array toIndex:(NSInteger)index {
    if (index == 0) {
        return array;
    }
    
    NSRange range = NSMakeRange(index, array.count - index);
    NSMutableArray *result = [[array subarrayWithRange:range] mutableCopy];
    [result addObjectsFromArray:[array subarrayWithRange:NSMakeRange(0, index)]];
    return result;
}

@end
