//
//  JCStuckDetectorX.m
//  JCImage
//
//  Created by jaycehan on 2024/1/31.
//

#import "JCStuckDetectorX.h"
#import "JCStackFrameCatcher.h"

static NSTimeInterval JCStuckThreshold = 0.1;

@interface JCStuckDetectorX ()

@property (nonatomic, assign, getter = isRunning) BOOL running;

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, strong) NSLock *lock;

@end

@implementation JCStuckDetectorX

static JCStuckDetectorX *detector = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        detector = [[JCStuckDetectorX alloc] init];
    });
    return detector;
}

- (instancetype)init {
    self = [super init];
    self.queue = dispatch_queue_create("com.JCImage.StuckDetectorXQueue", NULL);
    self.semaphore = dispatch_semaphore_create(0);
    self.lock = [[NSLock alloc] init];
    return self;
}

#pragma mark - Logic

- (void)beginMonitor {
    dispatch_async(self.queue, ^{
        while (self.isRunning) {
            __block BOOL signal = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                signal = YES;
                dispatch_semaphore_signal(self.semaphore);
            });
            [NSThread sleepForTimeInterval:JCStuckThreshold];
            if (!signal) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [JCStackFrameCatcher run];
                });
            }
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        }
    });
}

#pragma mark - JCStuckModule

- (void)run {
    if (self.isRunning) {
        return;
    }
    [self.lock lock];
    self.running = YES;
    [self.lock unlock];
    [self beginMonitor];
}

- (void)cancel {
    if (!self.isRunning) {
        return;
    }
    [self.lock lock];
    self.running = NO;
    [self.lock unlock];
}

@end
