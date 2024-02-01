//
//  JCStuckMaker.m
//  JCImage
//
//  Created by jaycehan on 2024/2/1.
//

#import "JCStuckMaker.h"

static NSTimer *timer = nil;

@implementation JCStuckMaker

+ (void)stuckWithDegree:(JCStuckDegree)degree untilDate:(NSDate *)limitDate {
    NSTimeInterval interval = 0.4;
    switch (degree) {
        case JCStuckDegreeMild:
            interval = 0.5;
            break;
        case JCStuckDegreeModerate:
            interval = 0.3;
            break;
        case JCStuckDegreeSerious:
            interval = 0.1;
            break;
        default:
            interval = 0.3;
            break;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self stuck];
    }];
    
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, limitDate.timeIntervalSinceNow * NSEC_PER_SEC);
    dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
        [timer invalidate];
        timer = nil;
    });
}

+ (void)stuck {
    for (NSUInteger index = 0; index < 1000; index ++) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
        [formatter stringFromDate:[NSDate date]];
    }
}

@end
