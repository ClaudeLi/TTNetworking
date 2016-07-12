//
//  ViewController.m
//  Networking
//
//  Created by ClaudeLi on 16/4/27.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "ViewController.h"
#import "CLNetworking.h"

// 测试URL
#define KMain_URL @"http://123.59.147.87/interface/?"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* button = [UIButton new];
    button.frame = CGRectMake(100, 100, 100, 50);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"请求" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton* clear = [UIButton new];
    clear.frame = CGRectMake(100, 200, 100, 50);
    clear.backgroundColor = [UIColor redColor];
    [clear setTitle:@"clear" forState:UIControlStateNormal];
    [clear addTarget:self action:@selector(clearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clear];
}


- (void)clickButtonAction{
    NSString * titleURL = [NSString stringWithFormat:@"%@&c=school&m=get_dance",KMain_URL];
//    NSString *titleURL = [NSString  stringWithFormat:@"%@&c=user&m=send_reg_sms&phone=0",KMain_URL];
    
    // GET请求
    
//    [CLNetworkingManager getNetworkRequestWithUrlString:titleURL parameters:nil isCache:YES succeed:^(id data) {
//        NSLog(@"%@",data);
//    } fail:^(NSString *error) {
//        NSLog(@"%@", error);
//    }];
    
    // GET请求 带缓存时间
    [CLNetworkingManager getCacheRequestWithUrlString:titleURL parameters:nil cacheTime:0.5 succeed:^(id data) {
        NSLog(@"%@",data);
    } fail:^(NSString *error) {
        NSLog(@"%@", error);
    }];
    
    
    // 上传图片
//    CLImageModel *model = [[CLImageModel alloc] init];
//    model.image = [UIImage imageNamed:@"imaged625f"];
//    model.field = @"file";
//    [CLNetworkingManager uploadWithURLString:titleURL parameters:nil model:model progress:^(float writeKB, float totalKB) {
//        NSLog(@"writeKB = %f, totalKB = %f", writeKB, totalKB);
//    } succeed:^{
//        NSLog(@"成功");
//    } fail:^(NSString *error) {
//        NSLog(@"%@", error);
//    }];
    
//    // 需要上传的东西
//    UIImage *uploadImage;
//    NSString *api_keyString;
//    NSString *api_secretString;
//    
//    NSString *imageFileName = @"自定义，一般以时间戳命名";
//    
//    // 地址
//    NSString *urlString;
//    // 上传参数
//    NSDictionary *dic = @{@"api_key":api_keyString, @"api_secret":api_secretString};
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
//        NSData *imageData = UIImageJPEGRepresentation(uploadImage, 1);
//        [formData appendPartWithFileData:imageData name:@"image" fileName:imageFileName mimeType:@"image/jpeg"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        float uploadKB = uploadProgress.completedUnitCount/1024.0;
//        float grossKB = uploadProgress.totalUnitCount/1024.0;
//        NSLog(@"已上传=%f, 总共=%f", uploadKB, grossKB);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"成功 responseObject = %@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"失败 error = %@", error);
//    }];
}

- (void)clearButtonAction{
    NSLog(@"cacheSize===%f", [CLNetworkingManager getCacheFileSize]);
    [CLNetworkingManager clearCaches];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
