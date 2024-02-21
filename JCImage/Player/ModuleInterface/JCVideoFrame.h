//
//  JCVideoFrame.h
//  JCImage
//
//  Created by jaycehan on 2024/2/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JCVideoFrame <NSObject>

@property (nonatomic, assign, readonly) CGFloat height;

@property (nonatomic, assign, readonly) CGFloat width;

@property (nonatomic, strong, readonly) id imageBuffer;

@property (nonatomic, copy) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
