//
//  IMYYQOldHomeSignView.m
//  IMYYQHome
//
//  Created by meiyou on 2018/3/9.
//  Copyright © 2018年 Linggan. All rights reserved.
//

#import "IMYYQOldHomeSignView.h"
#import <IMYFoundation.h>
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/UIView+WebCache.h>
@interface IMYYQOldHomeSignView ()

@property (nonatomic, strong) UIImageView *signImageViewBack;
@property (nonatomic, strong) UIImageView *signImageView;
@property (nonatomic, assign) BOOL isAnimation;
@end

@implementation IMYYQOldHomeSignView

+ (instancetype)signView {
    return [[IMYYQOldHomeSignView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 签到按钮
        self.signImageViewBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.signImageViewBack.hidden = YES;
        [self.signImageViewBack setImage:[UIImage imageNamed:@"first_coin00.png"]];
        [self addSubview:self.signImageViewBack];

        self.signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.signImageView.imy_centerY = frame.size.height / 2;
        self.signImageView.imy_right = frame.size.width;
        [self addSubview:self.signImageView];
        NSMutableArray *imagesArray = [[NSMutableArray alloc] init];

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 0; i <= 25; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"first_coin0%d.png", i <= 11 ? i : 0]];
                [imagesArray addObject:image];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                self.signImageView.animationImages = imagesArray;
                self.signImageView.animationDuration = 1.5;
                self.signImageView.animationRepeatCount = 0;

                if (self.isAnimation) {
                    [self.signImageView startAnimating];
                }
            });
        });
    }
    return self;
}

- (void)showViewAnimation:(BOOL)isAnimation {

    self.isAnimation = isAnimation;
    if (self.signImageView.animationImages.count == 0) {
        return;
    }
    self.signImageViewBack.hidden = isAnimation;
    if (isAnimation) {
        [self.signImageView startAnimating];
    } else {
        [self.signImageView stopAnimating];
    }
}

@end
