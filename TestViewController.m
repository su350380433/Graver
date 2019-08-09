//
//  TestViewController.m
//  BSBacktraceLogger
//
//  Created by S S on 2019/4/24.
//

#import "TestViewController.h"
#import <UIKit/UIKit.h>
@interface TestViewController ()

@property (nonatomic, strong) UIButton *button;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addTestUI];
}

- (void)addTestUI {
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    [button setTitle:@"title" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.textColor = [UIColor blueColor];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.button = button;
}

- (void)removeButton {
    [self.button removeFromSuperview];
}

- (void)buttonAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"我是石头蹦出来的" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
                                                          NSLog(@"点击确认");
                                                      }]];

    // 由于它是一个控制器 直接modal出来就好了

    [self presentViewController:alertController animated:YES completion:nil];
}

@end
