//
//  ViewController.m
//  SearchList
//
//  Created by myhg on 16/4/7.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "SosoViewController.h"
#import "SearchDBManage.h"

#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//设置RGB颜色值
#define COLOR(R,G,B,A)	[UIColor colorWithRed:(CGFloat)R/255 green:(CGFloat)G/255 blue:(CGFloat)B/255 alpha:A]
// 最大存储的搜索历史 条数
#define MAX_COUNT 5

@interface SosoViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
/**
 *  搜索历史数据表单
 */
@property (nonatomic,strong)UITableView *tabeleView;
/**
 *  数据集合
 */
@property (nonatomic,strong)NSMutableArray *dataArray;
/**
 *  uibbtons
 */
@property (nonatomic, strong) UIButton *button;
/**
 *  view
 */
@property (nonatomic, strong) UIView * views;

@end

@implementation SosoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    [self initData];
    
    [self setNavTitleView];
    
    [self initTabelView];

    // Do any additional setup after loading the view, typically from a nib.
}
/**
 *  数据初始化
 */
- (void)initData{
    self.dataArray = [[NSMutableArray alloc] init];
//    [[SearchDBManage shareSearchDBManage] deleteAllSearchModel];
    self.dataArray = [[SearchDBManage shareSearchDBManage] selectAllSearchModel];
}


/**
 *  设置导航栏搜索框
 */
- (void)setNavTitleView{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(0, 0, 140, 30);
     [searchBar setImage:[UIImage imageNamed:@"icon_search2"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入搜索内容";
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.barTintColor = UIColorFromRGB(0xf7f7f7);
    self.navigationItem.titleView = searchBar;
}
/**
 *  设置搜索历史显示表格
 */
- (void)initTabelView{
    self.tabeleView = [[UITableView alloc] init];
    self.tabeleView.frame = self.view.bounds;
    self.tabeleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabeleView.delegate = self;
    self.tabeleView.dataSource = self;
    [self.view addSubview:self.tabeleView];
    [self addButton];

    // 清空历史搜索按钮
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 104)];
    
    UIButton *clearButton = [[UIButton alloc] init];
    clearButton.frame = CGRectMake(60, 60, self.view.frame.size.width - 120, 44);
    [clearButton setTitle:@"清空历史搜索" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor colorWithRed:242/256 green:242/256 blue:242/256 alpha:1] forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [clearButton addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchDown];
    clearButton.layer.cornerRadius = 3;
    clearButton.layer.borderWidth = 0.5;
    clearButton.layer.borderColor = [UIColor colorWithRed:242/256 green:242/256 blue:242/256 alpha:1].CGColor;
    [footView addSubview:clearButton];
    self.tabeleView.tableFooterView = footView;
    self.tabeleView.tableHeaderView = _views;
    

}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        self.tabeleView.tableFooterView.hidden = YES; // 没有历史数据时隐藏
    }
    else{
        self.tabeleView.tableFooterView.hidden = NO; // 有历史数据时显示
    }
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        // cell 下面的横线
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.frame = CGRectMake(0, cell.frame.size.height - 0.5, cell.frame.size.width, 0.5);
        lineLabel.backgroundColor = [UIColor colorWithRed:242/256 green:242/256 blue:242/256 alpha:1];
        [cell addSubview:lineLabel];
    }
    
    SearchModel *model = (SearchModel *)[self exchangeArray:self.dataArray][indexPath.row];
    cell.textLabel.text = model.keyWord;
    cell.detailTextLabel.text = model.currentTime;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchModel *model = (SearchModel *)[self exchangeArray:self.dataArray][indexPath.row];
    UIAlertView *alView = [[UIAlertView alloc] init];
    alView.title = @"选中的数据";
    alView.message = [NSString stringWithFormat:@"%@\n%@",model.keyWord,model.currentTime];
    [alView addButtonWithTitle:@"确定"];
    [alView show];
}

/**
 *  清空搜索历史操作
 */
- (void)clearButtonClick{
    [[SearchDBManage shareSearchDBManage] deleteAllSearchModel];
    [self.dataArray removeAllObjects];
    [self.tabeleView reloadData];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}// return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"搜索" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}// called when text starts editing
- (void)addButton{
     UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120 )];
    NSArray *arr = @[@"无知",@"风云变幻",@"施耐庵",@"唉",@"西门吹雪",@"呵呵哒",@"快看看",@"窿窿啦啦",@"0.0",@"合欢花",@"暴走大事件",@"非诚勿扰",@"呵呵呵"];
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 5;//用来控制button距离父视图的高
    for (int i = 0; i < arr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 100 + i;
        button.backgroundColor = [UIColor greenColor];
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //根据计算文字的大小
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGFloat length = [arr[i] boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:arr[i] forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(10 + w, h, length + 15 , 30);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(10 + w + length + 15 > 320){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(10 + w, h, length + 15, 30);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
       
        [view addSubview:button];
    }
    _views = view;

}
//点击事件
- (void)handleClick:(UIButton *)btn{
    
    NSLog(@"%ld",btn.tag);
    UIAlertView *alView = [[UIAlertView alloc] init];
    alView.title = @"选中的编号";
    alView.message = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    [alView addButtonWithTitle:@"确定"];
    [alView show];

}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}// return NO to not resign first responder
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}// called before text changes
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self insterDBData:searchBar.text]; // 插入数据库
    [searchBar resignFirstResponder];
}// called when keyboard search button pressed
//搜索点击事件
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self insterDBData:searchBar.text]; // 插入数据库
    [searchBar resignFirstResponder];
}// called when cancel button pressed

/**
 *  获取当前时间
 *
 *  @return 当前时间
 */
- (NSString *)getCurrentTime{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    locationString = @"";
    return locationString;
}

/**
 *  去除数据库中已有的相同的关键词
 *
 *  @param keyword 关键词
 */
- (void)removeSameData:(NSString *)keyword{
    NSMutableArray *array = [[SearchDBManage shareSearchDBManage] selectAllSearchModel];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SearchModel *model = (SearchModel *)obj;
        if ([model.keyWord isEqualToString:keyword]) {
            [[SearchDBManage shareSearchDBManage] deleteSearchModelByKeyword:keyword];
        }
    }];
}

/**
 *  数组左移
 *
 *  @param array   需要左移的数组
 *  @param keyword 搜索关键字
 *
 *  @return 返回新的数组
 */
- (NSMutableArray *)moveArrayToLeft:(NSMutableArray *)array keyword:(NSString *)keyword{
    [array addObject:[SearchModel creatSearchModel:keyword currentTime:[self getCurrentTime]]];
    [array removeObjectAtIndex:0];
    return array;
}
/**
 *  数组逆序
 *
 *  @param array 需要逆序的数组
 *
 *  @return 逆序后的输出
 */
- (NSMutableArray *)exchangeArray:(NSMutableArray *)array{
    NSInteger num = array.count;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSInteger i = num - 1; i >= 0; i --) {
        [temp addObject:[array objectAtIndex:i]];
        
    }
    return temp;
}

/**
 *  多余20条数据就把第0条去除
 *
 *  @param keyword 插入数据库的模型需要的关键字
 */
- (void)moreThan20Data:(NSString *)keyword{
    // 读取数据库里面的数据
    NSMutableArray *array = [[SearchDBManage shareSearchDBManage] selectAllSearchModel];
    
    if (array.count > MAX_COUNT - 1) {
        NSMutableArray *temp = [self moveArrayToLeft:array keyword:keyword]; // 数组左移
        [[SearchDBManage shareSearchDBManage] deleteAllSearchModel]; //清空数据库
        [self.dataArray removeAllObjects];
        [self.tabeleView reloadData];
        [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SearchModel *model = (SearchModel *)obj; // 取出 数组里面的搜索模型
            [[SearchDBManage shareSearchDBManage] insterSearchModel:model]; // 插入数据库
        }];
    }
    else if (array.count <= MAX_COUNT - 1){ // 小于等于19 就把第20条插入数据库
        [[SearchDBManage shareSearchDBManage] insterSearchModel:[SearchModel creatSearchModel:keyword currentTime:[self getCurrentTime]]];
    }
}
/**
 *  关键词插入数据库
 *
 *  @param keyword 关键词
 */
- (BOOL)insterDBData:(NSString *)keyword{
    if (keyword.length == 0) {
        return NO;
    }
    else{//搜索历史插入数据库
        //先删除数据库中相同的数据
        [self removeSameData:keyword];
        //再插入数据库
        [self moreThan20Data:keyword];
        // 读取数据库里面的数据
        self.dataArray = [[SearchDBManage shareSearchDBManage] selectAllSearchModel];
        [self.tabeleView reloadData];
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"搜索"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"搜索"];
}
@end
