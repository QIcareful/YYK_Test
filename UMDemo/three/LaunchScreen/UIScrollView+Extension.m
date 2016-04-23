//
//  UIScrollView+Extension.m
//  testgh
//
//  Created by zzsoft on 16/1/20.
//  Copyright © 2016年 zzsoft. All rights reserved.
//


#import "UIScrollView+Extension.h"

@implementation UIScrollView (Extension)

- (CGFloat)contentWidth
{
    return self.contentSize.width;
}
- (void)setContentWidth:(CGFloat)contentWidth
{
    CGSize size = self.contentSize;
    size.width = contentWidth;
    self.contentSize = size;
}

- (CGFloat)contentHeight
{
    return self.contentSize.height;
}
- (void)setContentHeight:(CGFloat)contentHeight
{
    CGSize size = self.contentSize;
    size.height = contentHeight;
    self.contentSize = size;
}

- (CGFloat)contentTop
{
    return self.contentInset.top;
}
- (void)setContentTop:(CGFloat)contentTop
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = contentTop;
    self.contentInset = inset;
}

- (CGFloat)contentBottom
{
    return self.contentInset.bottom;
}
- (void)setContentBottom:(CGFloat)contentBottom
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = contentBottom;
    self.contentInset = inset;
}

- (CGFloat)contentLeft
{
    return self.contentInset.left;
}
- (void)setContentLeft:(CGFloat)contentInsetLeft
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = contentInsetLeft;
    self.contentInset = inset;
}

- (CGFloat)contentRight
{
    return self.contentInset.right;
}
- (void)setContentRight:(CGFloat)contentRight
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = contentRight;
    self.contentInset = inset;
}

- (CGFloat)contentX
{
    return self.contentOffset.x;
}
- (void)setContentX:(CGFloat)contentX
{
    CGPoint offset = self.contentOffset;
    offset.x = contentX;
    self.contentOffset = offset;
}

- (CGFloat)contentY
{
    return self.contentOffset.y;
}
- (void)setContentY:(CGFloat)contentY
{
    CGPoint offset = self.contentOffset;
    offset.y = contentY;
    self.contentOffset = offset;
}

#pragma mark - Function
- (void)scrollToTop
{
    [self scrollToTopAnimation:NO];
}

- (void)scrollToTopAnimation:(BOOL)animation
{
    [self setContentOffset:CGPointMake(self.contentOffset.x, -self.contentTop) animated:animation];
}

- (void)scrollToBottom
{
    [self scrollToBottomAnimation:NO];
}

- (void)scrollToBottomAnimation:(BOOL)animation
{
    CGFloat contentHeight = self.contentHeight + self.contentTop + self.contentBottom;
    CGFloat offsetY = -self.contentTop + (contentHeight > self.frame.size.height ? contentHeight - self.frame.size.height : 0);
    [self setContentOffset:CGPointMake(self.contentX, offsetY) animated:animation];
}






@end
