//
//  JCFreshTableViewAdapter.m
//  JCImage
//
//  Created by jaycehan on 2024/2/1.
//

#import "JCFreshTableViewAdapter.h"

@interface JCFreshTableViewAdapter ()

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JCFreshTableViewAdapter

- (void)bindTableView:(UITableView *)tableView {
    _tableView = tableView;
}

- (void)stuckUntilDate:(NSDate *)limitDate {
    NSTimeInterval interval = 0.025;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self makeStuck];
    }];
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, limitDate.timeIntervalSinceNow * NSEC_PER_SEC);
    dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
        [self.timer invalidate];
        self.timer = nil;
    });
}

- (void)makeStuck {
    JCComplexTableViewCellModel *viewModel = [self.class generateRandomViewModel];
    [self.dataList insertObject:viewModel atIndex:0];
    [self.tableView reloadData];
}

@end
