//
//  JCPlayerSyncController.m
//  JCImage
//
//  Created by jaycehan on 2024/3/13.
//

#import "JCPlayerDecoder.h"
#import "JCPlayerSyncController.h"

@interface JCPlayerSyncController ()

@property (nonatomic, strong) JCPlayerDecoder *decoder;

@property (nonatomic, strong) NSMutableArray<id<JCVideoFrame>> *videoFrameQueue;

@property (nonatomic, strong) NSMutableArray<id<JCAudioFrame>> *audioFrameQueue;

@property (nonatomic, strong) dispatch_queue_t decodeQueue;

@property (nonatomic, assign, getter=isRunning) BOOL running;

@property (nonatomic, strong) NSLock *lock;

@end

@implementation JCPlayerSyncController

- (instancetype)init {
    self = [super init];
    if (self) {
        _decoder = [[JCPlayerDecoder alloc] init];
        _videoFrameQueue = [NSMutableArray array];
        _audioFrameQueue = [NSMutableArray array];
    }
    return self;
}

- (id<JCPlayerVideoContext>)openFileWithFilePath:(NSString *)filePath; {
    NSError *error = nil;
    id<JCPlayerVideoContext> videoContext = [self.decoder openFileWithFilePath:filePath error:&error];
    if (!error && videoContext) {
        [self startDecodingLoop];
        return videoContext;
    }
    return nil;
}

#pragma mark - Decoding Logic

- (void)startDecodingLoop {
    while (self.isRunning) {
        
    }
}

#pragma mark - Decoding Control

- (void)run {
    if (self.isRunning) {
        return;
    }
    [self.lock lock];
    self.running = YES;
    [self.lock unlock];
}

- (void)stop {
    if (!self.isRunning) {
        return;
    }
    [self.lock lock];
    self.running = NO;
    [self.lock unlock];
}

- (dispatch_queue_t)decodeQueue {
    if (!_decodeQueue) {
        _decodeQueue = dispatch_queue_create("com.github.jaycehan.decodequeue", DISPATCH_QUEUE_SERIAL);
    }
    return _decodeQueue;
}
    
@end
