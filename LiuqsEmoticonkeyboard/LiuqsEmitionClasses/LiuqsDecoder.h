//
//  LiuqsDecoder.h
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/15.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import <Foundation/Foundation.h>

/***********************这是一个转码工具类***************************/

@interface LiuqsDecoder : NSObject

+ (NSMutableAttributedString *)decodeWithPlainStr:(NSString *)plainStr font:(UIFont *)font;


@end
