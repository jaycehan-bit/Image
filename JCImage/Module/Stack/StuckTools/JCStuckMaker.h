//
//  JCStuckMaker.h
//  JCImage
//
//  Created by jaycehan on 2024/2/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JCStuckDegree) {
    JCStuckDegreeMild,
    JCStuckDegreeModerate,
    JCStuckDegreeSerious,
};

@interface JCStuckMaker : NSObject

+ (void)stuckWithDegree:(JCStuckDegree)degree untilDate:(NSDate *)limitDate;

@end

NS_ASSUME_NONNULL_END
