//
//  CLNetworking.h
//  Networking
//
//  Created by ClaudeLi on 16/4/29.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#ifndef CLNetworking_h
#define CLNetworking_h

/*
 基于AFNetworking3.1.0二次封装
 */
#import <AFNetworking.h>

#import "CLNetworkingManager.h"
#import "CLImageModel.h"
#import "NSString+CLTools.h"

//重写NSLog,Debug模式下打印日志和当前行数
#ifdef DEBUG
#define NetworkLog(s, ... ) NSLog( @"[%@ line:%d]=> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NetworkLog(s, ... )
#endif

#define CacheDefaults [NSUserDefaults standardUserDefaults]

// 网络缓存文件夹名
#define NetworkCache @"NetworkCache"

#endif /* CLNetworking_h */
