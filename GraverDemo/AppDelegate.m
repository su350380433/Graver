//
//  AppDelegate.m
//  GraverDemo
//
//  Created by yangyang on 2018/11/29.
//

#import "AppDelegate.h"
#import "ExamplesViewController.h"
#ifdef DEBUG
#import <DoraemonKit/DoraemonManager.h>


#endif
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef DEBUG
    [[DoraemonManager shareInstance] install];
    //链式调用 是否显示警告框 是否显示错误信息 是否回调日志地址
//    InstanceYQUncaughtExceptionHandler().showAlert(YES).showErrorInfor(YES).getlogPathBlock(^(NSString *logPathStr){
//        NSLog(@"程序异常日志地址 == %@",logPathStr);
//    });
#endif
    ExamplesViewController *examplesViewController = [[ExamplesViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:examplesViewController];
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];

#if DEBUG
//    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection10.bundle"] load];
//    [InjectionManager inject];
#endif
    //    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
