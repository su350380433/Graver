//
//  DemoOrderListContentView.m
//  WMCoreText
//
//  Created by jiangwei on 2018/11/28.
//  Copyright © 2018 sankuai. All rights reserved.
//

#import "DemoOrderListContentView.h"
#import "NSAttributedString+GCalculateAndDraw.h"
#import "WMGImage+queryCache.h"
#import "WMGImage.h"
#import "WMGTextAttachment+Event.h"

@interface DemoOrderListContentView ()
@property (nonatomic, strong) NSMutableArray<WMGTextAttachment *> *arrayAttachments;
@property (nonatomic, strong) NSMutableArray<WMGTextAttachment *> *arrayAttachmentsAction;

@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, strong) WMGTextDrawer *textDrawer;
@end

@implementation DemoOrderListContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _arrayAttachments = [NSMutableArray array];
        _arrayAttachmentsAction = [NSMutableArray array];

        _textDrawer = [[WMGTextDrawer alloc] init];
        _textDrawer.delegate = self;
        _textDrawer.eventDelegate = self;
    }
    return self;
}

- (void)setTextDrawerDatas:(NSArray<WMGVisionObject *> *)textDrawerDatas {
    if (_textDrawerDatas != textDrawerDatas) {
        _textDrawerDatas = textDrawerDatas;
    }
}

- (void)textDrawer:(WMGTextDrawer *)textDrawer replaceAttachment:(WMGTextAttachment *)att frame:(CGRect)frame context:(CGContextRef)context {
    if (att.type == WMGAttachmentTypeStaticImage) {
        if ([att.contents isKindOfClass:[NSString class]]) {
            UIGraphicsPushContext(context);
            UIImage *image = [UIImage imageNamed:(NSString *)att.contents];
            [image drawInRect:frame];
            UIGraphicsPopContext();
        } else if ([att.contents isKindOfClass:[UIImage class]]) {
            UIGraphicsPushContext(context);
            [(UIImage *)att.contents drawInRect:frame];
            UIGraphicsPopContext();
            [att addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        } else if ([att.contents isKindOfClass:[WMGImage class]]) {
            WMGImage *ctImage = (WMGImage *)att.contents;
            UIImage *cachedImage;
            if (ctImage.downloadUrl) {
                cachedImage = [ctImage wmg_queryCacheImageWithUrl:ctImage.downloadUrl];
            }

            if (ctImage.image) {
                UIGraphicsPushContext(context);
                [ctImage.image drawInRect:frame];
                UIGraphicsPopContext();
            } else if (cachedImage) {
                ctImage.image = cachedImage;
                UIGraphicsPushContext(context);
                [ctImage.image drawInRect:frame];
                ctImage.downloadUrl = nil;
                UIGraphicsPopContext();
            } else {
                if (!IsStrEmpty(ctImage.placeholderName)) {
                    UIGraphicsPushContext(context);
                    UIImage *image = [UIImage imageNamed:ctImage.placeholderName];
                    [image drawInRect:frame];
                    UIGraphicsPopContext();
                }
            }

            if (!IsStrEmpty(ctImage.downloadUrl)) {
                att.layoutFrame = frame;
                [_lock lock];
                [_arrayAttachments addObject:att];
                [_lock unlock];
            }
        }
        if (att.target || att.selector) {
            [_lock lock];
            if (![_arrayAttachmentsAction containsObject:att]) {
                [_arrayAttachmentsAction addObject:att];
            }
            [_lock unlock];
        }
    }
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(NSDictionary *)userInfo {
    [super drawInRect:rect withContext:context asynchronously:asynchronously userInfo:userInfo];
    [self.textDrawerDatas enumerateObjectsUsingBlock:^(WMGVisionObject *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        self.textDrawer.frame = obj.frame;
        self.textDrawer.textLayout.attributedString = obj.value;
        [self.textDrawer drawInContext:context];
    }];
    return YES;
}

- (void)buttonAction {
    [UIAlertController alertControllerWithTitle:@"contenView" message:@"订单列表消息" preferredStyle:UIAlertControllerStyleAlert];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [_textDrawer touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}


- (void)drawingDidFinishAsynchronously:(BOOL)asynchronously success:(BOOL)success {
    if (!success) {
        return;
    }

    [_lock lock];

    // 三个点： 锁重入、for循环遍历移除元素、多线程同步访问共享数据区
    for (__block int i = 0; i < _arrayAttachments.count; i++) {
        if (i >= 0) {
            WMGTextAttachment *att = [_arrayAttachments objectAtIndex:i];

            if (att.type == WMGAttachmentTypeStaticImage) {
                WMGImage *ctImage = (WMGImage *)att.contents;
                if ([ctImage isKindOfClass:[WMGImage class]]) {

                    __weak typeof(self) weakSelf = self;
                    [ctImage wmg_loadImageWithUrl:ctImage.downloadUrl
                                          options:0
                                         progress:NULL
                                        completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                            if (weakSelf) {
                                                [self.lock lock];
                                                if ([self.arrayAttachments containsObject:att]) {
                                                    [self.arrayAttachments removeObject:att];
                                                    i--;
                                                    [self setNeedsDisplay];
                                                }
                                                [self.lock unlock];
                                            }
                                        }];
                }
            }
        }
    }
    [_lock unlock];
}

/**
 *  返回 textDrawer 处理事件时所基于的 view，用于确定坐标系等，必须
 *
 *  @param textDrawer 查询的 textDrawer
 *
 *  @return 处理事件时基于的 view
 */
- (UIView *)contextViewForTextDrawer:(WMGTextDrawer *)textDrawer {

    return self;
}

/**
 *  返回定义 textDrawer 可点击区域的数组
 *
 *  @param textDrawer 查询的 textDrawer
 *
 *  @return 由 (id<WMGTextActiveRange>) 对象组成的数组
 */
- (NSArray *)activeRangesForTextDrawer:(WMGTextDrawer *)textDrawer {
    NSMutableArray *arrayActiveRanges = [NSMutableArray array];
    for (WMGTextAttachment *att in _arrayAttachmentsAction) {
        WMGTextActiveRange *range = [WMGTextActiveRange activeRange:NSMakeRange(att.position, att.length) type:WMGActiveRangeTypeAttachment text:@""];
        range.bindingData = att;
        [arrayActiveRanges addObject:range];
    }

    return arrayActiveRanges;
}

/**
 *  响应对一个 activeRange 的点击事件
 *
 *  @param textDrawer 响应事件的 textDrawer
 *  @param activeRange  响应的 activeRange
 */
- (void)textDrawer:(WMGTextDrawer *)textDrawer didPressActiveRange:(id<WMGActiveRange>)activeRange {
    WMGTextAttachment *att = activeRange.bindingData;
    if ([att.target respondsToSelector:att.selector]) {
        [att handleEvent:nil];
    }
}

@end
