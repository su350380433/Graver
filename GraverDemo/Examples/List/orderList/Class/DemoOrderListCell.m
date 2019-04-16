//
//  DemoOrderListCell.m
//  WMCoreText
//
//  Created by jiangwei on 2018/11/28.
//  Copyright © 2018 sankuai. All rights reserved.
//

#import "DemoOrderListCell.h"
#import "DemoOrderCellData.h"
#import "DemoOrderListContentView.h"
#import <Graver/WMGCanvasControl.h>

@interface DemoOrderListCell ()
@property (nonatomic, strong) DemoOrderListContentView *orderContentView;
@end

@implementation DemoOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _orderContentView = [[DemoOrderListContentView alloc] initWithFrame:CGRectMake(10, 5, 0, 0)];
        _orderContentView.cornerRadius = 2;
        _orderContentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_orderContentView];
        //        WMGCanvasControl *control = [[WMGCanvasControl alloc] initWithFrame:CGRectMake((73-textSize.width)/2, (32-textSize.height)/2, 73, 32)];
        //        [control addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
        //        control.backgroundColor = [UIColor redColor];
        //        [self.view addSubview:control];
    }
    return self;
}

- (void)setupCellData:(DemoOrderCellData *)cellData {
    //    [super setupCellData:cellData];
    _orderContentView.frame = CGRectMake(10, 5, cellData.cellWidth, cellData.cellHeight - 10);
    self.contentView.frame = _orderContentView.frame;

    _orderContentView.textDrawerDatas = cellData.textDrawerDatas;
}


@end
