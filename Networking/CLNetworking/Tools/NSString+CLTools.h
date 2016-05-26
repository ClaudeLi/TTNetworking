//
//  NSString+CLTools.h
//  Networking
//
//  Created by ClaudeLi on 16/5/26.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CLTools)

/**
 *  要保存在服务器上的[文件名]
 *
 *  @return 图片名
 */
+ (NSString *)imageFileName;

/**
 *  上传文件的[mimeType]
 *
 *  @return 默认@"image/jpeg"
 */
+ (NSString *)imageFieldType;

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



@end
