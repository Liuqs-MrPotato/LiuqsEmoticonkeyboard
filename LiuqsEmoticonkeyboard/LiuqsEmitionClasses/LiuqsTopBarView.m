//
//  LiuqsTopBarView.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/12.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "LiuqsTopBarView.h"

#define maxHeight 90

@interface LiuqsTopBarView () <UITextViewDelegate>


@property(nonatomic, strong) UIView *topLine;

@property(nonatomic, strong) UIView *bottomLine;

@end

@implementation LiuqsTopBarView

#pragma mark ==== 懒加载控件 ====
- (UITextView *)textView {

    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.cornerRadius = 5;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor = ColorRGB(215, 215, 225).CGColor;
        _textView.scrollEnabled = YES;
        _textView.frame = CGRectMake(10, 5, TextViewW, TextViewH);
        self.textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:17.0f];
        [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length, 1)];
    }
    return _textView;
}

- (UIView *)bottomLine {

    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = ColorRGB(215, 215, 225);
    }
    return _bottomLine;
}

- (UIView *)topLine {

    if (!_topLine) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = ColorRGB(215, 215, 225);
    }
    return _topLine;
}

- (UIButton *)topBarEmotionBtn {

    if (!_topBarEmotionBtn) {
        _topBarEmotionBtn = [[UIButton alloc]init];
        [_topBarEmotionBtn setImage:[UIImage imageNamed:@"group_topic_expression"] forState:UIControlStateNormal];
        [_topBarEmotionBtn setImage:[UIImage imageNamed:@"group_topic_keyboard"] forState:UIControlStateSelected];
        [_topBarEmotionBtn addTarget:self action:@selector(emotionBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBarEmotionBtn;
}

//构造方法
- (instancetype)init {
    
    self = [super init];
    if (self) {[self userMethod];}
    return self;
}

//自定义方法
- (void)userMethod {

    [self initSomething];
    [self addSubviews];
    [self layoutViews];
    
}

//初始化数据设置
- (void)initSomething {

    self.userInteractionEnabled = YES;
    self.backgroundColor = ColorRGB(236, 237, 241);
    self.CurrentKeyBoardH = keyBoardH;
}
//添加子视图
- (void)addSubviews {
    
    [self addSubview:self.textView];
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
    [self addSubview:self.topBarEmotionBtn];
}
//约束位置
- (void)layoutViews {
    
    self.frame = CGRectMake(0, screenH - topBarH, screenW, CGRectGetMaxY(self.textView.frame) + 5);
    self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, screenW, 0.5);
    self.topLine.frame = CGRectMake(0, 0, screenW, 0.5);
    self.topBarEmotionBtn.frame = CGRectMake(CGRectGetMaxX(_textView.frame) + 5, CGRectGetHeight(self.frame) - 5 - emotionBtnH, emotionBtnW, emotionBtnH);
}

//更新子视图
- (void)updateSubviews {

    CGFloat differenceH = self.textView.Ex_height - TextViewH;
    self.frame = CGRectMake(0, screenH - self.CurrentKeyBoardH - topBarH - differenceH, screenW, CGRectGetMaxY(self.textView.frame) + 5);
    self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, screenW, 0.5);
    self.topLine.frame = CGRectMake(0, 0, screenW, 0.5);
    self.topBarEmotionBtn.frame = CGRectMake(CGRectGetMaxX(_textView.frame) + 5, CGRectGetHeight(self.frame) - 5 - emotionBtnH, emotionBtnW, emotionBtnH);
    if ([self.delegate respondsToSelector:@selector(needUpdateSuperView)]) {
        [self.delegate needUpdateSuperView];
    }
}

#pragma mark === 事件 ====
//键盘切换按钮事件
- (void)emotionBtnDidClicked:(UIButton *)emotionBtn {
    
    if ([self.delegate respondsToSelector:@selector(TopBarEmotionBtnDidClicked:)]) {
        [self.delegate TopBarEmotionBtnDidClicked:emotionBtn];
    }
}

//共有方法，用于主动触发键盘改变的方法
- (void)resetSubsives {

    [self textViewDidChange:self.textView];
}

#pragma mark ==== textView代理方法 ====

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(sendAction)]) {
            [self.delegate sendAction];
        }
        return NO;
    }
    return YES;
}

//监听键盘改变，重设控件frame
- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat width   = CGRectGetWidth(textView.frame);
    CGSize newSize  = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    CGRect newFrame = textView.frame;
    CGRect maxFrame = textView.frame;
    maxFrame.size   = CGSizeMake(width, maxHeight);
    newFrame.size   = CGSizeMake(width, newSize.height);
    [UIView animateWithDuration:0.25 animations:^{
        if (newSize.height <= maxHeight) {
            
            textView.frame  = newFrame;
            textView.scrollEnabled = NO;
        }else {
            
            textView.frame = maxFrame;
            textView.scrollEnabled = YES;
        }
        [self updateSubviews];
    }];
}

@end
