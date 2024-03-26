//
//  JCPlayerViewController.m
//  JCImage
//
//  Created by jaycehan on 2024/1/15.
//

#import "avformat.h"
#import "JCPlayerAudioRender.h"
#import "JCPlayerRenderView.h"
#import "JCPlayerViewController.h"
#import "JCPlayerSyncController.h"
#import "JCVideoFrame.h"

static const CGFloat JCPlayerRatio = 16 / 9.0;

@interface JCPlayerViewController () <JCPlayerAudioRenderDataSource>

@property (nonatomic, strong) UIBarButtonItem *button;

@property (nonatomic, strong) UIBarButtonItem *nextButton;

@property (nonatomic, strong) JCPlayerRenderView *playerView;

@property (nonatomic, strong) JCPlayerAudioRender *audioRender;

@property (nonatomic, strong) JCPlayerSyncController *syncController;

@end

@implementation JCPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.playerView];
    self.navigationItem.rightBarButtonItems = @[self.nextButton, self.button];
}

- (void)playVideoWithURL:(NSString *)URL {
    if (!URL.length) {
        return;
    }
    CFAbsoluteTime beforeOpenTime = CFAbsoluteTimeGetCurrent() * 1000;
    id<JCPlayerVideoContext> videoContext = [self.syncController openFileWithFilePath:URL];
    CFAbsoluteTime afterOpenTime = CFAbsoluteTimeGetCurrent() * 1000;
    NSLog(@"[JCPlayer] Open file time consuming:%f", afterOpenTime - beforeOpenTime);
    if (videoContext) {
        [self.playerView prepareWithVideoInfo:videoContext.videoInfo];
        [self.audioRender prepareWithVideoInfo:videoContext.audioInfo];
    }
    
    [self play];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.playerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / JCPlayerRatio);
}

#pragma mark - JCPlayerAudioRenderDataSource

- (void)fillAudioDataWithBuffer:(SInt16 *)audioBuffer numOfFrames:(NSUInteger)numOfFrames numOfChannels:(NSUInteger)numOfChannels {
    [self.syncController fillAudioRenderDataWithBuffer:audioBuffer numOfFrames:numOfFrames numOfChannels:numOfChannels];
    id<JCVideoFrame> videoFrame = [self.syncController renderedVideoFrame];
    if (videoFrame) {
        [self.playerView renderVideoFrame:videoFrame];
    }
}

#pragma mark - Init

- (JCPlayerRenderView *)playerView {
    if (!_playerView) {
        _playerView = [[JCPlayerRenderView alloc] initWithFrame:CGRectZero];
        _playerView.backgroundColor = UIColor.blackColor;
    }
    return _playerView;
}

- (JCPlayerAudioRender *)audioRender {
    if (!_audioRender) {
        _audioRender = [[JCPlayerAudioRender alloc] initWithDataSource:self];
    }
    return _audioRender;
}

- (JCPlayerSyncController *)syncController {
    if (!_syncController) {
        _syncController = [[JCPlayerSyncController alloc] init];
    }
    return _syncController;
}

#pragma mark - DEBUG

- (UIBarButtonItem *)button {
    if (!_button) {
        _button = [[UIBarButtonItem alloc] initWithTitle:@"测试" style:UIBarButtonItemStylePlain target:self action:@selector(debugButtonDidClick)];
        _button.tintColor = UIColor.redColor;
    }
    return _button;
}

- (void)debugButtonDidClick {
    NSString *path = [NSBundle.mainBundle pathForResource:@"StreetScenery.mp4" ofType:nil];
    [self playVideoWithURL:path];
}

- (UIBarButtonItem *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIBarButtonItem alloc] initWithTitle:@"下一帧" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonDidClick)];
        _nextButton.tintColor = UIColor.redColor;
    }
    return _nextButton;
}

- (void)nextButtonDidClick {
    static NSUInteger index = 1;
}

@end


@implementation JCPlayerViewController (JCPlayer)

- (void)play {
    [self.audioRender play];
}

- (void)pause {
    
}

- (void)stop {
    [self.audioRender stop];
}

@end
