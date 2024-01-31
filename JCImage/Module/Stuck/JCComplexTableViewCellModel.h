//
//  JCComplexTableViewCellModel.h
//  JCImage
//
//  Created by jaycehan on 2024/1/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCComplexTableViewCellModel : NSObject

@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, strong, readonly) UIImage *image;

@property (nonatomic, copy, readonly) NSString *date;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
