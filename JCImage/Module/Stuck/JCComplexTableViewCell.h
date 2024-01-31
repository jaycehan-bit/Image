//
//  JCComplexTableViewCell.h
//  JCImage
//
//  Created by jaycehan on 2024/1/26.
//

#import <UIKit/UIKit.h>
#import "JCComplexTableViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCComplexTableViewCell : UITableViewCell

+ (CGFloat)heightForViewModel:(JCComplexTableViewCellModel *)viewModel;

- (void)bindViewModel:(JCComplexTableViewCellModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
