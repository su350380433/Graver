//
//  YQSendMsg4DingDing.h
//  GraverDemo
//
//  Created by S S on 2019/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YQDingDingModel : NSObject

@property (nonatomic, copy) NSString *api;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *url;


@end

@interface YQSendMsg4DingDing : NSObject

+ (YQDingDingModel *)getDingDingConfig;


+ (void)sendMessageToDingDingWithMassage:(NSString *)message
                                      at:(NSArray<NSString *> *)atArray
                                 dingUrl:(NSString *)dingUrl
                                  finish:(void (^)(id Data, NSError *error))finishBlock;
@end


NS_ASSUME_NONNULL_END
