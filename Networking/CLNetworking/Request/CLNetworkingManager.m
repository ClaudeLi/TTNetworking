//
//  CLNetworkingManager.m
//  Networking
//
//  Created by ClaudeLi on 16/4/28.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "CLNetworkingManager.h"
#import "NSString+Cache.h"

typedef NS_ENUM(NSInteger, NetworkRequestType) {
    NetworkRequestTypeGET,  // GET请求
    NetworkRequestTypePOST,  // POST请求
};

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
+ (void)getNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    [self requestType:NetworkRequestTypeGET url:urlString parameters:parameters isCache:isCache cacheTime:0.0 succeed:succeed fail:fail];
}

#pragma mark -- GET请求 <含缓存时间> --
+ (void)getCacheRequestWithUrlString:(NSString *)urlString parameters:(id)parameters cacheTime:(float)time succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    [self requestType:NetworkRequestTypeGET url:urlString parameters:parameters isCache:YES cacheTime:time succeed:succeed fail:fail];
}


#pragma mark -- POST请求 --
+ (void)postNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    [self requestType:NetworkRequestTypePOST url:urlString parameters:parameters isCache:isCache cacheTime:0.0 succeed:succeed fail:fail];
}

#pragma mark -- POST请求 <含缓存时间> --
+ (void)postCacheRequestWithUrlString:(NSString *)urlString parameters:(id)parameters cacheTime:(float)time succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{

    [self requestType:NetworkRequestTypePOST url:urlString parameters:parameters isCache:YES cacheTime:time succeed:succeed fail:fail];
}


#pragma mark -- 网络请求 --
/**
 *  网络请求
 *
 *  @param type       请求类型，get请求/Post请求
 *  @param urlString  请求地址字符串
 *  @param parameters 请求参数
 *  @param isCache    是否缓存
 *  @param time       缓存时间
 *  @param succeed    请求成功回调
 *  @param fail       请求失败回调
 */
+ (void)requestType:(NetworkRequestType)type url:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache cacheTime:(float)time succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    NSString *key = [self cacheKey:urlString params:parameters];
    // 判断网址是否加载过，如果没有加载过 在执行网络请求成功时，将请求时间和网址存入UserDefaults，value为时间date、Key为网址
    if ([CacheDefaults objectForKey:key]) {
        // 如果UserDefaults存过网址，判断本地数据是否存在
        id cacheData = [self cahceResponseWithURL:urlString parameters:parameters];
        if (cacheData) {
            // 如果本地数据存在
            // 判断存储时间，如果在规定直接之内，读取本地数据，解析并return，否则将继续执行网络请求
            if (time > 0) {
                NSDate *oldDate = [CacheDefaults objectForKey:key];
                float cacheTime = [[NSString stringNowTimeDifferenceWith:[NSString stringWithDate:oldDate]] floatValue];
                if (cacheTime < time) {
                    id dict = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                    if (succeed) {
                        succeed(dict);
                    }
                    return;
                }
            }
        }
    }else{
        // 判断是否开启缓存
        if (isCache) {
            id cacheData = [self cahceResponseWithURL:urlString parameters:parameters];
            if (cacheData) {
                id dict = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                if (succeed) {
                    succeed(dict);
                }
            }
        }
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (type == NetworkRequestTypeGET) {
        // GET请求
        [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，加入缓存，解析数据
            if (isCache) {
                if (time > 0.0) {
                    [CacheDefaults setObject:[NSDate date] forKey:key];
                }
                [self cacheResponseObject:responseObject urlString:urlString parameters:parameters];
            }
            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (succeed) {
                succeed(dict);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            if (fail) {
                fail(error);
            }
        }];
        
    }else{
        // POST请求
        [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            // 请求的进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，加入缓存，解析数据
            if (isCache) {
                if (time > 0.0) {
                    [CacheDefaults setObject:[NSDate date] forKey:key];
                }
                [self cacheResponseObject:responseObject urlString:urlString parameters:parameters];
            }
            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (succeed) {
                succeed(dict);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            if (fail) {
                fail(error);
            }
        }];
    }
}

#pragma mark -- 上传图片 --
+ (void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                      model:(CLImageModel *)model
                   progress:(void (^)(float writeKB, float totalKB)) progress
                    succeed:(void (^)())succeed
                       fail:(void (^)(NSError *error))fail{
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
        [formData appendPartWithFileData:imageData name:model.field fileName:imageFileName mimeType:[NSString imageFieldType]];
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
        if (fail) {
            fail(error);
        }
    }];
}

#pragma mark -- 缓存处理 --
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
        NSString *key = [self cacheKey:url params:params];
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
    NSString *key = [self cacheKey:urlString params:params];
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
    // 删除CacheDefaults中的存放时间和地址的键值对，并删除cache文件夹
    NSString *directoryPath = cachePath();
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:directoryPath]){
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:directoryPath] objectEnumerator];
        NSString *key;
        while ((key = [childFilesEnumerator nextObject]) != nil){
            NetworkLog(@"remove_key ==%@",key);
            [CacheDefaults removeObjectForKey:key];
        }
    }
    if ([manager fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [manager removeItemAtPath:directoryPath error:&error];
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
