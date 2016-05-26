//
//  NSString+Cache.m
//  Networking
//
//  Created by ClaudeLi on 16/5/26.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "NSString+Cache.h"
#import "CLNetworking.h"

@implementation NSString (Cache)

+ (NSString *)cachesPathString{
    //Caches目录
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathcaches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [pathcaches stringByAppendingPathComponent:NetworkCache];
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return createPath;
}


+ (NSString *)stringWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)stringNowTimeDifferenceWith:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    //设置一个字符串的时间
    NSMutableString *datestring = [NSMutableString stringWithFormat:@"%@",time];
    //注意 如果20141202052740必须是数字，如果是UNIX时间，不需要下面的插入字符串。
    [datestring insertString:@"-" atIndex:4];
    [datestring insertString:@"-" atIndex:7];
    [datestring insertString:@" " atIndex:10];
    [datestring insertString:@":" atIndex:13];
    [datestring insertString:@":" atIndex:16];
    
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * newdate = [dm dateFromString:datestring];
    long dd = (long)[datenow timeIntervalSince1970] - [newdate timeIntervalSince1970];
    NSString *timeString=@"";
    
    timeString = [NSString stringWithFormat:@"%.2f", dd/60.0];
    return timeString;
}

@end
