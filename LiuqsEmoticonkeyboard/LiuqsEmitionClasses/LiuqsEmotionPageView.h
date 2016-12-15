//
//  LiuqsEmotionPageView.h
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/3.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiuqsButton.h"

@interface LiuqsEmotionPageView : UIView
/*
 * 当前page的页数
 */
@property(nonatomic, assign) NSUInteger page;
/*
 * 表情按钮的回调事件
 * 参数button是当前点击按钮的对象
 */
@property(nonatomic, copy)void (^emotionButtonClick)(LiuqsButton *button);
/*
 * 键盘上删除按钮的回调事件
 * 参数button是当前点击的删除按钮
 */
@property(nonatomic, copy)void (^deleteButtonClick)(LiuqsButton *button);


@end
