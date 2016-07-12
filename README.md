# CLNetworking
基于AFNetworking3.0,简单的二次封装网络请求 

基于AFNetworking3.0， Get请求、Post请求、图片上传及缓存处理的简单封装

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
*  Get请求 <若开启缓存，先读取本地缓存数据，再进行网络请求>
*
*  @param urlString  请求地址
*  @param parameters 拼接的参数
*  @param isCache    是否开启缓存
*  @param succeed    请求成功
*  @param fail       请求失败
*/
+ (void)getNetworkRequestWithUrlString:(NSString *)urlString
parameters:(id)parameters
isCache:(BOOL)isCache
succeed:(void(^)(id data))succeed
fail:(void(^)(NSString *error))fail;

/**
*  Get请求 <在缓存时间之内只读取缓存数据，不会再次网络请求，减少服务器请求压力。缺点：在缓存时间内服务器数据改变，缓存数据不会及时刷新>
*
*  @param urlString  请求地址
*  @param parameters 拼接的参数
*  @param time       缓存时间（单位：分钟）
*  @param succeed    请求成功
*  @param fail       请求失败
*/
+ (void)getCacheRequestWithUrlString:(NSString *)urlString 
parameters:(id)parameters
cacheTime:(float)time 
succeed:(void(^)(id data))succeed
fail:(void(^)(NSString *error))fail;

/**
*  Post请求 <若开启缓存，先读取本地缓存数据，再进行网络请求，>
*
*  @param urlString  请求地址
*  @param parameters 拼接的参数
*  @param isCache    是否开启缓存机制
*  @param succeed    请求成功
*  @param fail       请求失败
*/
+ (void)postNetworkRequestWithUrlString:(NSString *)urlString 
parameters:(id)parameters
isCache:(BOOL)isCache 
succeed:(void(^)(id data))succeed
fail:(void(^)(NSString *error))fail;

/**
*  Post请求 <在缓存时间之内只读取缓存数据，不会再次网络请求，减少服务器请求压力。缺点：在缓存时间内服务器数据改变，缓存数据不会及时刷新>
*
*  @param urlString  请求地址
*  @param parameters 拼接的参数
*  @param time       缓存时间（单位：分钟）
*  @param succeed    请求成功
*  @param fail       请求失败
*/
+ (void)postCacheRequestWithUrlString:(NSString *)urlString 
parameters:(id)parameters
cacheTime:(float)time
succeed:(void(^)(id data))succeed
fail:(void(^)(NSString *error))fail;

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


使用方法：


        // Appdelegate检测网络状态
        - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
            // 检查网络状态
            [CLNetworkingManager checkNetworkLinkStatus];
            return YES;
        }


        // GET请求
        [CLNetworkingManager getNetworkRequestWithUrlString:titleURL parameters:nil isCache:YES succeed:^(id data) {
            NSLog(@"%@",data);
        } fail:^(NSString *error) {
            NSLog(@"%@", error);
        }];

        // GET请求 带缓存时间
        [CLNetworkingManager getCacheRequestWithUrlString:titleURL parameters:nil cacheTime:0.5 succeed:^(id data) {
            NSLog(@"%@",data);
        } fail:^(NSString *error) {
            NSLog(@"%@", error);
        }];


        // 上传图片
        CLImageModel *model = [[CLImageModel alloc] init];
        model.image = [UIImage imageNamed:@"imaged625f"];
        model.field = @"file";
        [CLNetworkingManager uploadWithURLString:titleURL parameters:nil model:model progress:^(float writeKB, float totalKB) {
            NSLog(@"writeKB = %f, totalKB = %f", writeKB, totalKB);
        } succeed:^{
            NSLog(@"成功");
        } fail:^(NSString *error) {
            NSLog(@"%@", error);
        }];
