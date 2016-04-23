//
//  Function.h
//  testgh
//
//  Created by zzsoft on 16/1/20.
//  Copyright © 2016年 zzsoft. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Function : NSObject

// 定时器 timer_create(超时时间, 时间间隔[秒], 每一个时间间隔执行(当前时间, 是否下次停止), 停止时执行())
void timer_create(NSTimeInterval timeout, NSTimeInterval interval, void(^runingExec)(NSTimeInterval currentTime, BOOL *stop), void(^stopExec)());

// 倒计时 countdownTimeout(开始时间, 每次时间减少量, 每一个时间间隔执行(当前时间), 停止时执行())
void countdownTimeout(NSTimeInterval startTime, NSTimeInterval interval, void(^runingExec)(NSTimeInterval currentTime), void(^stopExec)());

#pragma mark -
// 转换
NSString *strWithInt(int i);
NSURL *url(NSString *str);

#pragma mark - UIColor
/* UIColor */
UIColor *color_rgb(CGFloat r, CGFloat g, CGFloat b);
UIColor *color_rgba(CGFloat r, CGFloat g, CGFloat b, CGFloat a);
UIColor *color_rgb_(UInt8 r, UInt8 g, UInt8 b);
UIColor *color_rgba_(UInt8 r, UInt8 g, UInt8 b, CGFloat a);
UIColor *color_image(UIImage *image);
UIColor *color_hex(NSUInteger hex);
UIColor *color_hexAlpha(NSUInteger hex, CGFloat alpha);

#pragma mark - UIImage
/* UIImage */
UIImage *image_name(NSString *name);
UIImage *image_color(UIColor *color);

#pragma mark -
/** 检查摄像头*/
BOOL checkValidateCamera();

/** 拨打电话(电话号码 number, 拨打前提示 isPrompt)*/
BOOL callTelNumber(NSString *number, BOOL isPrompt);

#pragma mark -

id userDefaultsGet(NSString *key);
void userDefaultsSet(id obj, NSString *key);
void userDefaultsRemove(NSString *key);
void userDefaultsClear();

#pragma mark -
/* 沙盒路径 */
/** NSHomeDirectory()/Documents/*/
NSString *pathDocuments();

/** NSHomeDirectory()/Library/Caches/*/
NSString *pathCaches();

/** NSHomeDirectory()/Documents/<文件名>*/
NSString *pathDocumentsFileName(NSString *name);

/** NSHomeDirectory()/<子路径>/<文件名>*/
NSString *pathDocumentsFilePathName(NSString *subPath, NSString *name);

/** NSHomeDirectory()/<文件名>*/
NSString *pathCachesFileName(NSString *name);

/** NSHomeDirectory()/<子路径>/<文件名>*/
NSString *pathCachesFilePathName(NSString *subPath, NSString *name);

#pragma mark -
/** 获取类的变量列表*/
NSArray *getVarList(Class cla);
@end
