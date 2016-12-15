//
//  ChatMessageCell.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/15.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "ChatMessageCell.h"

@interface ChatMessageCell ()

@property(nonatomic, strong) UIImageView *headImageView;

@property(nonatomic, strong) UILabel *nameLabel;

@property(nonatomic, strong) YYLabel *messageContentLabel;

@property(nonatomic, strong) UIButton *airView;

@end

@implementation ChatMessageCell

#pragma mark ==== 懒加载控件 ====

- (UIButton *)airView {

    if (!_airView) {
        _airView = [[UIButton alloc]init];
    }
    return _airView;
}

- (UIImageView *)headImageView  {

    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.layer.cornerRadius = 20;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (UILabel *)nameLabel {

    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.textColor = ColorRGB(136, 136, 136);
        _nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _nameLabel;
}

- (YYLabel *)messageContentLabel {

    if (!_messageContentLabel) {
        _messageContentLabel = [[YYLabel alloc]init];
        _messageContentLabel.numberOfLines = 0;
        _messageContentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _messageContentLabel.userInteractionEnabled = NO;
    }
    return _messageContentLabel;
}


+ (instancetype)cellWithTableView:(UITableView *)tableview {

    NSString *ID = @"ChatMessageCell";
    ChatMessageCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ChatMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.headImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.airView];
        [self addSubview:self.messageContentLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)setMessageFrame:(ChatMessageFrame *)MessageFrame {

    _MessageFrame = MessageFrame;
    self.headImageView.frame = MessageFrame.headViewFrame;
    self.nameLabel.frame = MessageFrame.nameLabelFrame;
    self.messageContentLabel.frame = MessageFrame.messageLabelFrame;
    self.airView.frame = MessageFrame.airViewFrame;
    
    self.nameLabel.text = MessageFrame.message.userName;
    self.headImageView.image = [UIImage imageNamed:MessageFrame.message.userHeadImage];
    
    NSString *norImageName  = MessageFrame.message.userType == userTypeOther ? @"chat_send_nor" : @"chat_receive_nor";
    NSString *seleImageName = MessageFrame.message.userType == userTypeOther ? @"chat_send_p" : @"chat_receive_p";
    
    UIImage *norImage  = [UIImage resizebleImageWithName:norImageName];
    UIImage *seleImage = [UIImage resizebleImageWithName:seleImageName];
    [self.airView setBackgroundImage:norImage forState:UIControlStateNormal];
    [self.airView setBackgroundImage:seleImage forState:UIControlStateHighlighted];
    
    self.messageContentLabel.attributedText = MessageFrame.message.attMessage;
}





@end
