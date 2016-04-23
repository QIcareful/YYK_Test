//
//  XPSingleTool.m
//  testgh
//
//  Created by zzsoft on 16/1/20.
//  Copyright © 2016年 zzsoft. All rights reserved.
//


#import "XPSingleTool.h"

@interface XPSingleTool ()
@property (nonatomic, strong) UIWindow *guideWindow;
@property (nonatomic, copy) void (^closeBlock)();

@end

@implementation XPSingleTool

+ (instancetype)sharedSingleTool
{
    static XPSingleTool *sharedSingleTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleTool = [[self alloc] init];
    });
    return sharedSingleTool;
}

- (void)setGuideViewCloseBlock:(void (^)())closeBlock
{
    self.closeBlock = closeBlock;
}

- (void)openGuideViewController:(Class)viewControllerClass
{
    NSLog(@"XPSingleTool openGuideViewController");
    self.guideWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.guideWindow.backgroundColor = [UIColor orangeColor];
    self.guideWindow.windowLevel = UIWindowLevelAlert;
    NSAssert(viewControllerClass, [NSString stringWithFormat:@"Method:-openGuideViewController:, info:请使用你的引导页视图控制器类."]);
    self.guideWindow.rootViewController = [[viewControllerClass alloc] init];
    [self.guideWindow makeKeyAndVisible];
}

- (void)closeGuideView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication].windows[0] makeKeyAndVisible];
    
    if (self.closeBlock) {
        self.closeBlock();
        self.closeBlock = nil;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.guideWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [self.guideWindow resignKeyWindow];
        self.guideWindow = nil;
    }];
}

@end

