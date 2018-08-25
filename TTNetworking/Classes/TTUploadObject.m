//
//  TTUploadObject.m
//  TTNetworking
//
//  Created by ClaudeLi on 2018/7/31.
//  Copyright © 2018年 ClaudeLi. All rights reserved.
//

#import "TTUploadObject.h"

@implementation TTUploadObject

+ (instancetype)objectWithData:(NSData *)data
                         field:(NSString *)field
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType{
    TTUploadObject *obj = [[TTUploadObject alloc] init];
    obj.data = data;
    obj.field = field;
    obj.fileName = fileName;
    obj.mimeType = mimeType;
    return obj;
}

+ (instancetype)objectWithFilePath:(NSString *)filePath
                             field:(NSString *)field
                          fileName:(NSString *)fileName
                          mimeType:(NSString *)mimeType{
    TTUploadObject *obj = [TTUploadObject objectWithData:[NSData dataWithContentsOfFile:filePath]
                                                   field:field
                                                fileName:fileName
                                                mimeType:mimeType];
    obj.filePath = filePath;
    return obj;
}

- (void)setFilePath:(NSString *)filePath{
    _filePath = filePath;
    if (!_data) {
        self.data = [NSData dataWithContentsOfFile:filePath];
    }
}


@end
