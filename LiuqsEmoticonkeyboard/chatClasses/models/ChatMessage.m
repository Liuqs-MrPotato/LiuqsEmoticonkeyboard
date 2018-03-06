//
//  ChatMessage.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/15.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage

- (void)setUserType:(userType)userType {

    _userType = userType;
    _userHeadImage = userType == userTypeMe ? @"鸣人" : @"路飞";
    _userName = userType == userTypeMe ? @"" : @"路飞";
}
- (void)setMessageContent:(NSString *)messageContent {
    _messageContent = messageContent;
    _attMessage = [LiuqsDecoder decodeWithPlainStr:messageContent font:[UIFont systemFontOfSize:17.0f]];
}

@end
