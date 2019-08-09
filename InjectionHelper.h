//
//  InjectionManager.h
//  Test
//
//  Created by slj on 2019/04/24.
//  Copyright © 2019年 Meetyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG                //Debug下才生效
#if TARGET_IPHONE_SIMULATOR //模拟器下才生效

NS_ASSUME_NONNULL_BEGIN

///配合工具 InjectionIII 使用
@interface InjectionHelper : NSObject


@end


@interface NSObject (InjectionIII)

/**
 获取当前窗体VC

 @return UIViewControllerUi
 */
+ (UIViewController *)ijc_getCurrentViewController;

+ (UIViewController *)ijc_viewControllerSupportView:(UIView *)view;

+ (UIView *)ijc_getMainView;
@end


NS_ASSUME_NONNULL_END

#endif
#endif
