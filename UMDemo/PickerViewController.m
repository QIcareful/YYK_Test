//
//  PickerViewController.m
//  UMDemo
//
//  Created by Apple on 16/4/21.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import "PickerViewController.h"
#import "TLCityPickerController.h"
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLGeocoder.h>
@interface PickerViewController ()<TLCityPickerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cityPickerButton;
@property(strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation PickerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self add];
}
- (void)add {
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    
    cityPickerVC.locationCityID = @"600010000";
    
    //    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];

}
#pragma mark - TLCityPickerDelegate
- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    [self.cityPickerButton setTitle:city.cityName forState:UIControlStateNormal];
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"城市"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"城市"];
}
@end
