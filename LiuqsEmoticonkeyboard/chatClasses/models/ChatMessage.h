//
//  ChatMessage.h
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/15.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    userTypeMe,
    userTypeOther,
} userType;

@interface ChatMessage : NSObject

@property(nonatomic, copy) NSString *userHeadImage;

@property(nonatomic, copy) NSString *userName;

@property(nonatomic, copy) NSString *messageContent;

@property(nonatomic, assign) userType userType;

@property(nonatomic, assign) NSInteger userId;

@property(nonatomic, strong) NSMutableAttributedString *attMessage;

@end
