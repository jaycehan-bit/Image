//
//  JCPlayerViewController.m
//  JCImage
//
//  Created by jaycehan on 2024/1/15.
//

#import "avformat.h"
#import "JCPlayerRenderView.h"
#import "JCPlayerViewController.h"
#import "JCPlayerSyncController.h"
#import "JCVideoFrame.h"

static const CGFloat JCPlayerRatio = 16 / 9.0;

@interface JCPlayerViewController ()

@property (nonatomic, strong) UIBarButtonItem *button;

@property (nonatomic, strong) UIBarButtonItem *nextButton;

@property (nonatomic, strong) JCPlayerRenderView *playerView;

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
    id<JCVideoInfo> videoInfo = [self.syncController openFileWithFilePath:URL];
    [self.playerView prepareWithVideoInfo:videoInfo];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.playerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / JCPlayerRatio);
}

#pragma mark - Init

- (JCPlayerRenderView *)playerView {
    if (!_playerView) {
        _playerView = [[JCPlayerRenderView alloc] initWithFrame:CGRectZero];
        _playerView.backgroundColor = UIColor.blackColor;
    }
    return _playerView;
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
//    if (index >= self.videoDecoder.frameBuffer.count) {
//        index = 0;
//    }
//    [self.playerView renderVideoFrame:self.videoDecoder.frameBuffer[index]];
    index += 1;
}

@end


@implementation JCPlayerViewController (JCPlayer)

- (void)play {
    
}

- (void)pause {
    
}

- (void)stop {
    
}

@end
