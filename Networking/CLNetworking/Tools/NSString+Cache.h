//
//  NSString+Cache.h
//  Networking
//
//  Created by ClaudeLi on 16/5/26.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Cache)

/**
 *  网络缓存地址
 *
 *  @return Caches路径
 */
+ (NSString *)cachesPathString;

/**
 *  时间戳转换YYYYMMddHHmmss
 *
 *  @param date 需要转换的date
 *
 *  @return “YYYYMMddHHmmss”格式字符串
 */
+ (NSString *)stringWithDate:(NSDate *)date;

/**
 *  某时间与当前时间差计算
 *
 *  @param time 某时间 格式为“YYYYMMddHHmmss”
 *
 *  @return 时间差 单位分钟
 */
+ (NSString *)stringNowTimeDifferenceWith:(NSString *)time;

@end
