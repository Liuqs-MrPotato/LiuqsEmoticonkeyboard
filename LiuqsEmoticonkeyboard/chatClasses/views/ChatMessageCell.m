//
//  ChatMessageCell.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/15.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "ChatMessageCell.h"

static UITableView *_tableview;

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
    }
    return _messageContentLabel;
}


+ (instancetype)cellWithTableView:(UITableView *)tableview {

    NSString *ID = @"ChatMessageCell";
    _tableview = tableview;
    ChatMessageCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ChatMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSomeThing];
        [self addSubViews];
        [self addGestureRecognizers];
    }
    return self;
}

- (void)initSomeThing {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)addSubViews {

    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.airView];
    [self addSubview:self.messageContentLabel];
}

- (void)addGestureRecognizers {

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showMenuController:)];
    [self.airView addGestureRecognizer:longPress];
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

#pragma mark ==== 长按菜单事件 ====

- (void)showMenuController:(UIGestureRecognizer *)recognizer {

    if (recognizer.state == UIGestureRecognizerStateBegan) {
    
        [self becomeFirstResponder];
        
        UIMenuItem *itemCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText)];
        
        UIMenuItem *itemCallBack = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(callBack)];

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
    
    if (action == @selector(copyText) || action == @selector(callBack)){
        
        return YES;
    }
    return NO;
}

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}


- (void)copyText {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.MessageFrame.message.messageContent;
}

- (void)callBack {
    
    NSLog(@"撤回");
}


@end
