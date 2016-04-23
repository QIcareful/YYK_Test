//
//  CityTC.m
//  UMDemo
//
//  Created by Apple on 16/4/20.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import "CityTC.h"
#import "DOPDropDownMenu.h"
@interface CityTC ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *cates;
@property (nonatomic, strong) NSArray *movices;
@property (nonatomic, strong) NSArray *hostels;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSArray *sorts;
@property (nonatomic, weak) DOPDropDownMenu *menu;
@property (nonatomic, weak) DOPDropDownMenu *menuTwo;//第二层控件
@property (nonatomic, strong) UIView *bgView;//大的背景图
@property (nonatomic, strong) UIView *pgView;//第二层控件放置的背景
@property (nonatomic, strong) UISegmentedControl *segmentedControl;//分段控件
@end

@implementation CityTC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"DOPDropDownMenu";
//    self.Blank = @"0";
//    self.Choose = @"0";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(menuReloadData)];
    // 数据
    self.classifys = @[@"0.0"];
    self.cates = @[@""];
    self.movices = @[@""];
    self.hostels = @[@""];
    self.areas = @[@"全城",@"西湖区",@"余杭区",@"下城区",@"上城区",@"滨江区"];
    self.sorts = @[@"默认排序",@"离我最近",@"好评优先",@"人气优先",@"最新发布"];
    
    // 添加背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [self.view addSubview: self.bgView];
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    _menu = menu;
    [self.view addSubview:menu];
//    DOPDropDownMenu *menuTwo = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0,64 + 44) andHeight:44];
//    menuTwo.delegate = self;
//    menuTwo.dataSource = self;
//    menuTwo.hidden = YES;
//    [self.menu addSubview:_menuTwo];
    
    //    [self.menu addSubview:menuTwo];
//    _menuTwo = menuTwo;
//    [menuTwo selectDefalutIndexPath];
    // 创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    [menu selectDefalutIndexPath];
    
}

- (void)menuReloadData
{
    //    self.classifys = @[@"美食",@"今日新单",@"电影"];
    [_menu reloadData];
}
- (IBAction)selectIndexPathAction:(id)sender {
    [_menu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:2 item:2]];
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 4;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.classifys.count;
        
    }else if (column == 1){
        return self.areas.count;
    }else if (column == 2){
        return self.sorts.count;
    }
    //返回展开行数
    _menuTwo.hidden = NO;
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.classifys[indexPath.row];
    } else if (indexPath.column == 1){
        return self.areas[indexPath.row];
    } else {
        return self.sorts[indexPath.row];
    }
}

// new datasource

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForRowAtIndexPath:(DOPIndexPath *)indexPath
{    //第一级是否带有图片
    //    if (indexPath.column == 0 || indexPath.column == 1) {
    //        return [NSString stringWithFormat:@"ic_filter_category_%ld",indexPath.row];
    //    }
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{ //第二级是否带有图片
    //    if (indexPath.column == 0 && indexPath.item >= 0) {
    //        return [NSString stringWithFormat:@"ic_filter_category_%ld",indexPath.item];
    //    }
    return nil;
}

// new datasource

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    //第一级菜单后面显示的数字
    //    if (indexPath.column < 2) {
    //        return [@(arc4random()%1000) stringValue];
    //    }
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    //第二级菜单后面显示的数字
    //    return [@(arc4random()%1000) stringValue];
    return nil;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    //    是否有二级菜单 和二级菜单有多少子菜单
    if (column == 0) {
        if (row == 0) {
            return self.cates.count;
        }
        //        else if (row == 2){
        //            return self.movices.count;
        //        } else if (row == 3){
        //            return self.hostels.count;
        //        }
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        if (indexPath.row == 0) {
            return self.cates[indexPath.item];
        } else if (indexPath.row == 2){
            return self.movices[indexPath.item];
        } else if (indexPath.row == 3){
            return self.hostels[indexPath.item];
        }
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目......",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
    }
}
#pragma mark Blank
- (void)addBlank {
    NSArray*segmentedData = [[NSArray alloc]initWithObjects:@"商区",@"地铁",nil];
    
    UISegmentedControl*segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    segmentedControl.backgroundColor = [ UIColor whiteColor];
    segmentedControl.frame = CGRectMake(0,64 + 44,[[UIScreen mainScreen] bounds].size.width,44);
    /*
     这个是设置按下按钮时的颜色
     */
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.selectedSegmentIndex=0;//默认选中的按钮索引
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary*attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],NSFontAttributeName,[UIColor redColor], NSForegroundColorAttributeName,nil ,nil];
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSDictionary* highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]forKey:NSForegroundColorAttributeName];
    
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //设置分段控件点击相应事件
    
    [segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    //    self.pgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44,  [[UIScreen mainScreen] bounds].size.width, 44)];
    //    [self.bgView addSubview:self.pgView];
    //    [self.pgView addSubview:segmentedControl];
    _segmentedControl = segmentedControl;
}
-(void)doSomethingInSegment:(UISegmentedControl*)Seg

{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch(Index)
    {
        case0:
            break;
        case1:
            break;
        case2:
            break;
        default:
            break;
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"商圈"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"商圈"];
}
@end
