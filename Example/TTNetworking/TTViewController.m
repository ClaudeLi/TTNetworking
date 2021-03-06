//
//  TTViewController.m
//  TTNetworking
//
//  Created by claudeli@yeah.net on 08/25/2018.
//  Copyright (c) 2018 claudeli@yeah.net. All rights reserved.
//

#import "TTViewController.h"
#import <TTNetworking/TTNetworking.h>

// 测试URL
#define KMain_URL @"http://test.tiaooo.com/interface/school/get_dance"

@interface TTViewController ()

@end

@implementation TTViewController

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
    NSString * titleURL = KMain_URL;
    NSDictionary *parameters = @{@"version":@"4.0.0"};
    // GET请求
    //    [TTNetworkManager GET:titleURL parameters:parameters success:^(id responseObject) {
    //        NSLog(@"%@",responseObject);
    //    } failure:^(NSError *error) {
    //        NSLog(@"%@", error);
    //    }];
    
    // GET请求 带缓存时间
    [TTNetworkManager GET:titleURL parameters:parameters cacheTime:30.0 isRefresh:NO success:^BOOL(id responseObject) {
        NSLog(@"%@", responseObject);
        return YES;
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    // 上传图片
    //    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"imaged625f"]);
    //    TTUploadObject *model = [TTUploadObject objectWithData:data
    //                                                     field:@"file"
    //                                                  fileName:nil
    //                                                  mimeType:@"image/png"];
    //    [TTNetworkManager uploadWithURLString:titleURL parameters:parameters uploadObj:model progress:^(int64_t completedUnit, int64_t totalUnit) {
    //        NSLog(@"writeB = %ld, totalB = %ld", completedUnit, totalUnit);
    //    } success:^BOOL(id responseObject) {
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    // 取消上传
    //    [TTNetworkManager.uploadTasks cancelTasks]
}

- (void)clearButtonAction{
    NSLog(@"cacheSize = %lld B", [TTNetworkManager getCacheFileSize]);
    
    // 清理网络缓存
    [TTNetworkManager clearCaches];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
