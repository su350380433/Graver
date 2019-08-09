//
//  YQSendMsg4DingDing.m
//  GraverDemo
//
//  Created by S S on 2019/5/17.
//

#import "YQSendMsg4DingDing.h"
#import "AFHTTPSessionManager.h"

@implementation YQSendMsg4DingDing

+ (YQDingDingModel *)getDingDingConfig {

    YQDingDingModel *model = [[YQDingDingModel alloc] init];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"CashConfig" ofType:@"plist"];
    NSDictionary *data = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"dingding"];
    if (data) {
        model.api = data[@"api"];
        model.token = data[@"access_token"];
        model.url = [NSString stringWithFormat:@"%@%@", model.api, model.token];
    }

    return model;
}

+ (void)sendMessageToDingDingWithMassage:(NSString *)message
                                      at:(NSArray<NSString *> *)atArray
                                 dingUrl:(NSString *)dingUrl
                                  finish:(void (^)(id Data, NSError *error))finishBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                   @"application/json",
                                                                   @"text/plain",
                                                                   @"text/javascript",
                                                                   @"text/json",
                                                                   @"text/html",
                                                                   nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                   @"text", @"msgtype",
                                                                   @{@"content": message}, @"text", nil];
    if (atArray.count > 0) {
        NSDictionary *atMobiles = @{@"atMobiles": atArray, @"isAtAll": @(false)};
        [params setObject:atMobiles forKey:@"at"];
    }
    [manager POST:dingUrl
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            NSNumber *errcode = [responseObject objectForKey:@"errcode"];
            if (errcode.integerValue == 0) {
                if (finishBlock) {
                    finishBlock(responseObject, nil);
                }
            } else {
                if (finishBlock) {
                    NSInteger codee = errcode.integerValue;

                    NSString *domain = [responseObject objectForKey:@"errmsg"];

                    finishBlock(nil, [NSError errorWithDomain:domain code:codee userInfo:nil]);
                }
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            if (finishBlock) {
                finishBlock(nil, error);
            }
        }];
}

@end

@implementation YQDingDingModel


@end
