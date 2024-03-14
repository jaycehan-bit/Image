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

@end

@implementation JCPlayerSyncController

- (instancetype)init {
    self = [super init];
    if (self) {
        _decoder = [[JCPlayerDecoder alloc] init];
    }
    return self;
}

- (id<JCVideoInfo>)openFileWithFilePath:(NSString *)filePath; {
    NSError *error = nil;
    id<JCVideoInfo> videoFrame = [self.decoder openFileWithFilePath:filePath error:&error];
    
    if (!error) {
        return videoFrame;
    }
    return nil;
}

@end
