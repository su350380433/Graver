//
//  LLDBViewController.m
//  GraverDemo
//
//  Created by S S on 2019/4/17.
//

#import "LLDBViewController.h"

@interface LLDBViewController ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *lbl;

@end

@implementation LLDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self addButton1];
    [self addButton2];
}
- (void)addButton1 {
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    [button setTitle:@"我是自己添加的" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.textColor = [UIColor blueColor];
    [button setBackgroundColor:[UIColor grayColor]];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.button = button;
}

- (void)addButton2 {
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *lb = [UILabel new];
    lb.frame = CGRectMake(100, 300, 100, 50);
    lb.text = @"看我的";
    lb.textColor = [UIColor purpleColor];
    lb.font = [UIFont systemFontOfSize:16];
    lb.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lb];
    self.lbl = lb;
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


- (void)buttonAction2 {
    int i = 10;
    int j = 0;
    //    int c = i/j;
    //    NSLog(@"%ld",c);
}

@end
