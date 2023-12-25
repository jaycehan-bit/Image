//
//  JCEAGLView.h
//  JCImage
//
//  Created by jaycehan on 2023/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCEAGLView : UIView

@property (nonatomic, assign, readonly) BOOL perpared;

- (void)renderImageWithName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
