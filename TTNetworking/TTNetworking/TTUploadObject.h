//
//  TTUploadObject.h
//  TTNetworking
//
//  Created by ClaudeLi on 2018/7/31.
//  Copyright © 2018年 ClaudeLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTUploadObject : NSObject

/*
 参数解释
 1. 要上传的data/filePath
 2. 对应网站上[upload.php中]处理文件的字段
 3. 要保存在服务器上的[文件名]
 4. 上传文件的[mimeType]
 */
@property (nonatomic, strong) NSData    *data;
@property (nonatomic, strong) NSString  *filePath;

@property (nonatomic, strong) NSString  *field;
@property (nonatomic, strong) NSString  *fileName; 
@property (nonatomic, strong) NSString  *mimeType; // eg:"image/jpeg","video/mpeg4"

+ (instancetype)objectWithData:(nonnull NSData *)data
                         field:(NSString *)field
                      fileName:(nullable NSString *)fileName
                      mimeType:(NSString *)mimeType;

+ (instancetype)objectWithFilePath:(nonnull NSString *)filePath
                             field:(NSString *)field
                          fileName:(nullable NSString *)fileName
                          mimeType:(NSString *)mimeType;

@end
