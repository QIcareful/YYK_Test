//
//  FingerprintViewController.m
//  UMDemo
//
//  Created by Apple on 16/4/22.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import "FingerprintViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface FingerprintViewController ()

@end

@implementation FingerprintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    LAContext *lac = [[LAContext alloc]init];
    // 判断设备是否支持指纹识别
    BOOL isSupport = [lac canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL];
    if(!isSupport)
    {
        NSLog(@"不支持！");
        return;
    }
    [lac evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请按手印" reply:^(BOOL success, NSError *error) {
        if(success)
        {
            NSLog(@"成功后，处理接下来的逻辑");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
