//
//  ListViewController.m
//  UMDemo
//
//  Created by Apple on 16/4/5.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import "ListViewController.h"
#import <SDCycleScrollView.h>
@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [self addad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, 70, 35)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn setTintColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(did) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}
- (void)did {
    [ self dismissViewControllerAnimated: YES completion: nil ];

}
- (void)addad {
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    //网络加载图片的轮播器
  SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 280, 320, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    [self.view addSubview:cycleScrollView2];
    //本地加载图片的轮播器
//    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:imagesGroup:];
    }
- (void)efficiency {
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"轮播"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"轮播"];
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
