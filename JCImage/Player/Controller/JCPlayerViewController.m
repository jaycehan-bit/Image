//
//  JCPlayerViewController.m
//  JCImage
//
//  Created by jaycehan on 2024/1/15.
//

#import "avformat.h"
#import "JCPlayerVideoDecoder.h"
#import "JCPlayerViewController.h"

@interface JCPlayerViewController ()

@property (nonatomic, strong) UIBarButtonItem *button;

@property (nonatomic, strong) id<JCVideoDecoder> videoDecoder;

@end

@implementation JCPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    self.navigationItem.rightBarButtonItem = self.button;
}

- (void)playVideoWithURL:(NSString *)URL {
    if (!URL.length) {
        return;
    }
    [self.videoDecoder decodeVideoFrameWithURL:URL];
}

#pragma mark - Init

- (id<JCVideoDecoder>)videoDecoder {
    if (!_videoDecoder) {
        _videoDecoder = [[JCPlayerVideoDecoder alloc] init];
    }
    return _videoDecoder;
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
