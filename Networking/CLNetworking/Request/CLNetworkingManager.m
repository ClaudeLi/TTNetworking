//
//  CLNetworkingManager.m
//  Networking
//
//  Created by ClaudeLi on 16/4/28.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "CLNetworkingManager.h"

// 网络状态，初始值-1：未知网络状态
static NSInteger networkStatus = -1;

// 缓存路径
static inline NSString *cachePath() {
    return [NSString cachesPathString];
}

@implementation CLNetworkingManager

#pragma mark -- 网络判断 --
+ (void)checkNetworkLinkStatus{
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
        networkStatus = status;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NetworkLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NetworkLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NetworkLog(@"3G|4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NetworkLog(@"WiFi");
                break;
            default:
                break;
        }
    }];
    [reachability startMonitoring];
}

+ (NSInteger)theNetworkStatus{
    // 调用完checkNetworkLinkStatus,才可以调用此方法
    return networkStatus;
}

#pragma mark -- GET请求 --
+ (void)getNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSString *error))fail{
    // 是否开启缓存机制，如果有缓存，读取缓存
    if (isCache) {
        id cacheData = [self cahceResponseWithURL:urlString parameters:parameters];
        if (cacheData) {
            id dict = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (succeed) {
                succeed(dict);
            }
        }
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，加入缓存，解析数据
        if (isCache) {
            [self cacheResponseObject:responseObject urlString:urlString parameters:parameters];
        }
        id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        if (succeed) {
            succeed(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSString *errorStr = [error localizedDescription];
        errorStr = ([self theNetworkStatus] == 0) ? ErrorNotReachable:errorStr;
        if (fail) {
            fail(errorStr);
        }
    }];
}

#pragma mark -- POST请求 --
+ (void)postNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSString *error))fail{
    // 是否开启缓存机制，如果有缓存，读取缓存
    if (isCache) {
        id cacheData = [self cahceResponseWithURL:urlString parameters:parameters];
        if (cacheData) {
            id dict = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (succeed) {
                succeed(dict);
            }
        }
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        // 请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，加入缓存，解析数据
        if (isCache) {
            [self cacheResponseObject:responseObject urlString:urlString parameters:parameters];
        }
        id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        if (succeed) {
            succeed(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSString *errorStr = [error localizedDescription];
        errorStr = ([self theNetworkStatus] == 0) ? ErrorNotReachable:errorStr;
        if (fail) {
            fail(errorStr);
        }
    }];
}

#pragma mark -- 上传图片 --
+ (void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                      model:(CLImageModel *)model
                   progress:(void (^)(float writeKB, float totalKB)) progress
                    succeed:(void (^)())succeed
                       fail:(void (^)(NSString *error))fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        NSData *imageData = UIImageJPEGRepresentation(model.image, 1);
        NSString *imageFileName = model.imageName;
        if (imageFileName == nil || ![imageFileName isKindOfClass:[NSString class]] || imageFileName.length == 0) {
            // 如果文件名为空，以时间命名文件名
            imageFileName = [NSString imageFileName];
        }
        [formData appendPartWithFileData:imageData name:imageFileName fileName:imageFileName mimeType:[NSString imageFieldType]];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        float uploadKB = uploadProgress.completedUnitCount/1024.0;
        float grossKB = uploadProgress.totalUnitCount/1024.0;
        if (progress) {
            progress(uploadKB, grossKB);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (succeed) {
            succeed();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSString *errorStr = [error localizedDescription];
        errorStr = ([self theNetworkStatus] == 0) ? ErrorNotReachable:errorStr;
        if (fail) {
            fail(errorStr);
        }
    }];
}

#pragma mark -- 缓存处理 --
/**
 *  读取缓存
 *
 *  @param url    请求地址
 *  @param params 拼接的参数
 *
 *  @return 数据data
 */
+ (id)cahceResponseWithURL:(NSString *)url parameters:(id)params {
    id cacheData = nil;
    if (url) {
        // 读取本地缓存
        NSString *absoluteURL = [NSString generateGETAbsoluteURL:url params:params];
        NSString *key = [NSString networkingUrlString_md5:absoluteURL];
        NSString *path = [cachePath() stringByAppendingPathComponent:key];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
        }
    }
    return cacheData;
}

/**
 *  添加缓存
 *
 *  @param responseObject 请求成功数据
 *  @param urlString      请求地址
 *  @param params         拼接的参数
 */
+ (void)cacheResponseObject:(id)responseObject urlString:(NSString *)urlString parameters:(id)params {
    NSString *absoluteURL = [NSString generateGETAbsoluteURL:urlString params:params];
    NSString *key = [NSString networkingUrlString_md5:absoluteURL];
    NSString *path = [cachePath() stringByAppendingPathComponent:key];
    [self deleteFileWithPath:path];
    BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:responseObject attributes:nil];
    if (isOk) {
        NetworkLog(@"cache file success: %@\n", path);
    } else {
        NetworkLog(@"cache file error: %@\n", path);
    }
}

// 清空缓存
+ (void)clearCaches {
    NSString *directoryPath = cachePath();
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        if (error) {
            NetworkLog(@"clear caches error: %@", error);
        } else {
            NetworkLog(@"clear caches success");
        }
    }
}

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少KB
+ (float)getCacheFileSize{
    NSString *folderPath = cachePath();
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/1024.0;
}

/**
 *  判断文件是否已经存在，若存在删除
 *
 *  @param path 文件路径
 */
+ (void)deleteFileWithPath:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exist = [fm fileExistsAtPath:url.path];
    NSError *err;
    if (exist) {
        [fm removeItemAtURL:url error:&err];
        NetworkLog(@"file deleted success");
        if (err) {
            NetworkLog(@"file remove error, %@", err.localizedDescription );
        }
    } else {
        NetworkLog(@"no file by that name");
    }
}

@end
