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
#define CHANPING @"http://192.168.0.81/hcFortune/upload/mobile/more.php?act=checkVersion"

@interface ViewController ()<TLCityPickerDelegate>
@property (nonatomic, copy) NSString *string;
@property(nonatomic, retain)NSString *currentVersion;//用来记录版本号
@property(nonatomic, retain)NSString *appurl;

@property(nonatomic, retain)NSString *tempStr;
@end

@implementation ViewController

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
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)password {
    PasswordViewController *password = [[PasswordViewController alloc] init];
    [self.navigationController pushViewController:password animated:YES];
    
}
- (void)fingerprint {
    FingerprintViewController *fingerprint = [[FingerprintViewController alloc] init];
    [self.navigationController pushViewController:fingerprint animated:YES];
}
- (void)soso {
    SosoViewController *soso = [[SosoViewController alloc] init];
    [self.navigationController pushViewController:soso animated:YES];
//    [self presentViewController:soso animated:YES completion:^{
//        NSLog(@"0.................0");
//    }];

}
- (void)picker {
//    PickerViewController *pick = [[PickerViewController alloc] init];
//    [self presentViewController:pick animated:YES completion:^{
//        NSLog(@"0.................0");
//    }];
    [self add];
}
- (void)js {
    WebViewController *webjs = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webjs animated:YES];
//    [self presentViewController:webjs animated:YES completion:^{
//        NSLog(@"0.................0");
//    }];
}
- (void)ad {
    ListViewController *rouVC = [[ListViewController alloc] init];
    
    [self presentViewController:rouVC animated:YES completion:^{
        NSLog(@"0.................0");
    }];

}
- (void)city {
    CityTC *city = [[CityTC alloc] init];
    [self.navigationController pushViewController:city animated:YES];
//    [self presentViewController:city animated:YES completion:^{
//        NSLog(@"0.................0");
//    }];
}
- (void)wxpay {
    NSString *res = [WXApiRequestHandler jumpToBizPay];
    if( ![@"" isEqual:res] ){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }
}
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
-(void)post {
    
}

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
- (void)pushList {
    RouteSearchDemoViewController *rouVC = [[RouteSearchDemoViewController alloc] init];
    [self.navigationController pushViewController:rouVC animated:YES];
    
//    [self presentViewController:rouVC animated:YES completion:^{
//        NSLog(@"0.................0");
//    }];
}
- (void)push {
    RouteSearchDemoViewController *rouVC = [[RouteSearchDemoViewController alloc] init];
    
    [self presentViewController:rouVC animated:YES completion:^{
        NSLog(@"0.................0");
    }];
}

/**
 *  随机生成订单号
 *
 *  @return <#return value description#>
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

- (void)paySucceed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果：" message:@"支付成功！"
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)payFailed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果：" message:@"支付失败"
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  提示更新
 */
- (void)banbenceshi
{
    
    NSString *strr = CHANPING;
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

/**
 *  升级
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger )buttonIndex
{
    if ([self.mustUpdate isEqualToString:@"1"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appurl]];
    }
    else
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appurl]];
        }
        
    }
}
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

    
//    if (buttonIndex == 0) {
//        NSLog(@"确定");
//    }else if (buttonIndex == 1) {
//        NSLog(@"第一项");
//    }else if(buttonIndex == 2) {
//        NSLog(@"第二项");
//    }else if(buttonIndex == actionSheet.cancleButtonIndex) {
//        NSLog(@"取消");
//    }
//    
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
//    [self.cityPickerButton setTitle:city.cityName forState:UIControlStateNormal];
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
