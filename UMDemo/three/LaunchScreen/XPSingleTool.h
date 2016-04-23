//
//  XPSingleTool.h
//  testgh
//
//  Created by zzsoft on 16/1/20.
//  Copyright © 2016年 zzsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  单例工具
 */
@interface XPSingleTool : NSObject

+ (instancetype)sharedSingleTool;

/**
 *  设置引导页关闭时调用的Block 用来进入首页 设置Window的根视图
 */
- (void)setGuideViewCloseBlock:(void (^)())closeBlock;

/**
 *  打开引导页
 */
- (void)openGuideViewController:(Class)viewControllerClass;

/**
 *  关闭引导页
 */
- (void)closeGuideView;


@end

