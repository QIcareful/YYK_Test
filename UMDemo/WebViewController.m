//
//  WebViewController.m
//  UMDemo
//
//  Created by Apple on 16/4/21.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import "WebViewController.h"
//#import <objc/NSObjCRuntime.h>
//#import <objc/objc-runtime.h>
#import <objc/runtime.h>
@import JavaScriptCore;
/**
 *  创建一个web可以兼容的objc协议，必须继承JSExport协议
 */
@protocol WebProtocol <JSExport>
/**
 *  实现该协议的类必须实现text属性
 */
@property (strong,nonatomic) NSString* text;
@end
@interface WebTest : NSObject<WebProtocol>

@end
@implementation WebTest
//设置text属性
-(void)setText:(NSString *)text
{
    NSLog(@"xxx");
}
//获取text属性
-(NSString*)text
{
    return @"xxx";
}

@end
@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //获取test.html的bundle path
    //    NSString *path= [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *path= [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    
    NSURL *url=[NSURL fileURLWithPath:path];
    class_addProtocol([UITextField class], @protocol(WebProtocol));
    [_viewWeb loadRequest:[NSURLRequest requestWithURL:url]];
    _viewWeb.delegate=self;
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url=request.URL;
    //判断scheme是否是自定义的
    if([url.scheme isEqualToString:@"native"])
    {
        //判断host是什么方法
        if([url.host isEqualToString:@"log"])
        {
            //将query param拼接起来
            NSString *query=url.query;
            NSArray *arr=[query componentsSeparatedByString:@"&"];
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            for(NSString *str in arr)
            {
                NSArray *arrItem=[str componentsSeparatedByString:@"="];
                dic[arrItem[0]]=arrItem[1];
            }
            NSLog(@"%@",dic[@"pwd"]);
        }
        return NO;
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"alert(1)"];
    //获取JSContext对象，对应javascript上下文里的window对象
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"str"]=@"abcd";
    context[@"log"]=^(NSString* str)
    {
        NSLog(@"%@",str);
    };
    context[@"texObj"]=_texTest;
    //    WebTest *obj=[[WebTest alloc] init];
    //    context[@"texObj"]=obj;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"js"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"js"];
}
@end
