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
    
    _userHeadImage = userType == userTypeMe ? @"路飞" : @"鸣人";
    
    _userName = userType == userTypeMe ? @"路飞" : @"";
}

@end
