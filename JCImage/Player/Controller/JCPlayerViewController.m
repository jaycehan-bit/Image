//
//  JCPlayerViewController.m
//  JCImage
//
//  Created by jaycehan on 2024/1/15.
//

#import "avformat.h"
#import "JCPlayerRenderView.h"
#import "JCPlayerVideoDecoder.h"
#import "JCPlayerViewController.h"
#import "JCPlayerVideoFrame.h"

static const CGFloat JCPlayerRatio = 16 / 9.0;

@interface JCPlayerViewController ()

@property (nonatomic, strong) UIBarButtonItem *button;

@property (nonatomic, strong) id<JCVideoDecoder> videoDecoder;

@property (nonatomic, strong) JCPlayerRenderView *playerView;

@end

@implementation JCPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.playerView];
    self.navigationItem.rightBarButtonItem = self.button;
}

- (void)playVideoWithURL:(NSString *)URL {
    if (!URL.length) {
        return;
    }
    [self.videoDecoder decodeVideoFrameWithURL:URL];
    [self.playerView renderVideoFrame:self.videoDecoder.frameBuffer[10]];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.playerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / JCPlayerRatio);
}

#pragma mark - Init

- (id<JCVideoDecoder>)videoDecoder {
    if (!_videoDecoder) {
        _videoDecoder = [[JCPlayerVideoDecoder alloc] init];
    }
    return _videoDecoder;
}

- (JCPlayerRenderView *)playerView {
    if (!_playerView) {
        _playerView = [[JCPlayerRenderView alloc] initWithFrame:CGRectZero];
        _playerView.backgroundColor = UIColor.blackColor;
    }
    return _playerView;
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

@end


@implementation JCPlayerViewController (JCPlayer)

- (void)play {
    
}

- (void)pause {
    
}

- (void)stop {
    
}

@end
