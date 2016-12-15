//
//  ChatMessageCell.h
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/15.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageFrame.h"

@interface ChatMessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@property(nonatomic, strong) ChatMessageFrame *MessageFrame;

@end
