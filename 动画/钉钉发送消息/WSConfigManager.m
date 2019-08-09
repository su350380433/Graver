//
//  WSConfigManager.m
//  AutoUploadTools
//
//  Created by slj on 2019/5/17.
//  Copyright © 2019年 meetyou. All rights reserved.
//

#import "WSConfigManager.h"
//#import "WSAppConfigModel.h"
//#import "MJExtension.h"

static NSString *WSUserDataKey = @"WSUserDataKey";
static NSString *WSPgyerModelKey = @"WSPgyerModelKey";
static NSString *WSDingModelKey = @"WSDingModelKey";

static WSConfigManager *staticConfigManager;
@implementation WSPgyerModel
@end
@implementation WSDingModel
@end
@implementation WSConfigManager
+ (instancetype)sharedConfigManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticConfigManager = [[WSConfigManager alloc] init];
        [staticConfigManager readConfigData];
    });
    return staticConfigManager;
}

- (void)readConfigData {
    //    NSDictionary *dict =  [[NSUserDefaults standardUserDefaults] objectForKey:WSUserDataKey];
    //    self.appConfig = [WSAppConfigModel mj_objectWithKeyValues:dict];
    //    if (self.appConfig == nil) {
    //        self.appConfig = [[WSAppConfigModel alloc] init];
    //    }
    //    NSDictionary *pgyer =  [[NSUserDefaults standardUserDefaults] objectForKey:WSPgyerModelKey];
    //    self.pgyerConfig = [WSPgyerModel mj_objectWithKeyValues:pgyer];
    //    if (self.pgyerConfig == nil) {
    //        self.pgyerConfig = [[WSPgyerModel alloc] init];
    //    }
    //    NSDictionary *ding =  [[NSUserDefaults standardUserDefaults] objectForKey:WSDingModelKey];
    //    self.dingConfig = [WSDingModel mj_objectWithKeyValues:ding];
    //    if (self.dingConfig == nil) {
    //        self.dingConfig = [[WSDingModel alloc] init];
    //    }
}

- (void)saveUserData {
    //    NSDictionary *dict = [[self.appConfig mj_keyValues] copy];
    //    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:WSUserDataKey];
    //
    //    NSDictionary *pgyer = [[self.pgyerConfig mj_keyValues] copy];
    //    [[NSUserDefaults standardUserDefaults] setObject:pgyer forKey:WSPgyerModelKey];
    //
    //    NSDictionary *ding = [[self.dingConfig mj_keyValues] copy];
    //    [[NSUserDefaults standardUserDefaults] setObject:ding forKey:WSDingModelKey];
}


@end
