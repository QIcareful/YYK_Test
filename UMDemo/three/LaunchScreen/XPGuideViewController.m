//
//  XPGuideViewController.m
//  testgh
//
//  Created by zzsoft on 16/1/20.
//  Copyright © 2016年 zzsoft. All rights reserved.
//


#import "XPGuideViewController.h"
#import "Define.h"
#import "Function.h"
#import "UIControl+Block.h"
#import "XPSingleTool.h"
#import "UIScrollView+Extension.h"

@interface XPGuideViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

#define kImageCount 5

@implementation XPGuideViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%f\n", CFAbsoluteTimeGetCurrent());
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _scrollView.showsHorizontalScrollIndicator  = NO;
    _scrollView.delaysContentTouches            = NO;
    _scrollView.pagingEnabled                   = YES;
    _scrollView.contentSize                     = CGSizeMake(kImageCount * kScreenWidth, 0);
    _scrollView.delegate                        = self;
    _scrollView.bounces                         = NO;
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, kScreenHeight - 50, 100, 20)];
    _pageControl.numberOfPages = kImageCount;
    [self.view addSubview:_pageControl];
    
    /*
     引导页 两套图片即可  iPhone4 640*960  和 iPhone5|6|6p 1080*1920
     iPhone4  图片命名 Guide480h-1@2x.png, Guide480h-2@2x.png
     iPhone5|6|6p  图片命名 Guide736h-1@2x.png, Guide480h-2@2x.png
     */
    
    for (int i = 0; i < kImageCount; ++i) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        if (ISIPHONE_4) {
            iv.image = image_name(STR(@"Guide480h-%d", i+1));
        } else {
            iv.image = image_name(STR(@"Guide736h-%d", i+1));
        }
        [self.scrollView addSubview:iv];
        if (i == kImageCount-1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * kScreenWidth + 75, kScreenHeight - 100, kScreenWidth - 150, 30);
            btn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
            btn.layer.cornerRadius = 15;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
            [btn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [btn setTitle:@"开启冒险之旅" forState:UIControlStateNormal];
            [[btn titleLabel] setFont:[UIFont systemFontOfSize:16]];
            
            [btn addControlEvents:UIControlEventTouchDown withAction:^(id sender) {
                [UIView animateWithDuration:0.25 animations:^{
                    [sender setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
                }];
            }];
            [btn addControlEvents:UIControlEventTouchDragExit withAction:^(id sender) {
                [UIView animateWithDuration:0.25 animations:^{
                    [sender setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1]];
                }];
            }];
            [btn addControlEvents:UIControlEventTouchDragEnter withAction:^(id sender) {
                [UIView animateWithDuration:0.25 animations:^{
                    [sender setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
                }];
            }];
            
            [btn addAction:^(id sender) {
                [[XPSingleTool sharedSingleTool] closeGuideView];
            }];
            
            [self.scrollView addSubview:btn];
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentX / kScreenWidth;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    self.view = nil;
    NSLog(@"%@ dealloc", self.class);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

