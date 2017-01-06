//
//  LiuqsFileManager.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2017/1/6.
//  Copyright © 2017年 刘全水. All rights reserved.
//

#import "LiuqsFileManager.h"

@implementation LiuqsFileManager

+ (NSString *)getDBPath {

    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LiuqsDataBase.sqlite"];
    return filePath;
}

@end
