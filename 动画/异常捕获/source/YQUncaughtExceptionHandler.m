//
//  YQUncaughtExceptionHandler.m
//  YQUncaughtExceptionHandler
//
//  Created by slj on 2019/5/17.
//  Copyright © 2019年 meetyou. All rights reserved.
//

#ifdef DEBUG                // Debug下才生效
#if TARGET_IPHONE_SIMULATOR //模拟器下才生效

#import "YQUncaughtExceptionHandler.h"
#import "YQCashAppInfoUtil.h"
#import "YQSendMsg4DingDing.h"
#import <UIKit/UIKit.h>
#include <execinfo.h>
#include <libkern/OSAtomic.h>

NSString *const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString *const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString *const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@interface YQUncaughtExceptionHandler ()

@property (nonatomic, assign) BOOL isShowAlert;
@property (nonatomic, assign) BOOL dismissed;
@property (nonatomic, assign) BOOL isShowErrorInfor;
@property (nonatomic, strong) NSString *alertMessage; //警告提示消息

@end

@implementation YQUncaughtExceptionHandler

+ (void)load {
    InstanceYQUncaughtExceptionHandler().showAlert(YES).showErrorInfor(YES).getlogPathBlock(^(NSString *logPathStr) {
        NSLog(@"程序异常日志地址 == %@", logPathStr);
    });
}

+ (instancetype)shareInstance {
    static YQUncaughtExceptionHandler *_manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[self alloc] init];
        [_manager uiConfig];
    });
    return _manager;
}

#pragma mark - 设置日志存取的路径
- (void)uiConfig {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"YQUncaughtExceptionHandlerLog.txt"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:[@"~~~~~~~~~~~~~~~~~~程序异常日志~~~~~~~~~~~~~~~~~~\n\n" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    self.logFilePath = filePath;
}

- (void)handleException:(NSException *)exception {
    //保存日志 可以发送日志到自己的服务器上
    [self validateAndSaveCriticalApplicationData:exception];
    NSString *_erroeMeg = nil;
    NSString *userInfo = [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey];
    if (self.isShowErrorInfor) {
        _erroeMeg = [NSString stringWithFormat:NSLocalizedString(@"异常原因如下:\n%@\n%@", nil), [exception reason], userInfo];
    } else {
        _erroeMeg = [NSString stringWithFormat:NSLocalizedString(@"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开", nil)];
    }


    NSString *appInfoString = [NSString stringWithFormat:NSLocalizedString(
                                                             @"应用名称：%@ \n"
                                                             @"Bundle Id：%@ \n"
                                                             @"应用版本：%@(%@) \n"
                                                             @"崩溃时间：%@ \n"
                                                             @"手机系统：%@ \n"
                                                             @"手机型号：%@ \n",
                                                             nil),
                                                         [YQCashAppInfoUtil appName],
                                                         [YQCashAppInfoUtil bundleIdentifier],
                                                         [YQCashAppInfoUtil bundleVersion],
                                                         [YQCashAppInfoUtil bundleShortVersionString],
                                                         [self currentTimeString],
                                                         [YQCashAppInfoUtil iphoneSystemVersion],
                                                         [YQCashAppInfoUtil iphoneName]];

    NSString *cashInfoString = [NSString stringWithFormat:@"%@\n%@", appInfoString, _erroeMeg];
    YQDingDingModel *model = [YQSendMsg4DingDing getDingDingConfig];
    model.message = cashInfoString;

    __weak typeof(self) weakSelf = self;
    [YQSendMsg4DingDing sendMessageToDingDingWithMassage:model.message
                                                      at:nil
                                                 dingUrl:model.url
                                                  finish:^(id _Nonnull Data, NSError *_Nonnull error) {
                                                      if (!error) {
                                                          if (weakSelf.isShowAlert) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉,程序出现了异常"
                                                                                                                  message:@"\n\n不要紧张,崩溃错误日志已发送至钉钉消息~"
                                                                                                                 delegate:self
                                                                                                        cancelButtonTitle:@"退出程序"
                                                                                                        otherButtonTitles:@"继续玩耍",
                                                                                                                          nil];

                                                                  [alert show];
                                                              });
                                                          }
                                                      }
                                                  }];

    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    while (!_dismissed) {
        for (NSString *mode in (__bridge NSArray *)allModes) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    CFRelease(allModes);
#pragma clang diagnostic pop
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    } else {
        [exception raise];
    }
}

//点击退出
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex {
#pragma clang diagnostic pop
    if (anIndex == 0) {
        self.dismissed = YES;
    }
}

+ (NSArray *)backtrace {
    void *callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = UncaughtExceptionHandlerSkipAddressCount; i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}

#pragma mark - 保存错误信息日志
- (void)validateAndSaveCriticalApplicationData:(NSException *)exception {
    NSString *exceptionMessage = [NSString stringWithFormat:NSLocalizedString(@"\n******************** %@ 异常原因如下: ********************\n%@\n%@\n==================== End ====================\n\n", nil), [self currentTimeString], [exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]];
    NSFileHandle *handle = [NSFileHandle fileHandleForUpdatingAtPath:self.logFilePath];
    [handle seekToEndOfFile];
    [handle writeData:[exceptionMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
    if (self.pathBlock) {
        self.pathBlock(self.logFilePath);
    }
}

- (NSString *)currentTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

- (YQUncaughtExceptionHandler * (^)(BOOL isShow))showAlert {
    return ^(BOOL isShow) {
        self.isShowAlert = isShow;
        return [YQUncaughtExceptionHandler shareInstance];
    };
}

- (YQUncaughtExceptionHandler * (^)(BOOL isShow))showErrorInfor {
    return ^(BOOL isShow) {
        self.isShowErrorInfor = isShow;
        return [YQUncaughtExceptionHandler shareInstance];
    };
}

- (YQUncaughtExceptionHandler * (^)(void (^logPathBlock)(NSString *pathStr)))getlogPathBlock {
    return ^(void (^logPathBlock)(NSString *pathStr)) {
        self.pathBlock = logPathBlock;
        return [YQUncaughtExceptionHandler shareInstance];
    };
}

@end


void HandleException(NSException *exception) {
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    //如果太多不用处理
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    //获取调用堆栈
    NSArray *callStack = [exception callStackSymbols];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    //在主线程中，执行制定的方法, withObject是执行方法传入的参数
    [[YQUncaughtExceptionHandler shareInstance] performSelectorOnMainThread:@selector(handleException:) withObject:[NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo] waitUntilDone:YES];
}

void SignalHandler(int signal) {
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    NSArray *callStack = [YQUncaughtExceptionHandler backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [[YQUncaughtExceptionHandler shareInstance] performSelectorOnMainThread:@selector(handleException:) withObject:[NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.", nil), signal] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey]] waitUntilDone:YES];
}

YQUncaughtExceptionHandler *InstanceYQUncaughtExceptionHandler(void) {
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
    return [YQUncaughtExceptionHandler shareInstance];
}


#endif
#endif
