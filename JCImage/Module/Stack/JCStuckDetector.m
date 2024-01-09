//
//  JCStuckDetector.m
//  JCImage
//
//  Created by jaycehan on 2024/1/2.
//

#import "JCStuckDetector.h"
#import "JCStackFrameCatcher.h"

@interface JCStuckDetector ()

@property (nonatomic, strong) NSLock *observerLock;

@property (nonatomic, assign) CFRunLoopObserverRef runLoopObserver;

@property (nonatomic, assign) CFRunLoopActivity activity;

@property (nonatomic, strong) dispatch_queue_t detectorQueue;

@property (nonatomic, assign) BOOL cancelled;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation JCStuckDetector

- (instancetype)init {
    self = [super init];
    if (self) {
        self.detectInterval = 50;
        self.detectorQueue = dispatch_queue_create("com.JCImage.stuckQueue", DISPATCH_QUEUE_SERIAL);
        self.observerLock = [[NSLock alloc] init];
        CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL};
        //参数分别是: 分配空间 状态枚举 是否循环调用observer 优先级 回调函数 结构体
        self.runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
    }
    return self;
}

- (void)run {
    if (!self.cancelled) {
        return;
    }
    CFRunLoopAddObserver(CFRunLoopGetMain(), self.runLoopObserver, kCFRunLoopCommonModes);
    [self launchDetectorThread];
}

- (void)cancel {
    [self.observerLock lock];
    self.cancelled = YES;
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.runLoopObserver, kCFRunLoopCommonModes);
    [self.observerLock unlock];
}

- (void)setDetectInterval:(NSTimeInterval)detectInterval {
    [self.observerLock lock];
    _detectInterval = detectInterval;
    [self.observerLock unlock];
}

#pragma mark - Detect

- (void)launchDetectorThread {
    self.semaphore = dispatch_semaphore_create(1);
    dispatch_async(self.detectorQueue, ^{
        NSUInteger stayCount = 0;
        while (!self.cancelled) {
            intptr_t state = dispatch_semaphore_wait(self.semaphore, self.detectInterval);
            if (self.activity != kCFRunLoopBeforeSources && self.activity != kCFRunLoopAfterWaiting) {
                stayCount = 0;
                continue;
            }
            if (state == 0) {
                // 成功获取信号
                stayCount = 0;
                continue;
            }
            // 获取信号超时
            stayCount += 1;
            if (stayCount == 3) {
                // 卡顿
                [JCStackFrameCatcher runWithTestStack];
                stayCount = 0;
            }
        }
    });
}

#pragma mark - RunLoopObserverCallBack

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
    if (![((__bridge id)info) isKindOfClass:JCStuckDetector.class]) {
        return;
    }
    if (activity == kCFRunLoopBeforeSources || activity == kCFRunLoopAfterWaiting) {
        JCStuckDetector *detector = (__bridge id)info;
        detector.activity = activity;
        dispatch_semaphore_signal(detector.semaphore);
    }
}

@end
