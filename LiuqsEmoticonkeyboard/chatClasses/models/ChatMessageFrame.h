//
//  ChatMessageFrame.h
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/15.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessage.h"

@interface ChatMessageFrame : NSObject

@property(nonatomic, assign) CGRect headViewFrame;

@property(nonatomic, assign) CGRect nameLabelFrame;

@property(nonatomic, assign) CGRect messageLabelFrame;

@property(nonatomic, assign) CGRect airViewFrame;

@property(nonatomic, strong) ChatMessage *message;

@property(nonatomic, strong) NSMutableAttributedString *attMessage;

@property(nonatomic, assign) CGFloat cellHeight;

@end
