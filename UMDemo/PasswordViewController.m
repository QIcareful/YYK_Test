//
//  Password ViewController.m
//  UMDemo
//
//  Created by Apple on 16/4/22.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import "PasswordViewController.h"
#import "lockViewController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)setPassword:(id)sender {
    NSString * passwordGlock =[[NSUserDefaults standardUserDefaults]objectForKey:@"passwordGlock"];
    if (passwordGlock) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经设置手势密码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        
        lockViewController * lock =[lockViewController new];
        [self presentViewController:lock animated:YES completion:nil];
    }
    
}
- (IBAction)resetPassword:(id)sender {
    NSString * passwordGlock =[[NSUserDefaults standardUserDefaults]objectForKey:@"passwordGlock"];
    if (passwordGlock) {
        
        lockViewController * lock =[lockViewController new];
        [self presentViewController:lock animated:YES completion:nil];
        lock.reset=@"请输入原密码";
        lock.resetIs=@"resetIs";
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未设置手势密码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
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
