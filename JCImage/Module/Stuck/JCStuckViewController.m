//
//  JCStuckViewController.m
//  JCImage
//
//  Created by jaycehan on 2024/1/26.
//

#import "JCComplexTableViewCell.h"
#import "JCComplexTableViewAdapter.h"
#import "JCStuckViewController.h"

static NSString * const JCComplexTableViewCellIdentifier = @"JCComplexTableViewCellIdentifier";

@interface JCStuckViewController ()

@property (nonatomic, strong) JCComplexTableViewAdapter *dataSource;

@end

@implementation JCStuckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
}

#pragma mark - DataSource

- (JCComplexTableViewAdapter *)dataSource {
    if (!_dataSource) {
        _dataSource = [[JCComplexTableViewAdapter alloc] init];
    }
    return _dataSource;
}

@end
