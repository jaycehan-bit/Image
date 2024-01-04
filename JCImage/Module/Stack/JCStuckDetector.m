//
//  JCStuckDetector.m
//  JCImage
//
//  Created by jaycehan on 2024/1/2.
//

#import "JCStuckDetector.h"

@interface JCStuckDetector ()

@property (nonatomic, strong) NSLock *observerLock;

@property (nonatomic, assign) CFRunLoopObserverRef runLoopObserver;

@property (nonatomic, strong) dispatch_queue_t detectorQueue;

@property (nonatomic, assign) BOOL cancelled;

@end

@implementation JCStuckDetector

- (instancetype)init {
    self = [super init];
    if (self) {
        self.detectInterval = 100;
        self.detectorQueue = dispatch_queue_create("com.JCImage.stuckQueue", DISPATCH_QUEUE_SERIAL);
        self.observerLock = [[NSLock alloc] init];
    }
    return self;
}

- (void)run {
    [self.observerLock lock];
    if (self.runLoopObserver) {
        return;
    }
    [self.observerLock unlock];
    dispatch_async(self.detectorQueue, ^{
        [self.observerLock lock];
        CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL};
        //参数分别是: 分配空间 状态枚举 是否循环调用observer 优先级 回调函数 结构体
        self.runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
        CFRunLoopAddObserver(CFRunLoopGetMain(), self.runLoopObserver, kCFRunLoopCommonModes);
        [self.observerLock unlock];
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
//        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
//        [[NSRunLoop currentRunLoop] run];
//        while (!self.cancelled) {
//            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];
//        }
    });
}

- (void)cancel {
    self.cancelled = YES;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NSString *activityStr = @"";
    switch (activity) {
        case kCFRunLoopEntry:
            activityStr = @"kCFRunLoopEntry";
            break;
        case kCFRunLoopBeforeTimers:
            activityStr = @"kCFRunLoopBeforeTimers";
            break;
        case kCFRunLoopBeforeSources:
            activityStr = @"kCFRunLoopBeforeSources";
            break;
        case kCFRunLoopBeforeWaiting:
            activityStr = @"kCFRunLoopBeforeWaiting";
            break;
        case kCFRunLoopAfterWaiting:
            activityStr = @"kCFRunLoopAfterWaiting";
            break;
        case kCFRunLoopExit:
            activityStr = @"kCFRunLoopExit";
            break;
        default:
            break;
    }
//    NSLog(@"RunloopCallBack:%@", activityStr);
}

@end
