//
//  JCComplexTableViewAdapter.h
//  JCImage
//
//  Created by jaycehan on 2024/1/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JCComplexTableViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCComplexTableViewAdapter : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) NSMutableArray<JCComplexTableViewCellModel *> *dataList;

+ (JCComplexTableViewCellModel *)generateRandomViewModel;

@end

NS_ASSUME_NONNULL_END
