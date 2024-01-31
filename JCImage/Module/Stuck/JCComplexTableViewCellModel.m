//
//  JCComplexTableViewCellModel.m
//  JCImage
//
//  Created by jaycehan on 2024/1/29.
//

#import "JCComplexTableViewCellModel.h"

@interface JCComplexTableViewCellModel()

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *date;

@end

@implementation JCComplexTableViewCellModel

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image {
    self = [super init];
    self.title = title;
    self.image = image;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    self.date = [formatter stringFromDate:[NSDate date]];
    return self;
}




@end
