//
//  UIControl+Block.h
//  testgh
//
//  Created by zzsoft on 16/1/20.
//  Copyright © 2016年 zzsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Block)

/**
 添加事件
 */
- (void)addControlEvents:(UIControlEvents)controlEvents withAction:(void(^)(id sender))action;

/**
 移除事件
 */
- (void)removeControlEvents:(UIControlEvents)controlEvents;

/**
 添加事件 for key
 */
- (void)addControlEvents:(UIControlEvents)controlEvents withAction:(void(^)(id sender))action forKey:(NSString *)key;

/**
 移除事件 for key
 */
- (void)removeControlEvents:(UIControlEvents)controlEvents forKey:(NSString *)key;

/**
 添加点击事件 UIControlEventTouchUpInside
 */
- (void)addAction:(void(^)(id sender))action;

/**
 移除点击事件 UIControlEventTouchUpInside
 */
- (void)removeAction;

/**
 移除全部事件
 */
- (void)removeAllActions;

@end
