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

#import "NSObject+MemoryLeak.h"

#define MEMORY_LEAKS_FINDER_ENABLED 1

#if MEMORY_LEAKS_FINDER_ENABLED
#define _INTERNAL_MLF_ENABLED 1
#else
#define _INTERNAL_MLF_ENABLED DEBUG
#endif

#define MEMORY_LEAKS_FINDER_RETAIN_CYCLE_ENABLED 1

#if MEMORY_LEAKS_FINDER_RETAIN_CYCLE_ENABLED
#define _INTERNAL_MLF_RC_ENABLED 1
#elif COCOAPODS
#define _INTERNAL_MLF_RC_ENABLED COCOAPODS
#endif

@protocol MLFindLeakListener <NSObject>
@optional
- (void)findMemoryLeaksOfClassName:(NSString *)className retainCycle:(NSString *)retainCycle;

@end

@interface MLeaksFinder : NSObject
@property (nonatomic, assign) BOOL disableAlert; // default is NO, which means alertView will show when a memory leak is found

+ (instancetype)sharedInstance;

- (void)addMemoryLeakListener:(id<MLFindLeakListener>)listener;
- (void)removeMemoryLeakListener:(id<MLFindLeakListener>)listener;

- (void)notifyListenersMemoryLeakOfClassName:(NSString *)className retainCycle:(NSString *)retainCycle;

- (void)setupRetainCycleWhiteList:(NSArray<NSString *> *)whiteList;

- (BOOL)isInRetainCycleWhiteList:(NSString *)retainCycle;

@end
