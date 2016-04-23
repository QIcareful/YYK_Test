//
//  NSUserDefaults+Extension.m
//  testgh
//
//  Created by zzsoft on 16/1/20.
//  Copyright © 2016年 zzsoft. All rights reserved.
//


#import "NSUserDefaults+Extension.h"

@implementation NSUserDefaults (Extension)

+ (id)objectForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
}

+ (void)removeObjectForKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
}

+ (NSString *)stringForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:defaultName];
}

+ (NSArray *)arrayForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:defaultName];
}

+ (NSDictionary *)dictionaryForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:defaultName];
}

+ (NSData *)dataForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] dataForKey:defaultName];
}

+ (NSArray *)stringArrayForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] stringArrayForKey:defaultName];
}

+ (NSInteger)integerForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}

+ (float)floatForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:defaultName];
}

+ (double)doubleForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:defaultName];
}

+ (BOOL)boolForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

+ (NSURL *)URLForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:defaultName];
}

+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:defaultName];
}

+ (void)setFloat:(float)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:defaultName];
}

+ (void)setDouble:(double)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:defaultName];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:defaultName];
}

+ (void)setURL:(NSURL *)url forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setURL:url forKey:defaultName];
}

+ (BOOL)synchronize
{
    return [[NSUserDefaults standardUserDefaults] synchronize];
}




@end
