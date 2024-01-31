//
//  JCComplexTableViewAdapter.h
//  JCImage
//
//  Created by jaycehan on 2024/1/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JCComplexTableViewAdapterDataSource <NSObject>

- (CGFloat)tableViewWidth;

@end

@interface JCComplexTableViewAdapter : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<JCComplexTableViewAdapterDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
