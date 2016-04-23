//
//  UIScrollView+Extension.h
//  testgh
//
//  Created by zzsoft on 16/1/20.
//  Copyright © 2016年 zzsoft. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIScrollView (Extension)

/** 内容区高度*/
@property (nonatomic, assign) CGFloat contentHeight;

/** 内容区宽度*/
@property (nonatomic, assign) CGFloat contentWidth;

/** 边缘顶部距离*/
@property (nonatomic, assign) CGFloat contentTop;

/** 边缘底部距离*/
@property (nonatomic, assign) CGFloat contentBottom;

/** 边缘左边距离*/
@property (nonatomic, assign) CGFloat contentLeft;

/** 边缘右边距离*/
@property (nonatomic, assign) CGFloat contentRight;

/** 横向偏移量 contentOffset.x*/
@property (nonatomic, assign) CGFloat contentX;

/** 纵向偏移量 contentOffset.y*/
@property (nonatomic, assign) CGFloat contentY;

- (void)scrollToBottom;
- (void)scrollToBottomAnimation:(BOOL)animation;
@end
