//
//  LiuqsEmotionPageView.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/3.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "LiuqsEmotionPageView.h"


@implementation LiuqsEmotionPageView

- (void)setPage:(NSUInteger)page {

    _page = page;
    self.backgroundColor = [UIColor whiteColor];
    [self addEmotionButtons];
}

- (void)addEmotionButtons {

    int row = 1;
    CGFloat space = (screenW - KrowCount * emotionW) / (KrowCount + 1);
    for (int i = 0; i < emojiCount; i ++) {
        
        row = i / KrowCount + 1;
        LiuqsButton *btn = [[LiuqsButton alloc]init];
        btn.frame = CGRectMake((1 + i - (KrowCount * (row - 1))) * space + (i - (KrowCount * (row - 1))) * emotionW, space * row + (row - 1) * emotionW, emotionW, emotionW);
        btn.btnType = (i == emojiCount - 1) ? 1 : 0;
        if (i == emojiCount - 1) {
            btn.emotionName = @"expression_delete";
            btn.Ex_size = CGSizeMake(emotionW + space, emotionW + space);
            CGFloat X = btn.Ex_x;
            CGFloat Y = btn.Ex_y;
            btn.Ex_x = X - space / 3;
            btn.Ex_y = Y - space / 3;
            [btn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            btn.emotionName = [NSString stringWithFormat:@"%lu",i + 1 + 20 * self.page];
            [btn addTarget:self action:@selector(emotionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:btn];
    }
}

//删除按钮事件
- (void)deleteBtnClick:(LiuqsButton *)deleteButton {

    if (self.deleteButtonClick) {
        self.deleteButtonClick(deleteButton);
    }    
}

//表情事件
- (void)emotionButtonClick:(LiuqsButton *)emotionButton {

    if (self.emotionButtonClick) {
        self.emotionButtonClick(emotionButton);
    }
}




@end
