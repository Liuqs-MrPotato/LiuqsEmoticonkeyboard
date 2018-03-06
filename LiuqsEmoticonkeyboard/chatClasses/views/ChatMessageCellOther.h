//
//  ChatMessageCell.h
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/15.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"

@interface ChatMessageCellOther : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@property(nonatomic, strong)ChatMessage *message;

@property(nonatomic, copy)void(^deleteMessage)(ChatMessage *message);

@end
