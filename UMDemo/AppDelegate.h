//
//  AppDelegate.h
//  UMDemo
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,UIApplicationDelegate>{
    UIWindow *window;
    UINavigationController *navigationController;
    BMKMapManager* _mapManager;

}

@property (strong, nonatomic) UIWindow *window;


@end

