//
//  SendMsgToDingDingVCViewController.m
//  GraverDemo
//
//  Created by S S on 2019/5/17.
//

#import "SendMsgToDingDingVCViewController.h"
#import "WSConfigManager.h"
#import "YQSendMsg4DingDing.h"

@interface SendMsgToDingDingVCViewController ()

@end

@implementation SendMsgToDingDingVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    WSDingModel *dingModel = [WSDingModel new];
    dingModel.dingUrl = @"https://oapi.dingtalk.com/robot/send?access_token=f1f1637f3e3e96d83e06bd3f5269e76024e0460e4b001804e94b40eca1ef16b7";
    dingModel.message = @"@谢睿 就等你来";
    if (dingModel.dingUrl.length > 0) {
        if (dingModel.message.length == 0) {
            dingModel.message = @"打包完成！";
        }
    }
    [YQSendMsg4DingDing sendMessageToDingDingWithMassage:dingModel.message at:dingModel.phoneArray dingUrl:dingModel.dingUrl finish:nil];
}


@end
