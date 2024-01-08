//
//  JCStuckDetector.m
//  JCImage
//
//  Created by jaycehan on 2024/1/2.
//

#import "JCStuckDetector.h"

@interface JCStuckDetector () <NSPortDelegate>

@property (nonatomic, strong) NSLock *observerLock;

@property (nonatomic, assign) CFRunLoopObserverRef runLoopObserver;

@property (nonatomic, assign) CFRunLoopActivity activity;

@property (nonatomic, strong) dispatch_queue_t detectorQueue;

@property (nonatomic, strong) NSThread *detectThread;

@property (nonatomic, assign) BOOL cancelled;

@property (nonatomic, strong) NSPort *port;

@end

@implementation JCStuckDetector

- (instancetype)init {
    self = [super init];
    if (self) {
        self.detectInterval = 100;
        self.detectorQueue = dispatch_queue_create("com.JCImage.stuckQueue", DISPATCH_QUEUE_SERIAL);
        self.observerLock = [[NSLock alloc] init];
        self.activity = kCFRunLoopEntry;
    }
    return self;
}

- (void)run {
    if (self.runLoopObserver) {
        return;
    }
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL};
    //参数分别是: 分配空间 状态枚举 是否循环调用observer 优先级 回调函数 结构体
    self.runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), self.runLoopObserver, kCFRunLoopCommonModes);
    
    self.detectThread = [[NSThread alloc] initWithBlock:^{
        self.port = [NSMachPort port];
        [[NSRunLoop currentRunLoop] addPort:self.port forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
    }];
    self.detectThread.name = @"WTF";
    [self.detectThread start];

}

- (void)WTF {
    NSLog(@"[RunLoopObserverCallBack] After");
}

- (void)cancel {
    self.cancelled = YES;
}

#pragma mark - Detect

- (void)didReceiveRunLoopActivity:(CFRunLoopActivity)activity {
    NSLog(@"%@", [NSThread currentThread]);
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
    if (activity == kCFRunLoopBeforeWaiting) {
        NSLog(@"[RunLoopObserverCallBack] before");
        JCStuckDetector *detector = (__bridge id)info;
        [detector performSelector:@selector(WTF) onThread:detector.detectThread withObject:nil waitUntilDone:NO];
    }
}

@end
