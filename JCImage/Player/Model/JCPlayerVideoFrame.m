//
//  JCPlayerVideoFrame.m
//  JCImage
//
//  Created by jaycehan on 2024/2/4.
//

#import <UIKit/UIKit.h>
#import "JCPlayerVideoFrame.h"

@interface JCPlayerVideoFrame ()

@end

@implementation JCPlayerVideoFrame

@synthesize height, width, imageBuffer, imageName;

- (id)imageBuffer {
#if DEBUG
    UIImage *image = [UIImage imageNamed:@"Seraphine.jpg"];
    CGDataProviderRef dataProvider = CGImageGetDataProvider(image.CGImage);
    CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
    uint8_t *pixel = (uint8_t *)CFDataGetBytePtr(dataRef);
//    CGFloat height = image.size.height / image.size.width * self.backingWidth;

#endif
    return nil;
}

@end

/*
CGImageRef imageRef = image.CGImage;
CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
uint8_t *pixel = (uint8_t *)CFDataGetBytePtr(dataRef);
CGFloat height = image.size.height / image.size.width * self.backingWidth;
*/
