//
//  JCLeaksViewController.m
//  JCImage
//
//  Created by jaycehan on 2024/1/4.
//

#import "JCLeaksViewController.h"
#import "JCLeaskModuleDefine.h"

@interface JCLeaksViewDelegate : NSObject

- (void)registerDelegate:(id)delegate;

@property (nonatomic, copy) void(^block)(void);

@end

@implementation JCLeaksViewDelegate {
    NSMutableArray *_delegates;
}

- (void)registerDelegate:(id)delegate {
    if (!delegate) {
        return;
    }
    if (!_delegates) {
        _delegates = [NSMutableArray array];
    }
    [_delegates addObject:delegate];
}

@end

@interface JCLeaksViewController () {
    NSInteger _controllerID;
}

@property (nonatomic, strong) UIButton *leaksButton;

@property (nonatomic, strong) UIButton *safeButton;

@property (nonatomic, strong) JCLeaksViewDelegate *delegate;

@end

@implementation JCLeaksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.leaksButton];
    [self.view addSubview:self.safeButton];
    self.delegate = [[JCLeaksViewDelegate alloc] init];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.leaksButton.frame = CGRectMake(16, 200, self.view.bounds.size.width - 32, 80);
    self.safeButton.frame = CGRectMake(16, 400, self.view.bounds.size.width - 32, 80);
}

- (UIButton *)leaksButton {
    if (!_leaksButton) {
        _leaksButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leaksButton.titleLabel setText:@"leaks测试"];
        _leaksButton.titleLabel.textColor = UIColor.whiteColor;
        _leaksButton.backgroundColor = UIColor.orangeColor;
        _leaksButton.layer.cornerRadius = 10;
        [_leaksButton addTarget:self action:@selector(leaksButtonDidSelect) forControlEvents:UIControlEventTouchUpInside];
        [_leaksButton addTarget:self action:@selector(_leaksButtonDidSelect) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leaksButton;
}

- (void)leaksButtonDidSelect {
    [self.delegate registerDelegate:self];
}

- (void)_leaksButtonDidSelect {
    self.delegate.block = ^(){
        [self description];
    };
}

- (UIButton *)safeButton {
    if (!_safeButton) {
        _safeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_safeButton.titleLabel setText:@"free测试"];
        _safeButton.titleLabel.textColor = UIColor.whiteColor;
        _safeButton.backgroundColor = UIColor.greenColor;
        _safeButton.layer.cornerRadius = 10;
        [_safeButton addTarget:self action:@selector(leaksButtonDidSelect) forControlEvents:UIControlEventTouchUpInside];
    }
    return _safeButton;
}

- (void)safeButtonDidSelect {
    
}

- (void)dealloc {
    
}

@end
