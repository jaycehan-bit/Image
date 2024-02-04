//
//  JCFreshTableViewController.m
//  JCImage
//
//  Created by jaycehan on 2024/2/1.
//

#import "JCFreshTableViewAdapter.h"
#import "JCFreshTableViewController.h"

@interface JCFreshTableViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIBarButtonItem *rightButton;

@property (nonatomic, strong) JCFreshTableViewAdapter *adapter;

@end

@implementation JCFreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _adapter = [[JCFreshTableViewAdapter alloc] init];
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = self.rightButton;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - Init

- (UIBarButtonItem *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIBarButtonItem alloc] initWithTitle:@"卡顿" style:UIBarButtonItemStylePlain target:self action:@selector(stuckButtonDidClick)];
        _rightButton.tintColor = UIColor.redColor;
    }
    return _rightButton;
}

- (void)stuckButtonDidClick {
    [self.adapter stuckUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        [_adapter bindTableView:_tableView];
    }
    return _tableView;
}

@end
