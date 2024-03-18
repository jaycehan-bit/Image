//
//  JCPlayerAudioRender.m
//  JCImage
//
//  Created by jaycehan on 2024/3/18.
//

#import <AudioToolbox/AUComponent.h>
#import <AudioToolbox/AudioComponent.h>
#import <AudioToolbox/AudioUnitProperties.h>
#import <AVFAudio/AVAudioSession.h>
#import "JCPlayerAudioRender.h"

#define K_OUTPUT 0
#define K_INPUT 0

@interface JCPlayerAudioRender ()

@property (nonatomic, assign) AudioUnit audioUnit;

@end

@implementation JCPlayerAudioRender

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

- (void)configAudioComponentInformation {
    AudioComponentDescription description;
    description.componentType = kAudioUnitType_Output;          // IO功能的AudioUnit
    description.componentSubType = kAudioUnitSubType_RemoteIO;  // 采集/播放音频
    description.componentManufacturer = kAudioUnitManufacturer_Apple;   // 制造商
    description.componentFlags = 0;
    description.componentFlagsMask = 0;
    
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &description);
    AudioComponentInstanceNew(inputComponent, &_audioUnit);
    UInt32 enableOutput = 1;
    OSStatus status = AudioUnitSetProperty(_audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, K_OUTPUT, &enableOutput, sizeof(enableOutput));
    
}

- (void)configAudioStreamFormat {
    AudioStreamBasicDescription audioFormat;
    memset(&audioFormat, 0, sizeof(AudioStreamBasicDescription));
    audioFormat.mSampleRate = 44100;                  // 采样率
    audioFormat.mFormatID = kAudioFormatLinearPCM;    // PCM格式
    audioFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger;    // 整型
    audioFormat.mFramesPerPacket = 1;      // 每帧1个packet
    audioFormat.mChannelsPerFrame = 1;     // 声道数
    audioFormat.mBytesPerFrame = 2;        // 每帧2byte
    audioFormat.mBitsPerChannel = 16;      // 位深
    AudioUnitSetProperty(_audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, K_OUTPUT, &audioFormat, sizeof(audioFormat));
}

- (void)configAudioRenderCallBack {
    AURenderCallbackStruct renderCallBackStruct;
    renderCallBackStruct.inputProc = renderCallBack;
    renderCallBackStruct.inputProcRefCon = (__bridge void *)self;
    AudioUnitSetProperty(_audioUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, K_OUTPUT, &renderCallBackStruct, sizeof(renderCallBackStruct));
}

OSStatus renderCallBack(void *inRefCon, 
                        AudioUnitRenderActionFlags *ioActionFlags,
                        const AudioTimeStamp *inTimeStamp,
                        UInt32 inBusNumber,
                        UInt32 inNumberFrames,
                        AudioBufferList * __nullable ioData) {
#pragma mark - TODO: Fill ioData
    
    return noErr;
}


@end
