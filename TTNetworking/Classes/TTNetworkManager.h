//
//  TTNetworkManager.h
//  TTNetworking
//
//  Created by ClaudeLi on 2018/7/28.
//  Copyright © 2018年 ClaudeLi. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *NetworkCacheFile = @"com.caches.networking";

FOUNDATION_EXTERN NSNotificationName const TTNetworkStatusChangeNotification;

@class AFHTTPSessionManager;
@class TTUploadObject;
@interface TTNetworkManager : NSObject

/**
 请求实例
 
 @return AFHTTPSessionManager obj
 */
+ (AFHTTPSessionManager *)manager;

/**
 缓存路径
 
 @return path
 */
+ (NSString *)cachePath;

/**
 启用网络状态检测
 
 @param block 回调 status网络状态 AFNetworkReachabilityStatus
 
 */
+ (void)checkNetworkStatus:(void(^)(NSInteger status))block;

/**
 当前网络状态

 @return status AFNetworkReachabilityStatus
 */
+ (NSInteger)currentNetworkStatus;


/**
 GET请求, <无缓存,直接请求>

 @param URLString 请求地址
 @param parameters 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

/**
 GET请求, 开启缓存 <在缓存时间之内只读取缓存数据，不会再次网络请求，减少服务器请求压力。缺点：在缓存时间内服务器数据改变，缓存数据不会及时刷新>
 
 @param URLString 请求地址
 @param parameters 请求参数
 @param cacheTime 缓存时间
 @param isRefresh 是否刷新
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
  cacheTime:(NSTimeInterval)cacheTime
  isRefresh:(BOOL)isRefresh
    success:(BOOL (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

/**
 GET请求 <若读取到缓存数据, 是否继续请求新的数据>

 @param URLString 请求地址
 @param parameters 请求参数
 @param cacheTime 缓存时间
 @param fetchNewData 是否获取新的数据
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
  cacheTime:(NSTimeInterval)cacheTime
fetchNewData:(BOOL)fetchNewData
    success:(BOOL (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

/**
 POST请求, <无缓存,直接请求>
 
 @param URLString 请求地址
 @param parameters 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/**
 POST请求, 开启缓存 <在缓存时间之内只读取缓存数据，不会再次网络请求，减少服务器请求压力。缺点：在缓存时间内服务器数据改变，缓存数据不会及时刷新>
 
 @param URLString 请求地址
 @param parameters 请求参数
 @param cacheTime 缓存时间
 @param isRefresh 是否刷新
 @param success 成功回调,返回YES缓存,反之不缓存
 @param failure 失败回调
 */
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
   cacheTime:(NSTimeInterval)cacheTime
   isRefresh:(BOOL)isRefresh
     success:(BOOL (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/**
 POST请求 <若读取到缓存数据, 是否继续请求新的数据>
 
 @param URLString 请求地址
 @param parameters 请求参数
 @param cacheTime 缓存时间
 @param fetchNewData 是否获取新的数据
 @param success 成功回调,返回YES缓存,反之不缓存
 @param failure 失败回调
 */
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
   cacheTime:(NSTimeInterval)cacheTime
fetchNewData:(BOOL)fetchNewData
     success:(BOOL (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/**
 文件下载

 @param URLString 下载地址
 @param outputPath 存储路径
 @param progress 下载进度
 @param completionHandler completionHandler description
 @return NSURLSessionDownloadTask obj
 */
+ (NSURLSessionDownloadTask *)downloadWithURLString:(NSString *)URLString
                                         outputPath:(NSString *(^)(NSURLResponse *response))outputPath
                                           progress:(void (^)(int64_t totalUnit, int64_t completedUnit))progress
                                  completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;


/**
 文件上传

 @param URLString 请求地址
 @param parameters 请求参数
 @param objs 上传对象
 @param progress 上传进度
 @param success 成功回调
 @param failure 失败回调
 */
+ (NSURLSessionDataTask *)uploadWithURLString:(NSString *)URLString
                                   parameters:(id)parameters
                                         objs:(NSArray <TTUploadObject *>*)objs
                                     progress:(void (^)(int64_t completedUnit, int64_t totalUnit))progress
                                      success:(BOOL (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure;

/**
 The data, upload, and download tasks currently run by the managed session.
 */
+ (NSArray<NSURLSessionTask *> *)tasks;

/**
 数据任务
 */
+ (NSArray<NSURLSessionDataTask *> *)dataTasks;

/**
 上传任务
 */
+ (NSArray<NSURLSessionUploadTask *> *)uploadTasks;

/**
 下载任务
 */
+ (NSArray<NSURLSessionDownloadTask *> *)downloadTasks;

/**
 Invalidates the managed session, optionally canceling pending tasks.
 
 @param cancelPendingTasks Whether or not to cancel pending tasks.
 */
+ (void)invalidateSessionCancelingTasks:(BOOL)cancelPendingTasks;


/**
 *  获取网络缓存文件大小
 *
 *  @return 单位B
 */
+ (long long)getCacheFileSize;

/**
 *  清空缓存
 */
+ (void)clearCaches;

/**
 *  清理单个缓存
 *
 *  @param urlString 缓存url
 *  @param params    请求参数
 */
+ (void)clearWithUrlString:(NSString *)urlString params:(id)params;


@end

@interface NSArray (NSURLSessionTask)

/**
 暂停任务
 */
- (void)pauseTasks;

/**
 取消任务
 */
- (void)cancelTasks;

@end
