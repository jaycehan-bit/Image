//
//  JCStuckViewController.m
//  JCImage
//
//  Created by jaycehan on 2024/1/26.
//

#import "JCComplexTableViewCell.h"
#import "JCComplexTableViewAdapter.h"
#import "JCStuckMaker.h"
#import "JCStuckViewController.h"

@interface JCStuckViewController ()

@property (nonatomic, strong) JCComplexTableViewAdapter *dataSource;

@property (nonatomic, strong) UIBarButtonItem *rightButton;

@end

@implementation JCStuckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    self.navigationItem.rightBarButtonItem = self.rightButton;
}

#pragma mark - DataSource

- (JCComplexTableViewAdapter *)dataSource {
    if (!_dataSource) {
        _dataSource = [[JCComplexTableViewAdapter alloc] init];
    }
    return _dataSource;
}

#pragma mark - Button

- (UIBarButtonItem *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIBarButtonItem alloc] initWithTitle:@"卡顿" style:UIBarButtonItemStylePlain target:self action:@selector(stuckButtonDidClick)];
        _rightButton.tintColor = UIColor.redColor;
    }
    return _rightButton;
}

- (void)stuckButtonDidClick {
    [JCStuckMaker stuckWithDegree:JCStuckDegreeModerate untilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
}

@end
