//
//  InjectionManager.m
//  Test
//
//  Created by slj on 2019/04/24.
//  Copyright © 2019年 Meetyou. All rights reserved.
//

#import "InjectionHelper.h"
#import <sys/sysctl.h>

#ifdef DEBUG                //Debug下才生效
#if TARGET_IPHONE_SIMULATOR //模拟器下才生效


/**
 系统版本号判断

 @param v 版本号
 @return 结果
 */
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation InjectionHelper

/**
 UIApplication didFinishLaunching 执行后就启动
 */
+ (void)load {
    __block id observer =
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *_Nonnull note) {
                                                          [[self class] inject];
                                                          [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                      }];
}

#warning 如没有生效，记得在这里改路径
/**
 如没有生效，记得在这里改路径
 xcode10.1
 [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection10.bundle"] load];

 xcode10.2
 [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
 */
- (void)loadInjection {
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection10.bundle"] load];
}

+ (instancetype)sharedInstance {
    static InjectionHelper *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[InjectionHelper alloc] init];
    });
    return _manager;
}

//Start Injection (在didFinishLaunchingWithOptions开启)
+ (void)inject {
    [[self sharedInstance] loadInjection];
    [[self sharedInstance] addInjectionNotification];
}

- (void)addInjectionNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(injectionNotification:) name:@"INJECTION_BUNDLE_NOTIFICATION" object:nil];
}

- (void)injectionNotification:(NSNotification *)notification {
    NSLog(@"💉 Injection 通知类: %@", notification.object);
    UIViewController *VC = [NSObject ijc_getCurrentViewController];
    if (VC) {
        [VC loadView];
        [VC viewDidLoad];
        [VC viewWillLayoutSubviews];
        [VC viewWillAppear:NO];
        NSLog(@"💉 Injection 刷新类:【 %@】", NSStringFromClass([VC class]));
    } else {
        NSLog(@"💉 Injection 刷新失败，类: 【%@】", notification.object);
    }
}


@end


@implementation NSObject (InjectionIII)


+ (UIViewController *)ijc_getCurrentViewController {
    UIViewController *result = nil;
    // 获取默认的window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    // app默认windowLevel是UIWindowLevelNormal，如果不是，找到它。
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }

    // 获取window的rootViewController
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    return result;
}

/**
 获取view 所属的vc，失败为nil
 */
+ (UIViewController *)ijc_viewControllerSupportView:(UIView *)view {
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
+ (UIView *)ijc_getMainView {
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (!window)
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        return window;
    } else {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (window == nil)
            window = [[[UIApplication sharedApplication] delegate] window]; //#14
        return window;
    }
}

@end
#endif
#endif
