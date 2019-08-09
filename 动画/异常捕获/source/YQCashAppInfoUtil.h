//
//  YQCashAppInfoUtil.h
//  Cash
//
//  Created by slj on 2019/5/17.
//  Copyright © 2019年 meetyou. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
  DoraemonAppInfoUtil 搬迁
 */
@interface YQCashAppInfoUtil : NSObject

/**
 DeviceInfo：获取当前设备的 用户自定义的别名，例如：库克的 iPhone 9
 
 @return 当前设备的 用户自定义的别名，例如：库克的 iPhone 9
 */
+ (NSString *)iphoneName;


/**
 获取APP名称

 @return 当前APP 名称
 */
+ (NSString *)appName;

/**
 DeviceInfo：获取当前设备的 系统名称，例如：iOS 13.1
 
 @return 当前设备的 系统名称，例如：iOS 13.1
 */
+ (NSString *)iphoneSystemVersion;

+ (NSString *)bundleIdentifier;

+ (NSString *)bundleVersion;

+ (NSString *)bundleShortVersionString;

+ (NSString *)iphoneType;

+ (BOOL)isIPhoneXSeries;

+ (BOOL)isIpad;

+ (NSString *)locationAuthority;

+ (NSString *)pushAuthority;

+ (NSString *)cameraAuthority;

+ (NSString *)audioAuthority;

+ (NSString *)photoAuthority;

+ (NSString *)addressAuthority;

+ (NSString *)calendarAuthority;

+ (NSString *)remindAuthority;

+ (NSString *)bluetoothAuthority;

@end
