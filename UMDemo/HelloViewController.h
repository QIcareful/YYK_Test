//
//  HelloViewController.h
//  UMDemo
//
//  Created by Apple on 16/4/26.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDRCore.h"
#import "PDRCoreAppWindow.h"
@interface HelloViewController : UIViewController<PDRCoreDelegate,PDRCoreAppWindowDelegate>
{
    BOOL _isFullScreen;
    UIView *_containerView;
    UIView *_statusBarView;
    UIStatusBarStyle _statusBarStyle;

}
@property(nonatomic, retain)UIColor *defalutStausBarColor;
-(UIColor*)getStatusBarBackground;
@end
