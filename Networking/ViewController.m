//
//  ViewController.m
//  Networking
//
//  Created by ClaudeLi on 16/4/27.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "ViewController.h"
#import <TTNetworking/TTNetworking.h>

// 测试URL
#define KMain_URL @"http://test.tiaooo.com/interface/?"

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
//    [TTNetworkManager GET:titleURL parameters:nil success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSError *error) {
//        NSLog(@"%@", error);
//    }];
    
    // GET请求 带缓存时间
    [TTNetworkManager GET:titleURL parameters:nil cacheTime:30.0 isRefresh:NO success:^BOOL(id responseObject) {
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
//    [TTNetworkManager uploadWithURLString:titleURL parameters:nil uploadObj:model progress:^(int64_t completedUnit, int64_t totalUnit) {
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
    NSLog(@"cacheSize===%f", [TTNetworkManager getCacheFileSize]);
    [TTNetworkManager clearCaches];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
