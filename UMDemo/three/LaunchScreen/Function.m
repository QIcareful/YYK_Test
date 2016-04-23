//
//  Function.m
//  testgh
//
//  Created by zzsoft on 16/1/20.
//  Copyright © 2016年 zzsoft. All rights reserved.
//


#import "Function.h"
#import <objc/runtime.h>

@implementation Function

void timer_create(NSTimeInterval timeout, NSTimeInterval interval, void(^runingExec)(NSTimeInterval currentTime, BOOL *stop), void(^stopExec)())
{
    __block int         _currentT   = 0;
    __block BOOL        _stop       = NO;
    dispatch_queue_t    _queue      = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t   _timer      = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if (_currentT >= timeout || _stop)
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                stopExec();
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                runingExec(_currentT, &_stop);
                _currentT ++;
            });
        }
    });
    dispatch_resume(_timer);
}

void countdownTimeout(NSTimeInterval startTime, NSTimeInterval interval, void(^runingExec)(NSTimeInterval currentTime), void(^stopExec)())
{
    __block NSTimeInterval  _timeout    = startTime;
    dispatch_queue_t        _queue      = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t       _timer      = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (_timeout <= 0)
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                stopExec();
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                runingExec(_timeout);
                _timeout -= interval;
            });
        }
    });
    dispatch_resume(_timer);
}

NSString *strWithInt(int i)
{
    return [NSString stringWithFormat:@"%d", i];
}

NSURL *url(NSString *str)
{
    return [NSURL URLWithString:str];
}

UIColor *color_rgb(CGFloat r, CGFloat g, CGFloat b)
{
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

UIColor *color_rgba(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

UIColor *color_rgb_(UInt8 r, UInt8 g, UInt8 b)
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

UIColor *color_rgba_(UInt8 r, UInt8 g, UInt8 b, CGFloat a)
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

UIColor *color_image(UIImage *image)
{
    return [UIColor colorWithPatternImage:image];
}

UIColor *color_hex(NSUInteger hex)
{
    CGFloat red = (hex >> 16 & 0xFF) / 255.0f;
    CGFloat green = (hex >> 8 & 0xFF) / 255.0f;
    CGFloat blue = (hex & 0xFF) / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

UIColor *color_hexAlpha(NSUInteger hex, CGFloat alpha)
{
    CGFloat red = (hex >> 16 & 0xFF) / 255.0f;
    CGFloat green = (hex >> 8 & 0xFF) / 255.0f;
    CGFloat blue = (hex & 0xFF) / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

UIImage *image_name(NSString *name)
{
    return [UIImage imageNamed:name];
}

UIImage *image_color(UIColor *color)
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

BOOL checkValidateCamera()
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

BOOL isPhoneNumber(NSString *str)
{
    //
    NSString *MOBILE    = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *CM        = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378]|7[7])\\d)\\d{7}$";   // 包含电信4G 177号段
    NSString *CU        = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT        = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    //
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:str];
    BOOL res2 = [regextestcm evaluateWithObject:str];
    BOOL res3 = [regextestcu evaluateWithObject:str];
    BOOL res4 = [regextestct evaluateWithObject:str];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    
    return NO;
}

BOOL callTelNumber(NSString *number, BOOL isPrompt)
{
    if (isPhoneNumber(number)) {
        if (isPrompt) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]]];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", number]]];
        }
        return YES;
    }
    return NO;
}

id userDefaultsGet(NSString *key)
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:key];
}

void userDefaultsSet(id obj, NSString *key)
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:obj forKey:key];
    [ud synchronize];
}

void userDefaultsRemove(NSString *key)
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:key];
    [ud synchronize];
}

void userDefaultsClear()
{
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
}

NSString *pathDocuments()
{
    return [NSString stringWithFormat:@"%@/Documents/", NSHomeDirectory()];
}

NSString *pathCaches()
{
    return [NSString stringWithFormat:@"%@/Library/Caches/", NSHomeDirectory()];
}

NSString *pathDocumentsFileName(NSString *name)
{
    return [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), name];
}

NSString *pathDocumentsFilePathName(NSString *subPath, NSString *name)
{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@/", NSHomeDirectory(), subPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [NSString stringWithFormat:@"%@%@", path, name];
}

NSString *pathCachesFileName(NSString *name)
{
    NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/", NSHomeDirectory()];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return [NSString stringWithFormat:@"%@%@", path, name];
}

NSString *pathCachesFilePathName(NSString *subPath, NSString *name)
{
    NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/%@/", NSHomeDirectory(), subPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [NSString stringWithFormat:@"%@%@", path, name];
}

NSArray *getVarList(Class cla)
{
    NSMutableArray *array = [NSMutableArray array];
    unsigned int count = 0;
    Ivar *members = class_copyIvarList(cla, &count);
    for (int i = 0; i < count; ++i) {
        Ivar var = members[i];
        const char *name = ivar_getName(var);
        const char *type = ivar_getTypeEncoding(var);
        
        NSDictionary *dict = @{@"name": [NSString stringWithUTF8String:name], @"type":[NSString stringWithUTF8String:type]};
        [array addObject:dict];
    }
    return array;
}
@end
