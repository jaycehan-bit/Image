//
//  JCViewHookModule.m
//  JCImage
//
//  Created by jaycehan on 2024/2/1.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <Aspects/Aspects.h>
#import "JCViewHookModule.h"

@interface UITableView (JCHook)

@property (nonatomic, assign) CGFloat refreshFrequency;

@end

@implementation UITableView (JCHook)

@dynamic refreshFrequency;

- (void)setRefreshFrequency:(CGFloat)refreshFrequency {
    objc_setAssociatedObject(self, @selector(refreshFrequency), @(refreshFrequency), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)refreshFrequency {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

@end

@interface UIView (JCHook)

@property (nonatomic, assign) CGFloat layoutFrequency;

@end

@implementation UIView (JCHook)

@dynamic layoutFrequency;

- (void)setLayoutFrequency:(CGFloat)layoutFrequency {
    objc_setAssociatedObject(self, @selector(layoutFrequency), @(layoutFrequency), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)layoutFrequency {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

@end

@implementation JCViewHookModule

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UITableView aspect_hookSelector:@selector(reloadData) withOptions:AspectPositionBefore usingBlock:^{
            
        } error:nil];
        
        [UIView aspect_hookSelector:@selector(setNeedsLayout) withOptions:AspectPositionBefore usingBlock:^{
            
        } error:nil];
    });
}

@end
