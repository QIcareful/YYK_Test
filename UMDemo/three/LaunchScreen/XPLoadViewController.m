//
//  XPLoadViewController.m
//  testgh
//
//  Created by zzsoft on 16/1/20.
//  Copyright © 2016年 zzsoft. All rights reserved.
//


#import "XPLoadViewController.h"
//#import "MainViewController.h"
#import "ViewController.h"
#import "XPSingleTool.h"
#import "XPGuideViewController.h"

@interface XPLoadViewController ()

@end

@implementation XPLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"这是第一次启动，打开引导页");
        
        // 打开引导页
        [[XPSingleTool sharedSingleTool] openGuideViewController:[XPGuideViewController class]];
    
        [[UIApplication sharedApplication].windows[0] makeKeyAndVisible];
        ViewController *viewController = [[ViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self.navigationController pushViewController:viewController animated:YES];
        self.view.window.rootViewController = navigationController;

//        [UIApplication sharedApplication].keyWindow.rootViewController = [ViewController new];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        NSLog(@"第二次启动，无操作");
        
        [[UIApplication sharedApplication].windows[0] makeKeyAndVisible];
        ViewController *viewController = [[ViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self.navigationController pushViewController:viewController animated:YES];

        self.view.window.rootViewController = navigationController;
        [self.view.window makeKeyAndVisible];

//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        
    }
    
    
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
