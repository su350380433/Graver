//
//  DemoOrderListContentView.h
//  WMCoreText
//
//  Created by jiangwei on 2018/11/28.
//  Copyright © 2018 sankuai. All rights reserved.
//

#import "DemoOrderListViewModel.h"
#import <Graver/WMGCanvasView.h>


NS_ASSUME_NONNULL_BEGIN

@interface DemoOrderListContentView : WMGCanvasView <WMGTextDrawerDelegate, WMGTextDrawerEventDelegate>

@property (nonatomic, strong) NSArray<WMGVisionObject *> *textDrawerDatas;


@end

NS_ASSUME_NONNULL_END
