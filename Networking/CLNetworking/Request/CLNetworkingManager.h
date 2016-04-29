//
//  CLNetworkingManager.h
//  Networking
//
//  Created by ClaudeLi on 16/4/28.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CLNetworking.h"

@class CLImageModel;
@interface CLNetworkingManager : NSObject

/**
 *  监听网络状态,程序启动执行一次即可
 */
+ (void)checkNetworkLinkStatus;

/**
 *  读取当前网络状态
 *
 *  @return -1:未知, 0:无网络, 1:2G|3G|4G, 2:WIFI
 */
+ (NSInteger)theNetworkStatus;

/**
 *  Get请求
 *
 *  @param urlString 请求地址
*  @param parameters 拼接的参数
 *  @param isCache   是否开启缓存
 *  @param succeed   请求成功
 *  @param fail      请求失败
 */
+ (void)getNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSString *error))fail;

/**
 *  Post请求
 *
 *  @param urlString  请求地址
 *  @param parameters 拼接的参数
 *  @param isCache    是否开启缓存机制
 *  @param succeed    请求成功
 *  @param fail       请求失败
 */
+ (void)postNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSString *error))fail;

/**
 *  上传图片
 *
 *  @param URLString  请求地址
 *  @param parameters 拼接的参数
 *  @param model      要上传的图片model
 *  @param progress   上传进度(writeKB：已上传多少KB, totalKB：总共多少KB)
 *  @param succeed    上传成功
 *  @param fail       上传失败
 */
+ (void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                      model:(CLImageModel *)model
                   progress:(void (^)(float writeKB, float totalKB)) progress
                    succeed:(void (^)())succeed
                       fail:(void (^)(NSString *error))fail;

/**
 *  清理缓存
 */
+ (void)clearCaches;

/**
 *  获取网络缓存文件大小
 *
 *  @return 多少KB
 */
+ (float)getCacheFileSize;

@end