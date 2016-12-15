//
//  ChatMessageFrame.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/15.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "ChatMessageFrame.h"

@implementation ChatMessageFrame

- (void)setMessage:(ChatMessage *)message {

    _message = message;
    
    CGFloat headW  = 40;
    CGFloat headH  = 40;
    CGFloat margin = 10;
    CGFloat headX = message.userType ? screenW - headW - margin : margin;
    self.headViewFrame = CGRectMake(headX, margin, headW, headH);
    
    CGRect nameFrame = CGRectMake(CGRectGetMaxX(self.headViewFrame) + margin, CGRectGetMinY(self.headViewFrame), screenW - margin * 2 - headW, 20);
    
    self.nameLabelFrame = message.userType == userTypeMe ? nameFrame : CGRectZero;
    
    NSMutableAttributedString *attMessage = [LiuqsDecoder decodeWithPlainStr:message.messageContent font:[UIFont systemFontOfSize:17.0f]];
    
    self.message.attMessage = attMessage;
    
    CGFloat AllMargin = 31;
    
    CGSize maxsize = CGSizeMake(screenW - (margin * 4 + headW * 2) - AllMargin, MAXFLOAT);
    
    // 创建文本容器
    YYTextContainer *container = [YYTextContainer new];
    container.size = maxsize;
    container.maximumNumberOfRows = 0;
    // 生成排版结果
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:self.message.attMessage];
    
    CGFloat airX = message.userType ? screenW - margin * 2 - headW - layout.textBoundingSize.width - AllMargin : margin * 2 + headW;
    
    self.airViewFrame = CGRectMake(airX, 35, layout.textBoundingSize.width + 31, layout.textBoundingSize.height + 16);
    
    CGFloat contentX = message.userType ? screenW - margin * 2 - headW - layout.textBoundingSize.width - 18 : margin * 2 + headW + 20;
    
    self.messageLabelFrame = CGRectMake(contentX, 43, layout.textBoundingSize.width, layout.textBoundingSize.height);
    
    self.cellHeight = CGRectGetMaxY(self.messageLabelFrame) + margin;
    
}

@end
