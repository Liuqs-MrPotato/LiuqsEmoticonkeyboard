//
//  ChatMessageCellMe.h
//  LiuqsEmoticonkeyboard
//
//  Created by liuqs on 2018/3/6.
//  Copyright © 2018年 刘全水. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"

@interface ChatMessageCellMe : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@property(nonatomic, strong)ChatMessage *message;

@property(nonatomic, copy)void(^deleteMessage)(ChatMessage *message);

@end
