//
//  ViewController.m
//  UMDemo
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 QIcareful. All rights reserved.
//
/**
 *  完成友盟统计,友盟分享,推送需要等待苹果开发者证书
 *
 *  @param void <#void description#>
 *
 *  @return <#return value description#>
 */
#import "ViewController.h"
#import <MobClick.h>
#import <UMSocial.h>
#import "WXApiRequestHandler.h"
#import "ListViewController.h"//测试页面
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "RouteSearchDemoViewController.h"
#import <AFNetworking.h>
#import "AFHTTPSessionManager.h"
#import "CityTC.h"
#import "PickerViewController.h"
#import "TLCityPickerController.h"
#import "WebViewController.h"
#import "SosoViewController.h"
#import "FingerprintViewController.h"
#import "PasswordViewController.h"
#import "HelloViewController.h"
#import <HealthKit/HealthKit.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPPaymentControl.h"
#define KBtn_width        200
#define KBtn_height       80
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          80
#define kCellHeight_Normal  50
#define kCellHeight_Manual  145

#define kVCTitle          @"商户测试"
#define kBtnFirstTitle    @"获取订单，开始测试"
#define kWaiting          @"正在获取TN,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"


#define kMode_Development             @"01"
#define kURL_TN_Normal_Q                @"http://101.231.204.84:8091/sim/getacptn"
#define kURL_TN_Normal                @"http://192.168.0.89:8080/app_pay/form05_6_2_AppConsume"
#define kURL_TN_Configure             @"http://101.231.204.84:8091/sim/app.jsp?user=123456789"
#define CHANPING @"http://192.168.0.81/hcFortune/upload/mobile/more.php?act=checkVersion"
#define MERCHANTS @"777290058123453"
@interface ViewController ()<TLCityPickerDelegate,UITextFieldDelegate>
{
    UIAlertView* _alertView;
    NSMutableData* _responseData;
    CGFloat _maxWidth;
    CGFloat _maxHeight;
    NSString *_uppayString;
    UITextField *_urlField;
    UITextField *_modeField;
    UITextField *_curField;
}
@property (nonatomic, copy) NSString *string;
@property(nonatomic, retain)NSString *currentVersion;//用来记录版本号
@property(nonatomic, retain)NSString *appurl;

@property(nonatomic, retain)NSString *tempStr;
@property (nonatomic, strong) HKHealthStore *healthStore;//健康
@property(nonatomic, copy)NSString *tnMode;


@end

@implementation ViewController
@synthesize contentTableView;
@synthesize tnMode;

- (void)viewDidLoad {
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;

    self.navigationController.navigationItem.title = @"测试";
    //版本更新  获取版本
    NSString *key = @"CFBundleShortVersionString";
    self.currentVersion = [NSBundle mainBundle].infoDictionary[key];
    [[NSUserDefaults standardUserDefaults]synchronize];

    [self banbenceshi];

    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(60, 10, 70, 35)];
    [btn setTitle:@"分享" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn setTintColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(did) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    
    UIButton *wxpay = [[UIButton alloc] initWithFrame:CGRectMake(200, 10, 100, 35)];
    [wxpay setTitle:@"微信支付" forState:UIControlStateNormal];
    wxpay.backgroundColor = [UIColor redColor];
    [wxpay setTintColor:[UIColor redColor]];
    [wxpay addTarget:self action:@selector(wxpay) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:wxpay];
    
    
    UIButton *alipay = [[UIButton alloc] initWithFrame:CGRectMake(200, 50, 70, 35)];
    [alipay setTitle:@"支付宝" forState:UIControlStateNormal];
    alipay.backgroundColor = [UIColor redColor];
    [alipay setTintColor:[UIColor redColor]];
    [alipay addTarget:self action:@selector(alipay) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:alipay];
    UIButton *login = [[UIButton alloc] initWithFrame:CGRectMake(60, 50, 70, 35)];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    login.backgroundColor = [UIColor blackColor];
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:login];
    
    UIButton *pushList = [[UIButton alloc] initWithFrame:CGRectMake(200, 90, 70, 35)];
    [pushList setTitle:@"地图" forState:UIControlStateNormal];
    pushList.backgroundColor = [UIColor blackColor];
    [pushList addTarget:self action:@selector(pushList) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:pushList];
    
    UIButton *ad = [[UIButton alloc] initWithFrame:CGRectMake(60, 90, 70, 35)];
    [ad setTitle:@"轮播" forState:UIControlStateNormal];
    ad.backgroundColor = [UIColor blackColor];
    [ad addTarget:self action:@selector(ad) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:ad];
    
    UIButton *city = [[UIButton alloc] initWithFrame:CGRectMake(60, 130, 70, 35)];
    [city setTitle:@"商圈" forState:UIControlStateNormal];
    city.backgroundColor = [UIColor blackColor];
    [city addTarget:self action:@selector(city) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:city];
    
    UIButton *picker = [[UIButton alloc] initWithFrame:CGRectMake(200, 130, 70, 35)];
    [picker setTitle:@"城市" forState:UIControlStateNormal];
    picker.backgroundColor = [UIColor blackColor];
    [picker addTarget:self action:@selector(picker) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:picker];
    
    UIButton *js = [[UIButton alloc] initWithFrame:CGRectMake(60, 170, 70, 35)];
    [js setTitle:@"js" forState:UIControlStateNormal];
    js.backgroundColor = [UIColor blackColor];
    [js addTarget:self action:@selector(js) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:js];
    
    UIButton *soso = [[UIButton alloc] initWithFrame:CGRectMake(200, 170, 70, 35)];
    [soso setTitle:@"搜索" forState:UIControlStateNormal];
    soso.backgroundColor = [UIColor blackColor];
    [soso addTarget:self action:@selector(soso) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:soso];
    
    UIButton *fingerprint = [[UIButton alloc] initWithFrame:CGRectMake(60, 210, 70, 35)];
    [fingerprint setTitle:@"指纹" forState:UIControlStateNormal];
    fingerprint.backgroundColor = [UIColor blackColor];
    [fingerprint addTarget:self action:@selector(fingerprint) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:fingerprint];
    
    UIButton *password = [[UIButton alloc] initWithFrame:CGRectMake(200, 210, 70, 35)];
    [password setTitle:@"密码" forState:UIControlStateNormal];
    password.backgroundColor = [UIColor blackColor];
    [password addTarget:self action:@selector(password) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:password];
    
    UIButton *hello = [[UIButton alloc] initWithFrame:CGRectMake(60, 250, 70, 35)];
    [hello setTitle:@"H5+" forState:UIControlStateNormal];
    hello.backgroundColor = [UIColor blackColor];
    [hello addTarget:self action:@selector(hello) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:hello];
    
    UIButton *healthKit = [[UIButton alloc] initWithFrame:CGRectMake(200, 250, 120, 35)];
    [healthKit setTitle:@"HealthKit" forState:UIControlStateNormal];
    healthKit.backgroundColor = [UIColor blackColor];
    [healthKit addTarget:self action:@selector(healthKit) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:healthKit];
    
    UIButton *uppay = [[UIButton alloc] initWithFrame:CGRectMake(60, 290, 70, 35)];
    [uppay setTitle:@"银联" forState:UIControlStateNormal];
    uppay.backgroundColor = [UIColor blackColor];
    [uppay addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:uppay];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - H5+ 调用 WebView
- (void)hello {
    HelloViewController *hello = [[HelloViewController alloc] init];
    [self.navigationController pushViewController:hello animated:YES];
}
#pragma mark - 九宫格解锁
- (void)password {
    PasswordViewController *password = [[PasswordViewController alloc] init];
    [self.navigationController pushViewController:password animated:YES];
    
}
#pragma mark - 指纹解锁
- (void)fingerprint {
    FingerprintViewController *fingerprint = [[FingerprintViewController alloc] init];
    [self.navigationController pushViewController:fingerprint animated:YES];
}
#pragma mark - soso 搜索
- (void)soso {
    SosoViewController *soso = [[SosoViewController alloc] init];
    [self.navigationController pushViewController:soso animated:YES];
}
#pragma mark - js runtime  js交互
- (void)js {
    WebViewController *webjs = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webjs animated:YES];
//    [self presentViewController:webjs animated:YES completion:^{
//        NSLog(@"0.................0");
//    }];
}
#pragma mark - SDCycleScrollViewDelegate 轮播图
- (void)ad {
    ListViewController *rouVC = [[ListViewController alloc] init];
    
    [self presentViewController:rouVC animated:YES completion:^{
        NSLog(@"0.................0");
    }];

}
#pragma mark - DOPDropDownMenu 商圈选择
- (void)city {
    CityTC *city = [[CityTC alloc] init];
    [self.navigationController pushViewController:city animated:YES];
//    [self presentViewController:city animated:YES completion:^{
//        NSLog(@"0.................0");
//    }];
}
#pragma mark - UMengShare  友盟分享
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)did {
    NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";             //分享内嵌文字
    //    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];          //分享内嵌图片
    UIImage *shareImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QI_share" ofType:@"png"]];
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:nil
                                       delegate:(id)self];
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"507fcab25270157b37000010"
//                                      shareText:@"我要分享"
//                                     shareImage:[UIImage imageNamed:@"icon.png"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
//                                       delegate:(id)self];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
}
/**
 *  请求订单号
 */
-(void)post {
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    // 拼接请求参数
    //                params.put("m", "Index");
    //				params.put("a", "generateOrder");
    //				params.put("payment", @"alipay");
    //				params.put("userId", "1");
    //				params.put("goodsName", title);
    //				params.put("orderAmount", total_fee);
    /**
     *  777290058110097
     777290058123453
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"merId"] = MERCHANTS;
    params[@"txnAmt"] = @"1";
    params[@"orderId"] = [self generateTradeNO];
    
    [manager POST:kURL_TN_Normal parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"请求成功:%@", responseObject);
        
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = JSON[@"data"];
        _uppayString = dic[@"tn"];
        
        NSLog(@"请求成功JSON:%@                                 ////////tn=%@", JSON,_uppayString);
        [self uppay];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败:%@", error.description);
        
    }];

}
#pragma mark - Login 登录
- (void)login{
    // 使用Sina微博账号登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response) {
        NSLog(@"response is %@", response);
        // 如果是授权到新浪微博，SSO之后如果想获取用户的昵称、头像等需要再获取一次账户信息
        [[UMSocialDataService defaultDataService]requestSocialAccountWithCompletion:^(UMSocialResponseEntity *response) {
            // 打印用户昵称
//            NSLog(@"SinaWeibo's user name is %@", [[[response.data objectForKey:@"accounts"]objectForKey:UMShareToSina] objectForKey:@"username"]);
        }];
    });
}
#pragma mark - BaiDuMap 百度地图
- (void)pushList {
    RouteSearchDemoViewController *rouVC = [[RouteSearchDemoViewController alloc] init];
    [self.navigationController pushViewController:rouVC animated:YES];
    
//    [self presentViewController:rouVC animated:YES completion:^{
//        NSLog(@"0.................0");
//    }];
}

#pragma mark - WeiXin 微信支付
- (void)wxpay {
    NSString *res = [WXApiRequestHandler jumpToBizPay];
    if( ![@"" isEqual:res] ){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }
}
#pragma mark - Alipay  支付宝支付
/**
 *  传入订单数据
 */
- (void)alipay {
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088811109596174";
    NSString *seller = @"caihonghome2015@163.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOPpMqaRm60H99OKbUEqOALBUmUdiDcHebjNWrx01nTaYayIxoD9agCI3eeXPQ2LIwMJUni4Pdx8JnwJb+cQlQ5LMdvedZMnIuOddRYcTGtka4//iymoWWdbMzEgGcvRa63Vcq//8nSaWnNLNdOrWs77mXFbG2yLON/oOSOSvSQ9AgMBAAECgYATAGZQrOMl0fw/jtL9E+AHmsab15J7xAvJ9JUUEUmwBGUQVXb3Wil0UfTuUhWtA2Sv5B8UIYhG0bMDtGW4BhHnLt+nLQ6lOMNh2ld/zXUQI/xLA3aYdFYNpWDcRNg49603Q/3m8PvxehgdzuxuN5Uz/3zj4HdPPVuewI37ZVqnAQJBAPqkSUcvMI5odHDl4ZTvEGnynnnzklVZHkk58yuw+oe34O895VG84TjW+27dXIbM/gc+01BcqM7/VzRW9gfOrBUCQQDoyIKgv1ghIiLRal9mhxKW8C6g4N8m17ZbIgUXDpbSOIkAM4ej9D4DvBH0mpExIzNPxIhtLDmVfA8Q/bqxQRmJAkEAtdgTwi2ekPN/55khPSjlQ7je+aOZ+4oYyw/cOUrBuU3TSEAj7FWZId/3s8uuoa6Ab0lJjvhrESN4ZWTiQ2/SsQJANz5GieF/B7XzL2GgLFPH3Jw5ZKKZMr2koDINpTAoKNGT6cFQ4l73TKmYVUVNSa0B419PxSDmtYwQg0bDxIcfiQJATDVfxIKKFrv6eESx4ughxkERbUzNJBRTrxbhQM6GMcOnvL8Jtdh9YSh1tFlnVocZ0FmRZAbCWihTYE2PYrX4lQ==";
    //    "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOPpMqaRm60H99OKbUEqOALBUmUdiDcHebjNWrx01nTaYayIxoD9agCI3eeXPQ2LIwMJUni4Pdx8JnwJb+cQlQ5LMdvedZMnIuOddRYcTGtka4//iymoWWdbMzEgGcvRa63Vcq//8nSaWnNLNdOrWs77mXFbG2yLON/oOSOSvSQ9AgMBAAECgYATAGZQrOMl0fw/jtL9E+AHmsab15J7xAvJ9JUUEUmwBGUQVXb3Wil0UfTuUhWtA2Sv5B8UIYhG0bMDtGW4BhHnLt+nLQ6lOMNh2ld/zXUQI/xLA3aYdFYNpWDcRNg49603Q/3m8PvxehgdzuxuN5Uz/3zj4HdPPVuewI37ZVqnAQJBAPqkSUcvMI5odHDl4ZTvEGnynnnzklVZHkk58yuw+oe34O895VG84TjW+27dXIbM/gc+01BcqM7/VzRW9gfOrBUCQQDoyIKgv1ghIiLRal9mhxKW8C6g4N8m17ZbIgUXDpbSOIkAM4ej9D4DvBH0mpExIzNPxIhtLDmVfA8Q/bqxQRmJAkEAtdgTwi2ekPN/55khPSjlQ7je+aOZ+4oYyw/cOUrBuU3TSEAj7FWZId/3s8uuoa6Ab0lJjvhrESN4ZWTiQ2/SsQJANz5GieF/B7XzL2GgLFPH3Jw5ZKKZMr2koDINpTAoKNGT6cFQ4l73TKmYVUVNSa0B419PxSDmtYwQg0bDxIcfiQJATDVfxIKKFrv6eESx4ughxkERbUzNJBRTrxbhQM6GMcOnvL8Jtdh9YSh1tFlnVocZ0FmRZAbCWihTYE2PYrX4lQ=="
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"支付"; //商品标题
    order.productDescription = @"支付"; //商品描述
    order.amount = @"0.01"; //商品价格
    order.notifyURL =  @"https://www.caihonghome.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"paydemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            /**
             *  支付结果回调，支付宝会返回支付结果信息，一般是走这个方法。
             */
            NSLog(@"reslut = %@",resultDic);
            NSString *title = nil;
            if ([resultDic[@"resultStatus"] intValue]==9000) {
                title = @"回调1 支付成功！";
                [self paySucceed];
            }else{
                title = @"回调1 支付失败！";
                [self payFailed];
            }
            
        }];
        
    }
    
    
}
/**
 *  随机生成订单号
 *
 */
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
/**
 *  请求订单号
 */
- (void)testgetDemo {
    
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];


    // 拼接请求参数
//                params.put("m", "Index");
//				params.put("a", "generateOrder");
//				params.put("payment", @"alipay");
//				params.put("userId", "1");
//				params.put("goodsName", title);
//				params.put("orderAmount", total_fee);

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   params[@"m"] = @"Index";
   params[@"a"] = @"generateOrder";
   params[@"payment"] = @"alipay";
   params[@"userId"] = @"1";
   params[@"goodsName"] = @"123";
   params[@"orderAmount"] = @"0.01";

    [manager POST:@"http://192.168.0.81/demo/tpdemo31/index.php" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
      
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功:%@", responseObject);
 
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
          NSDictionary *dic = JSON[@"data"];
          self.string = dic[@"orderSn"];
        NSLog(@"请求成功JSON:%@                                 ////////%@", JSON,_string);
          [self alipay];

     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
                   NSLog(@"请求失败:%@", error.description);
        
               }];
}
/**
 *  支付成功处理
 */
- (void)paySucceed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果：" message:@"支付成功！"
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
/**
 *  支付失败处理
 */
- (void)payFailed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果：" message:@"支付失败"
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}



#pragma mark - UpdateDelegate 升级
- (void)banbenceshi
{
    
//    NSString *strr = CHANPING;
    //    NSString *strr = [CHANPING stringByAppendingString:self.currentVersion];
    
    
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSDictionary *dic = @{@"act":@"checkVersion"};
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session POST:CHANPING parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //        获得的json先转换成字符串
        
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        //        字符串再生成NSData
        
        NSData * data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        
        //        再解析
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *jsoniOS = [jsonDict objectForKey:@"IOS"];
        self.tempStr = [jsoniOS objectForKey:@"code"];
        self.mustUpdate = [[jsoniOS valueForKeyPath:@"mustUpdate"] description];
        
        
        
        NSString *mess = [jsoniOS valueForKeyPath:@"note"];
        NSString *title = [jsoniOS valueForKeyPath:@"title"];
        NSLog(@"%@%@%@",self.tempStr,self.mustUpdate,mess);
        if ([[self.tempStr description] isEqualToString:@"101"])
        {
            // 此时有版本更新 根据后台返回的url到调转到appstore跟新就ok
            
            NSString *dicone = [jsoniOS objectForKey:@"url"];
            
            self.appurl = dicone;
            
            
            if ([self.mustUpdate isEqualToString:@"1"])
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:mess preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"马上升级" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appurl]];
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
                return ;
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:mess preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"");
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appurl]];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
                return ;
            }
        } else {
            NSLog(@"meiyougengxin==================================================");
        }
        //        NSDictionary *dicc =(NSDictionary *)responseObject;
        NSLog(@"成功%@",jsonDict);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger )buttonIndex
//{
//    if ([self.mustUpdate isEqualToString:@"1"])
//    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appurl]];
//    }
//    else
//    {
//        if (buttonIndex == 1)
//        {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appurl]];
//        }
//        
//    }
//}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([self.mustUpdate isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appurl]];

    } else {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appurl]];
        }

    }

}

#pragma mark - TLCityPickerDelegate 城市选择
- (void)picker {
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    
    cityPickerVC.locationCityID = @"600010000";
    
    //    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
    
}
- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
//    [self.cityPickerButton setTitle:city.cityName forState:UIControlStateNormal];
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - UPPayDelegate 银联支付

- (void)uppay {
    self.tnMode = kMode_Development;
//    [self startNetWithURL:[NSURL URLWithString:_uppayString]];
    [self startNetWithURL:[NSURL URLWithString:kURL_TN_Normal_Q]];
//    [self showAlertWait];
    [self startNetWithURL:[NSURL URLWithString:_urlField.text]];
}
- (void)extendedLayout
{
    BOOL iOS7 = [UIDevice currentDevice].systemVersion.floatValue >= 7.0;
    if (iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    CGFloat offset = iOS7 ? 64 : 44;
    _maxWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    _maxHeight = CGRectGetHeight([UIScreen mainScreen].bounds)-offset;
    
    self.navigationController.navigationBar.translucent = NO;
}


- (void)startNetWithURL:(NSURL *)url
{
    [_curField resignFirstResponder];
    _curField = nil;
    [self showAlertWait];
    
    NSURLRequest * urlRequest=[NSURLRequest requestWithURL:url];
    NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [urlConn start];
}

- (UITextField *)textFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeHolder;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    return textField;
}

#pragma mark - Alert

- (void)showAlertWait
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alertView show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(_alertView.frame.size.width / 2.0f - 15, _alertView.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [_alertView addSubview:aiv];
    
}

- (void)showAlertMessage:(NSString*)msg
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:self cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    
}
- (void)hideAlert
{
    if (_alertView != nil)
    {
        [_alertView dismissWithClickedButtonIndex:0 animated:NO];
        _alertView = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _alertView = nil;
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _curField = textField;
}
#pragma mark - connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    NSInteger code = [rsp statusCode];
    if (code != 200)
    {
        
        [self showAlertMessage:kErrorNet];
        [connection cancel];
    }
    else
    {
        _responseData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self hideAlert];
    NSString* tn = [[NSMutableString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    tn = _uppayString;
    if (tn != nil && tn.length > 0)
    {
        
        NSLog(@"tn=%@",tn);
        [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UMDemo" mode:self.tnMode viewController:self];
        
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self showAlertMessage:kErrorNet];
}


#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{
    NSString* msg = [NSString stringWithFormat:kResult, result];
    [self showAlertMessage:msg];
}
#pragma mark - HealthKitDelegate 健康统计
- (void)healthKit {
    //判断healthKit是否可用
    if(NSClassFromString(@"HKHealthStore") && [HKHealthStore isHealthDataAvailable])
    {
        // Add your HealthKit code here
        NSLog(@"healthKit可以用");
        [self authorization];
        [self steps];
        [self weight];
        [self sample];
    } else {
        NSLog(@"healthKit不可以用");
        
    }
}

/**
 *  授权获得修改数据
 */
- (void) authorization{
    HKHealthStore *healthStore = [[HKHealthStore alloc] init];
    
    // Share body mass, height and body mass index
    NSSet *shareObjectTypes = [NSSet setWithObjects:
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                               nil];
    
    // Read date of birth, biological sex and step count
    NSSet *readObjectTypes  = [NSSet setWithObjects:
                               [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                               [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                               nil];
    
    // Request access
    [healthStore requestAuthorizationToShareTypes:shareObjectTypes
                                        readTypes:readObjectTypes
                                       completion:^(BOOL success, NSError *error) {
                                           
                                           if(success == YES)
                                           {
                                               // ...
                                           }
                                           else
                                           {
                                               // Determine if it was an error or if the
                                               // user just canceld the authorization request
                                           }
                                           
                                       }];

}
/**
 *  步数
 */
- (void) steps{
    HKHealthStore *healthStore = [[HKHealthStore alloc] init];

    // Set your start and end date for your query of interest
    NSDate *startDate, *endDate;
    
    // Use the sample type for step count
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    // Create a predicate to set start/end date bounds of the query
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    // Create a sort descriptor for sorting by start date
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                                 predicate:predicate
                                                                     limit:HKObjectQueryNoLimit
                                                           sortDescriptors:@[sortDescriptor]
                                                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                
                                                                if(!error && results)
                                                                {
                                                                    for(HKQuantitySample *samples in results)
                                                                    {
                                                                        // your code here
                                                                    }
                                                                }
                                                                
                                                            }];
    
    // Execute the query
    [healthStore executeQuery:sampleQuery];
}
/**
 *  体重
 */
- (void) weight{
    // Some weight in gram
    HKHealthStore *healthStore = [[HKHealthStore alloc] init];

    double weightInGram = 50400.f;
    
    // Create an instance of HKQuantityType and
    // HKQuantity to specify the data type and value
    // you want to update
    NSDate          *now = [NSDate date];
    HKQuantityType  *hkQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantity      *hkQuantity = [HKQuantity quantityWithUnit:[HKUnit gramUnit] doubleValue:weightInGram];
    
    // Create the concrete sample
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:hkQuantityType
                                                                     quantity:hkQuantity
                                                                    startDate:now
                                                                      endDate:now];
    
    // Update the weight in the health store
    [healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
        // ..
    }];

}
/**
 *  性别与年龄
 */
- (void) age{
    NSError *error;
    HKHealthStore *healthStore = [[HKHealthStore alloc] init];

    HKBiologicalSexObject *bioSex = [healthStore biologicalSexWithError:&error];
    
    switch (bioSex.biologicalSex) {
        case HKBiologicalSexNotSet:
            // undefined
            break;
        case HKBiologicalSexFemale:
            // ...
            break;
        case HKBiologicalSexMale:
            // ...
            break;
    }
}
/**
 *  sample
 */
- (void) sample{
    
    //查看healthKit在设备上是否可用，ipad不支持HealthKit
    if(![HKHealthStore isHealthDataAvailable])
    {
        NSLog(@"设备不支持healthKit");
    }
    
    //创建healthStore实例对象
    self.healthStore = [[HKHealthStore alloc] init];
    
    //设置需要获取的权限这里仅设置了步数
    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSSet *healthSet = [NSSet setWithObjects:stepCount, nil];
    
    //从健康应用中获取权限
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
        if (success)
        {
            NSLog(@"获取步数权限成功");
            //获取步数后我们调用获取步数的方法
            [self readStepCount];
        }
        else
        {
            NSLog(@"获取步数权限失败");
        }
    }];

}
- (void)readStepCount {
    //查询采样信息
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    //NSSortDescriptors用来告诉healthStore怎么样将结果排序。
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    /*查询的基类是HKQuery，这是一个抽象类，能够实现每一种查询目标，这里我们需要查询的步数是一个
     HKSample类所以对应的查询类就是HKSampleQuery。
     下面的limit参数传1表示查询最近一条数据,查询多条数据只要设置limit的参数值就可以了
     */
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:nil limit:1 sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        //打印查询结果
        NSLog(@"resultCount = %ld result = %@",results.count,results);
        //把结果装换成字符串类型
        HKQuantitySample *result = results[0];
        HKQuantity *quantity = result.quantity;
        NSString *stepStr = (NSString *)quantity;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            //查询是在多线程中进行的，如果要对UI进行刷新，要回到主线程中
            NSLog(@"最新步数：%@",stepStr);
        }];
        
    }];
    //执行查询
    [self.healthStore executeQuery:sampleQuery];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"主页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"主页"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
