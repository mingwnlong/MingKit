//
//  ViewController.m
//  Demo
//
//  Created by mini2019 on 2021/5/13.
//

#import "ViewController.h"
#import <XHLaunchAd.h>
static long long startvalue;
static NSString *title;
//static dispatch_source_t gcdTimer;
@interface ViewController ()

@property (nonatomic, strong) dispatch_queue_t gcdTimer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self sy_startTime];
}
/**
 倒计时方法二
 */
- (void)sy_startTime {
    if (_gcdTimer) {
        [self endTimer];
    }
    __block long long startvalue = [self currentTime]; // 倒计时开始时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_gcdTimer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0); // 每秒执行
    __block int totlal = 20;
    dispatch_source_set_event_handler(_gcdTimer, ^{
        int timeout = 0;
        long long currentvalue = [self currentTime];
        int tmp = (int)(currentvalue - startvalue);
        if (tmp >= totlal) {
            timeout = 0;
        } else if (tmp <= 0) {
            timeout = totlal;
        } else {
            timeout = totlal - tmp;
        }
        if (timeout <= 0) { //倒计时结束，关闭
            [self endTimer];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"倒计时 结束");
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"倒计时 %ld",timeout);
            });
        }
    });
    dispatch_resume(_gcdTimer);
}
- (void)endTimer {

    if (_gcdTimer) {
        dispatch_source_cancel(_gcdTimer);
        _gcdTimer = nil;
    }
}
- (void)dealloc {
    [self endTimer];
}
- (long long)currentTime {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    return (long long)a;
}

@end
