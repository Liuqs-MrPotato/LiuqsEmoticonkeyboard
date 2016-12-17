//
//  LiuqsTopBarView.h
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/12.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiuqsTopBarViewDelegate <NSObject>
/*
 * 代理方法，点击表情按钮触发方法
 */
- (void)TopBarEmotionBtnDidClicked:(UIButton *)emotionBtn;
/*
 * 代理方法 ，点击数字键盘发送的事件
 */
- (void)sendAction;
/*
 * 键盘改变刷新父视图
 */
- (void)needUpdateSuperView;

@end

@interface LiuqsTopBarView : UIView
/*
 * topbar代理
 */
@property(assign,nonatomic)id <LiuqsTopBarViewDelegate> delegate;
/*
 * topbar上面的输入框
 */
@property(strong,nonatomic)UITextView *textView;
/*
 * 表情按钮
 */
@property(nonatomic, strong) UIButton *topBarEmotionBtn;
/*
 * 当前键盘的高度， 区分是文字键盘还是表情键盘
 */
@property(nonatomic, assign) CGFloat CurrentKeyBoardH;
/*
 * 用于主动触发输入框改变的方法
 */
- (void)resetSubsives;


@end
