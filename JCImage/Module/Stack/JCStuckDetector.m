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

static JCStuckDetector *detector = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        detector = [[JCStuckDetector alloc] init];
    });
    return detector;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.detectInterval = 20;
        self.detectorQueue = dispatch_queue_create("com.JCImage.stuckQueue", DISPATCH_QUEUE_SERIAL);
        self.observerLock = [[NSLock alloc] init];
        self.cancelled = YES;
    }
    return self;
}

- (void)run {
    if (!self.cancelled) {
        return;
    }
    [self.observerLock lock];
    self.cancelled = NO;
    [self.observerLock unlock];
    [self beginMonitor];
}

- (void)cancel {
    [self.observerLock lock];
    self.cancelled = YES;
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.runLoopObserver, kCFRunLoopCommonModes);
    [self.observerLock unlock];
}

- (void)setDetectInterval:(NSTimeInterval)detectInterval {
    _detectInterval = detectInterval;
}

#pragma mark - Detect

- (void)beginMonitor {
    CFRunLoopObserverContext context = {0,(__bridge void *)self, NULL, NULL};
    self.runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), self.runLoopObserver, kCFRunLoopCommonModes);
    self.semaphore = dispatch_semaphore_create(0);
    dispatch_async(self.detectorQueue, ^{
        while (!self.cancelled) {
            intptr_t state = dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, self.detectInterval * NSEC_PER_MSEC));
            if (state == 0) {
                // 成功获取信号
                continue;
            }
            if (self.activity == kCFRunLoopBeforeWaiting) {
                continue;
            }
            // 获取信号超时
            [JCStackFrameCatcher run];
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
//    NSLog(@"runLoopObserverCallBack:%@", activityStr);
    JCStuckDetector *detector = (__bridge id)info;
    detector.activity = activity;
    dispatch_semaphore_signal(detector.semaphore);
}

@end
