//
//  ChatMessageCellMe.m
//  LiuqsEmoticonkeyboard
//
//  Created by liuqs on 2018/3/6.
//  Copyright © 2018年 刘全水. All rights reserved.
//

#import "ChatMessageCellMe.h"

static UITableView *_tableview;

@interface ChatMessageCellMe ()

@property(nonatomic, strong) UIImageView *headImageView;

@property(nonatomic, strong) UILabel *nameLabel;

@property(nonatomic, strong) YYLabel *messageContentLabel;

@property(nonatomic, strong) UIButton *airView;

@end

@implementation ChatMessageCellMe

#pragma mark ==== 懒加载控件 ====

- (UIButton *)airView {
    
    if (!_airView) {
        _airView = [[UIButton alloc]init];
        //shadowColor阴影颜色
        _airView.layer.shadowColor = [UIColor blackColor].CGColor;
        //shadowOffset阴影偏移,+x向右偏移，+y向下偏移，默认(0, -3),跟shadowRadius配合使用
        _airView.layer.shadowOffset = CGSizeMake(0,0);
        //阴影透明度，默认0
        _airView.layer.shadowOpacity = 0.1;
        //阴影半径，默认3
        _airView.layer.shadowRadius = 4;
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
        _messageContentLabel.preferredMaxLayoutWidth = screenW - 130;
    }
    return _messageContentLabel;
}


+ (instancetype)cellWithTableView:(UITableView *)tableview {
    
    NSString *ID = @"ChatMessageCellMe";
    _tableview = tableview;
    ChatMessageCellMe *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ChatMessageCellMe alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSomeThing];
        [self addSubViews];
        [self addGestureRecognizers];
        [self LayoutSubviews];
    }
    return self;
}

- (void)initSomeThing {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)addSubViews {
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.airView];
    [self.contentView addSubview:self.messageContentLabel];
}

- (void)LayoutSubviews {
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.height.equalTo(@40);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.headImageView.mas_left).offset(-5);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.bottom.equalTo(self.contentView.mas_top).offset(30);
    }];
    [self.messageContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headImageView.mas_left).offset(-15);
        make.width.lessThanOrEqualTo(@(screenW - 130));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    [self.airView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messageContentLabel.mas_right).offset(18);
        make.left.equalTo(self.messageContentLabel.mas_left).offset(-9);
        make.top.equalTo(self.messageContentLabel.mas_top).offset(-5);
        make.bottom.equalTo(self.messageContentLabel.mas_bottom).offset(5);
    }];
    
}

- (void)addGestureRecognizers {
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showMenuController:)];
    [self.airView addGestureRecognizer:longPress];
}

- (void)setMessage:(ChatMessage *)message {
    _message = message;
    self.headImageView.image = [UIImage imageNamed:message.userHeadImage];
    self.nameLabel.text = message.userName;
    UIImage *norImage  = [UIImage resizebleImageWithName:@"chat_send_nor"];
    [self.airView setBackgroundImage:norImage forState:UIControlStateNormal];
    self.messageContentLabel.attributedText = message.attMessage;
}

#pragma mark ==== 长按菜单事件 ====

- (void)showMenuController:(UIGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [self becomeFirstResponder];
        
        UIMenuItem *itemCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText)];
        
        UIMenuItem *itemCallBack = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(delete)];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        
        [menuController setMenuItems:@[itemCopy,itemCallBack]];
        
        CGRect rect = [self.airView convertRect:self.airView.bounds toView:_tableview.superview];
        
        CGFloat menuY = 0;
        
        if (rect.origin.y < 64) {
            
            menuY = CGRectGetMaxY(self.airView.frame) - 6;
            
            menuController.arrowDirection = UIMenuControllerArrowUp;
            
        }else {
            
            menuY = self.airView.Ex_y + 6;
            
            menuController.arrowDirection = UIMenuControllerArrowDown;
        }
        
        CGRect menuLocation = CGRectMake(self.airView.center.x, menuY, 0, 0);
        
        [menuController setTargetRect:menuLocation inView:self];
        
        [menuController setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action == @selector(copyText) || action == @selector(delete)){
        
        return YES;
    }
    return NO;
}

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}


- (void)copyText {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.message.messageContent;
}

- (void)delete {
    
    if (self.deleteMessage) {
        self.deleteMessage(self.message);
    }
    NSString *deletestr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE userId = '%zd'",tb_message,self.message.userId];
    [LiuqsMessageDataBase deleteData:deletestr];
}


@end

