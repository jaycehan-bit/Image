//
//  JCPlayerAudioRender.m
//  JCImage
//
//  Created by jaycehan on 2024/3/18.
//

#import <AudioToolbox/AUComponent.h>
#import <AudioToolbox/AudioComponent.h>
#import <AudioToolbox/AudioOutputUnit.h>
#import <AudioToolbox/AudioUnitProperties.h>
#import <AVFAudio/AVAudioSession.h>
#import "JCPlayerAudioRender.h"

#define K_OUTPUT 0
#define K_INPUT 0

@interface JCPlayerAudioRender ()

@property (nonatomic, assign) AudioUnit audioUnit;

@property (nonatomic, strong) id<JCAudioInfo> audioInfo;
           
@property (nonatomic, weak) id<JCPlayerAudioRenderDataSource> dataSource;

@end

@implementation JCPlayerAudioRender

- (instancetype)initWithDataSource:(id<JCPlayerAudioRenderDataSource>)dataSource {
    self = [super init];
    self.dataSource = dataSource;
    return self;
}

- (void)prepareWithVideoInfo:(id<JCAudioInfo>)videoInfo {
    if (!videoInfo) {
        return;
    }
    self.audioInfo = videoInfo;
    NSError *error = [self initializeAudioSession];
    if (error) {
        return;
    }
    [self configAudioComponentInstance];
    [self configAudioStreamFormatWithAudioInfo:videoInfo];
    [self configAudioRenderCallBack];
    AudioUnitInitialize(_audioUnit);
}

- (NSError *)initializeAudioSession {
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"❌❌❌ Fail to init audioSession");
        return error;
    }
    [audioSession setActive:YES error:&error];
    if (error) {
        NSLog(@"❌❌❌ Fail to active audioSession");
        return error;
    }
    NSLog(@"✅✅✅ initialize audioSession success");
    return nil;
}

- (void)configAudioComponentInstance {
    AudioComponentDescription description;
    description.componentType = kAudioUnitType_Output;          // IO功能的AudioUnit
    description.componentSubType = kAudioUnitSubType_RemoteIO;  // 采集/播放音频
    description.componentManufacturer = kAudioUnitManufacturer_Apple;   // 制造商
    description.componentFlags = 0;
    description.componentFlagsMask = 0;
    // AudioComponentFindNext 函数的结果是对定义音频单元的动态链接库的引用
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &description);
    // 将引用传递给 AudioComponentInstanceNew 函数来实例化音频单元
    AudioComponentInstanceNew(inputComponent, &_audioUnit);
}

/**
 *参考
 *https://developer.apple.com/library/archive/documentation/MusicAudio/Conceptual/AudioUnitHostingGuide_iOS/UsingSpecificAudioUnits/UsingSpecificAudioUnits.html#//apple_ref/doc/uid/TP40009492-CH17-SW1
 */
- (void)configAudioStreamFormatWithAudioInfo:(id<JCAudioInfo>)audioInfo {
    AudioStreamBasicDescription audioFormat;
    // 必须初始化为0，保证没有垃圾数据
    memset(&audioFormat, 0, sizeof(AudioStreamBasicDescription));
    audioFormat.mFormatID = kAudioFormatLinearPCM;    // PCM格式
    audioFormat.mFormatFlags = kAudioFormatFlagIsFloat | kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
    audioFormat.mSampleRate = audioInfo.sampleRate;        // 采样率
    audioFormat.mFramesPerPacket = 1;      // 每帧1个packet
    audioFormat.mChannelsPerFrame = audioInfo.channels;    // 声道数
    audioFormat.mBytesPerFrame = 2;        // 每帧2byte
    audioFormat.mBitsPerChannel = (UInt32)audioInfo.codedSampleBits;      // 位深
    AudioUnitSetProperty(_audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, K_OUTPUT, &audioFormat, sizeof(audioFormat));
}

- (void)configAudioRenderCallBack {
    AURenderCallbackStruct renderCallBackStruct;
    renderCallBackStruct.inputProc = renderCallBack;
    renderCallBackStruct.inputProcRefCon = (__bridge void *)self;
    AudioUnitSetProperty(_audioUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, K_OUTPUT, &renderCallBackStruct, sizeof(renderCallBackStruct));
}

static OSStatus renderCallBack(void *inRefCon,
                               AudioUnitRenderActionFlags *ioActionFlags,
                               const AudioTimeStamp *inTimeStamp,
                               UInt32 inBusNumber,
                               UInt32 inNumberFrames,
                               AudioBufferList * __nullable ioData) {
    JCPlayerAudioRender *audioRender = (__bridge JCPlayerAudioRender *)(inRefCon);
    return [audioRender fillRenderData:ioData numberOfFrames:inNumberFrames];
}

#pragma mark - FillAudioData

- (OSStatus)fillRenderData:(AudioBufferList *)bufferList numberOfFrames:(UInt32)numberOfFrames {
    for (NSUInteger index = 0; index < bufferList->mNumberBuffers; index++) {
        memset(bufferList->mBuffers[index].mData, 0, bufferList->mBuffers[index].mDataByteSize);
    }
    static SInt16 buffer[8192] = {0};
    if ([self.dataSource respondsToSelector:@selector(fillAudioDataWithBuffer:numOfFrames:numOfChannels:)]) {
        memset(buffer, 0, sizeof(buffer) / sizeof(SInt16));
        [self.dataSource fillAudioDataWithBuffer:buffer numOfFrames:numberOfFrames numOfChannels:self.audioInfo.channels];
        for (NSUInteger index = 0; index < bufferList->mNumberBuffers; index++) {
            memcmp(bufferList->mBuffers[index].mData, buffer, bufferList->mBuffers[index].mDataByteSize);
        }
    }
    return noErr;
}

#pragma mark - JCPlayer

- (void)play {
    AudioOutputUnitStart(_audioUnit);
}

- (void)pause {
    
}

- (void)stop {
    AudioOutputUnitStop(_audioUnit);
}

@end
