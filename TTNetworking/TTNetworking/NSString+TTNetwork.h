//
//  NSString+TTNetwork.h
//  TTNetworking
//
//  Created by ClaudeLi on 2018/7/28.
//  Copyright © 2018年 ClaudeLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TTNetwork)

/**
 *  生成AbsoluteURL（仅对一级字典结构起作用）
 *
 *  @param url    请求地址
 *  @param params 拼接参数
 *
 *  @return urlString
 */
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params;

/**
 *  MD5加密，用于缓存文件名
 *
 *  @param string 要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString *)networkingUrlString_md5:(NSString *)string;

/**
 *  网络缓存地址
 *
 *  @return Caches路径
 */
+ (NSString *)cachesPathString;

@end
