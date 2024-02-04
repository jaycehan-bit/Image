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

@end

@implementation JCLeaksViewDelegate {
    NSMutableArray *_delegateList;
}

- (void)registerDelegate:(id)delegate {
    if (!delegate) {
        return;
    }
    if (!_delegateList) {
        _delegateList = [NSMutableArray array];
    }
    [_delegateList addObject:delegate];
}

@end

@interface JCLeaksViewController ()

@property (nonatomic, strong) UIButton *pushButton;

@property (nonatomic, strong) UIButton *presentButton;

@property (nonatomic, strong) JCLeaksViewDelegate *delegate;

@end

@implementation JCLeaksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.pushButton];
    [self.view addSubview:self.presentButton];
    self.delegate = [[JCLeaksViewDelegate alloc] init];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pushButton.frame = CGRectMake(16, 200, self.view.bounds.size.width - 32, 80);
    self.presentButton.frame = CGRectMake(16, 400, self.view.bounds.size.width - 32, 80);
}

- (UIButton *)pushButton {
    if (!_pushButton) {
        _pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pushButton setTitle:@"Push测试" forState:UIControlStateNormal];
        [_pushButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _pushButton.backgroundColor = UIColor.orangeColor;
        _pushButton.layer.cornerRadius = 10;
        [_pushButton addTarget:self action:@selector(leaksButtonDidSelect) forControlEvents:UIControlEventTouchUpInside];
        [_pushButton addTarget:self action:@selector(pushButtonDidSelect) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushButton;
}

- (void)leaksButtonDidSelect {
    [self.delegate registerDelegate:self];
}

- (void)pushButtonDidSelect {
    UIViewController *viewController = [[JCLeaksViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UIButton *)presentButton {
    if (!_presentButton) {
        _presentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_presentButton setTitle:@"Present测试" forState:UIControlStateNormal];
        [_presentButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _presentButton.backgroundColor = UIColor.greenColor;
        _presentButton.layer.cornerRadius = 10;
        [_presentButton addTarget:self action:@selector(presentButtonDidSelect) forControlEvents:UIControlEventTouchUpInside];
        [_presentButton addTarget:self action:@selector(leaksButtonDidSelect) forControlEvents:UIControlEventTouchUpInside];
    }
    return _presentButton;
}

- (void)presentButtonDidSelect {
    UIViewController *viewController = [[JCLeaksViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
