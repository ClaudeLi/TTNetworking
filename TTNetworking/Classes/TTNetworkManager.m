
//
//  TTNetworkManager.m
//  TTNetworking
//
//  Created by ClaudeLi on 2018/7/28.
//  Copyright © 2018年 ClaudeLi. All rights reserved.
//

#import "TTNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+TTNetwork.h"
#import "TTUploadObject.h"

typedef NS_ENUM(NSInteger, TTNetworkRequestType) {
    TTNetworkRequestTypeGET,      // GET请求
    TTNetworkRequestTypePOST,     // POST请求
};

NSNotificationName const TTNetworkStatusChangeNotification = @"TTNetworkStatusChangeNotification";

static AFHTTPSessionManager *afmanager;
static AFNetworkReachabilityStatus currentStatus = AFNetworkReachabilityStatusUnknown;

@implementation TTNetworkManager

+ (NSString *)cachePath{
    return [NSString cachesPathString];
}

+ (AFHTTPSessionManager *)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 15;
        afmanager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为要获取text/plain类型数据
        afmanager.requestSerializer.timeoutInterval = 15;
        afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
      //[afnManager.requestSerializer setValue:[NSString userAgent] forHTTPHeaderField:@"User-Agent"];
    });
    return afmanager;
}

+ (void)checkNetworkStatus:(void(^)(NSInteger status))block{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    //2.监听改变
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        currentStatus = status;
        if (block) {
            block(currentStatus);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:TTNetworkStatusChangeNotification object:@(status)];
    }];
    [reachability startMonitoring];
}

+ (NSInteger)currentNetworkStatus{
    return currentStatus;
}

+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure{
    [self requestType:TTNetworkRequestTypeGET
            URLString:URLString
           parameters:parameters
            cacheTime:0
            isRefresh:NO
         fetchNewData:YES
              success:^BOOL(id data) {
        if (success) {
            success(data);
        }
        return NO;
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
  cacheTime:(NSTimeInterval)cacheTime
  isRefresh:(BOOL)isRefresh
    success:(BOOL (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure{
    [self requestType:TTNetworkRequestTypeGET
            URLString:URLString
           parameters:parameters
            cacheTime:cacheTime
            isRefresh:isRefresh
         fetchNewData:NO
              success:^BOOL(id data) {
        if (success) {
            return success(data);
        }
        return NO;
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
  cacheTime:(NSTimeInterval)cacheTime
fetchNewData:(BOOL)fetchNewData
    success:(BOOL (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure{
    [self requestType:TTNetworkRequestTypeGET
            URLString:URLString
           parameters:parameters
            cacheTime:cacheTime
            isRefresh:NO
         fetchNewData:fetchNewData
              success:^BOOL(id data) {
        if (success) {
            return success(data);
        }
        return NO;
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure{
    [self requestType:TTNetworkRequestTypePOST
            URLString:URLString
           parameters:parameters
            cacheTime:0
            isRefresh:NO
         fetchNewData:YES
              success:^BOOL(id data) {
        if (success) {
            success(data);
        }
        return NO;
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
   cacheTime:(NSTimeInterval)cacheTime
   isRefresh:(BOOL)isRefresh
     success:(BOOL (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure{
    [self requestType:TTNetworkRequestTypePOST
            URLString:URLString
           parameters:parameters
            cacheTime:cacheTime
            isRefresh:isRefresh
         fetchNewData:NO
              success:^BOOL(id data) {
        if (success) {
            return success(data);
        }
        return NO;
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
   cacheTime:(NSTimeInterval)cacheTime
fetchNewData:(BOOL)fetchNewData
     success:(BOOL (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure{
    [self requestType:TTNetworkRequestTypePOST
            URLString:URLString
           parameters:parameters
            cacheTime:cacheTime
            isRefresh:NO
         fetchNewData:fetchNewData
              success:^BOOL(id data) {
        if (success) {
            return success(data);
        }
        return NO;
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 文件下载
+ (NSURLSessionDownloadTask *)downloadWithURLString:(NSString *)URLString
                                         outputPath:(NSString *(^)(NSURLResponse *))outputPath
                                           progress:(void (^)(int64_t, int64_t))progress
                                  completionHandler:(void (^)(NSURLResponse *, NSURL *, NSError *))completionHandler{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *task = [self.manager downloadTaskWithRequest:request
                                                                  progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress.totalUnitCount, downloadProgress.completedUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 要求返回URL文件的位置的路径
        if (outputPath) {
            return [NSURL fileURLWithPath:outputPath(response)];
        }
        return nil;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response, filePath, error);
        }
    }];
    [task resume];
    return task;
}

// 文件上传
+ (NSURLSessionDataTask *)uploadWithURLString:(NSString *)URLString
                                   parameters:(id)parameters
                                         objs:(NSArray <TTUploadObject *>*)objs
                                     progress:(void (^)(int64_t completedUnit, int64_t totalUnit))progress
                                      success:(BOOL (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure{
    return
    [self.manager POST:URLString
            parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
    for (int i = 0; i < objs.count; i++) {
        TTUploadObject *obj = objs[i];
        NSString *fileName = obj.fileName;
        if (fileName == nil || ![fileName isKindOfClass:[NSString class]] || fileName.length == 0) {
            // 如果文件名为空，以时间命名文件名
            fileName = [NSString networkingUrlString_md5:[NSString stringWithFormat:@"%f_%ld", [[NSDate date] timeIntervalSince1970], (long)i]];
        }
        [formData appendPartWithFileData:obj.data name:obj.field fileName:fileName mimeType:obj.mimeType];
    }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (task.error.code == NSURLErrorCancelled) {
            // 请求取消
            if (failure) {
                failure(task.error);
            }
        }else{
            // 请求失败
            if (failure) {
                failure(error);
            }
        }
    }];
}

#pragma mark -
#pragma mark -- Private Methods --
+ (void)requestType:(TTNetworkRequestType)type
          URLString:(NSString *)URLString
         parameters:(id)parameters
          cacheTime:(NSTimeInterval)cacheTime
          isRefresh:(BOOL)isRefresh
       fetchNewData:(BOOL)fetchNewData
            success:(BOOL(^)(id data))success
            failure:(void(^)(NSError *error))failure{
    // 如果缓存且不是刷新
    NSString *key = [self cacheKey:URLString params:parameters];
    if (cacheTime > 0 && !isRefresh) {
        NSTimeInterval saveTime = [self readCacheTimeWithKey:key];
        if (saveTime) {
            id cacheData = [self readCacheDataWithKey:key];
            if (cacheData) {
                NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
                if ((currentTime-saveTime) < cacheTime) {
                    if (fetchNewData) {
                        if (success) {
                            success(cacheData);
                        }
                    }else{
                        if (success) {
                            success(cacheData);
                        }
                        return;
                    }
                }
            }
        }
    }
    if (type == TTNetworkRequestTypeGET) {
        // GET请求
        [self.manager GET:URLString
               parameters:parameters
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，加入缓存，解析数据
            if (success) {
                BOOL save = success(responseObject);
                if (save && cacheTime > 0.0) {
                    [self saveCacheResponseObject:responseObject key:key];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (task.error.code == NSURLErrorCancelled) {
                // 请求取消
                if (failure) {
                    failure(task.error);
                }
            }else{
                // 请求失败
                if (failure) {
                    failure(error);
                }
            }
        }];
        
    }else{
        // POST请求
        [self.manager POST:URLString
                parameters:parameters
                  progress:^(NSProgress * _Nonnull uploadProgress) {
            // 请求的进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，加入缓存，解析数据
            if (success) {
                BOOL save = success(responseObject);
                if (save && cacheTime > 0.0) {
                    [self saveCacheResponseObject:responseObject key:key];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (task.error.code == NSURLErrorCancelled) {
                // 请求取消
                if (failure) {
                    failure(task.error);
                }
            }else{
                // 请求失败
                if (failure) {
                    failure(error);
                }
            }
        }];
    }
}

/**
 *  缓存文件夹下某地址的文件名，及UserDefaulets中的key值
 *
 *  @param urlString 请求地址
 *  @param params    请求参数
 *
 *  @return 返回一个MD5加密后的字符串
 */
+ (NSString *)cacheKey:(NSString *)urlString params:(id)params{
    NSString *absoluteURL = [NSString generateGETAbsoluteURL:urlString params:params];
    NSString *key = [NSString networkingUrlString_md5:absoluteURL];
    return key;
}

+ (NSString *)cacheDataPathWithKey:(NSString *)key{
    return [[self.cachePath stringByAppendingPathComponent:key] stringByAppendingPathExtension:@"dat"];
}

+ (NSString *)cacheTimePathWithKey:(NSString *)key{
    return [[self.cachePath stringByAppendingPathComponent:key] stringByAppendingPathExtension:@"cfg"];
}


/**
 读取缓存时间

 @param key key
 @return 时间戳
 */
+ (NSTimeInterval)readCacheTimeWithKey:(NSString *)key {
    NSData *timeData = [[NSFileManager defaultManager] contentsAtPath:[self cacheTimePathWithKey:key]];
    if (!timeData) {
        return 0;
    }
    NSString *timeStr = [[NSString alloc] initWithData:timeData encoding:NSUTF8StringEncoding];
    if (!timeStr) {
        return 0;
    }
    return [timeStr doubleValue];
}

/**
 *  读取缓存
 *
 *  @param key   key
 *
 *  @return 数据data
 */
+ (nullable NSData *)readCacheDataWithKey:(NSString *)key {
    return [[NSFileManager defaultManager] contentsAtPath:[self cacheDataPathWithKey:key]];
}


/**
 *  添加缓存
 *
 *  @param responseObject 请求成功数据
 *  @param key            请求地址
 */
+ (void)saveCacheResponseObject:(id)responseObject key:(NSString *)key {
    NSString *dataPath = [self cacheDataPathWithKey:key];
    [self deleteFileWithPath:dataPath];
    if ([[NSFileManager defaultManager] createFileAtPath:dataPath contents:responseObject attributes:nil]) {
        NSData *timeData = [[NSString stringWithFormat:@"%.2f", [[NSDate date] timeIntervalSince1970]] dataUsingEncoding:NSUTF8StringEncoding];
        NSString *timePath = [self cacheTimePathWithKey:key];;
        [self deleteFileWithPath:timePath];
        if (![[NSFileManager defaultManager] createFileAtPath:timePath contents:timeData attributes:nil]) {
            NSLog(@"Network Cache Save Time Error: %@\n", timePath);
        }
    }else{
        NSLog(@"Network Cache Save Data Error: %@\n", dataPath);
    }
}

/**
 *  判断文件是否已经存在，若存在删除
 *
 *  @param path 文件路径
 */
+ (void)deleteFileWithPath:(NSString *)path{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *err;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&err];
        if (err) {
            NSLog(@"Network File Remove Error, %@", err.localizedDescription);
        }
    }
}

// 单个文件的大小
+ (long long)fileSizeAtPath:(NSString*)filePath{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        return [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark -
#pragma mark -- Public Methods --

/**
 The data, upload, and download tasks currently run by the managed session.
 */
+ (NSArray<NSURLSessionTask *> *)tasks{
    return self.manager.tasks;
}

+ (NSArray<NSURLSessionDataTask *> *)dataTasks{
    return self.manager.dataTasks;
}

+ (NSArray<NSURLSessionUploadTask *> *)uploadTasks{
    return self.manager.uploadTasks;
}

+ (NSArray<NSURLSessionDownloadTask *> *)downloadTasks{
    return self.manager.downloadTasks;
}

/**
 Invalidates the managed session, optionally canceling pending tasks.
 
 @param cancelPendingTasks Whether or not to cancel pending tasks.
 */
+ (void)invalidateSessionCancelingTasks:(BOOL)cancelPendingTasks{
    [self.manager invalidateSessionCancelingTasks:cancelPendingTasks];
}


+ (long long)getCacheFileSize{
    NSString *folderPath = self.cachePath;
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[fm subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

+ (void)clearCaches{
    [self deleteFileWithPath:self.cachePath];
}

+ (void)clearWithUrlString:(NSString *)urlString params:(id)params{
    NSString *key = [self cacheKey:urlString params:params];
    [self deleteFileWithPath:[self cacheDataPathWithKey:key]];
    [self deleteFileWithPath:[self cacheTimePathWithKey:key]];
}

@end

@implementation NSArray (NSURLSessionTask)

/**
 暂停任务
 */
- (void)pauseTasks{
    if (self.count > 0) {
        [self enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj suspend];
        }];
    }
}

/**
 取消任务
 */
- (void)cancelTasks{
    if (self.count > 0) {
        [self enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj suspend];
            [obj cancel];
        }];
    }
}

@end
