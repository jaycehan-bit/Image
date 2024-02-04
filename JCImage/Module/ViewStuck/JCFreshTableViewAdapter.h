//
//  JCFreshTableViewAdapter.h
//  JCImage
//
//  Created by jaycehan on 2024/2/1.
//

#import "JCComplexTableViewAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCFreshTableViewAdapter : JCComplexTableViewAdapter

- (void)stuckUntilDate:(NSDate *)limitDate;

- (void)bindTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
