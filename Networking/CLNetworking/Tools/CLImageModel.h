//
//  CLImageModel.h
//  Networking
//
//  Created by ClaudeLi on 16/4/29.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CLImageModel : NSObject
/*
 参数解释
 1. 要上传的图片
 2. 对应网站上[upload.php中]处理文件的字段
 3. 要保存在服务器上的[文件名]
 4. 上传文件的[mimeType]
 */
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *field;

@property (nonatomic, strong) NSString *imageName; // 可以为空，默认以时间戳命名
//@property (nonatomic, strong) NSString *mimeType; // @"image/jpeg"

@end
