//
//  YQUncaughtExceptionHandler.h
//  YQUncaughtExceptionHandler
//
//  Created by slj on 2019/5/17.
//  Copyright © 2019年 meetyou. All rights reserved.
//

#ifdef DEBUG                // Debug下才生效
#if TARGET_IPHONE_SIMULATOR //模拟器下才生效

#import <Foundation/Foundation.h>

//返回地址路径
typedef void (^logPathBlock)(NSString *pathStr);

@interface YQUncaughtExceptionHandler : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, copy) logPathBlock pathBlock;

//是否显示错误提示框 默认是不显示的
@property (nonatomic, copy) YQUncaughtExceptionHandler * (^showAlert)(BOOL yesOrNo);

//是否显示错误信息
@property (nonatomic, copy) YQUncaughtExceptionHandler * (^showErrorInfor)(BOOL yesOrNo);

//回调返回错误日志
@property (nonatomic, copy) YQUncaughtExceptionHandler * (^getlogPathBlock)(void (^logPathBlock)(NSString *pathStr));

//错误日志路径
@property (nonatomic, strong) NSString *logFilePath;

YQUncaughtExceptionHandler *InstanceYQUncaughtExceptionHandler(void);

@end

#endif
#endif
