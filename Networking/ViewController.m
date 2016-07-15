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
//    } fail:^(NSError *error) {
//        NSLog(@"%@", error);
//    }];
    
    // GET请求 带缓存时间
    [CLNetworkingManager getCacheRequestWithUrlString:titleURL parameters:nil cacheTime:0.5 succeed:^(id data) {
        NSLog(@"%@",data);
    } fail:^(NSError *error) {
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
//    } fail:^(NSError *error) {
//        NSLog(@"%@", error);
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
