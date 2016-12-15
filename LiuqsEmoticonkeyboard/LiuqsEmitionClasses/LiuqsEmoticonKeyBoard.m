//
//  LiuqsEmoticonView.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/3.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "LiuqsEmoticonKeyBoard.h"
#import "LiuqsEmotionPageView.h"
#import "LiuqsTextAttachment.h"

#define bottomBarH 40
#define sendBtnW 60
#define pages 4

@interface LiuqsEmoticonKeyBoard ()<UIScrollViewDelegate,LiuqsTopBarViewDelegate>

@property(nonatomic, strong) UIScrollView *baseView;

@property(nonatomic, strong) NSDictionary *emojiDict;

@property(nonatomic, strong) UIButton *sendButton;

@property(nonatomic, strong) UIScrollView *bottomBar;

@property(nonatomic, strong) UIPageControl *pageControl;

//表情大小需要根据字体计算
@property(assign, nonatomic) CGFloat  emotionSize;
/*
 * 用来判断是否是仅取消文字键盘的第一响应,不处理控件的改变;
 * 只有在键盘切换时候赋值为yes，其他任何情况都是no;
 * 解决切换键盘闪动的问题
 */
@property(nonatomic, assign) BOOL onlyHideSysKboard;

@end

@implementation LiuqsEmoticonKeyBoard

#pragma mark ==== 懒加载 ====

- (LiuqsTopBarView *)topicBar {

    if (!_topicBar) {
        _topicBar = [[LiuqsTopBarView alloc]init];
        _topicBar.delegate = self;
        self.textView = _topicBar.textView;
    }
    return _topicBar;
}

- (UIPageControl *)pageControl {

    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.numberOfPages = pages;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}
//底部表情分类条
- (UIScrollView *)bottomBar {

    if (!_bottomBar) {
        _bottomBar = [[UIScrollView alloc]init];
        _bottomBar.pagingEnabled = NO;
        _bottomBar.bounces = YES;
        _bottomBar.delegate = self;
        _bottomBar.showsHorizontalScrollIndicator = NO;
        _bottomBar.backgroundColor = ColorRGB(236, 237, 241);
    }
    return _bottomBar;
}
//存放表情图片的数组
- (NSDictionary *)emojiDict {

    if (!_emojiDict) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LiuqsEmotions" ofType:@"plist"];
        self.emojiDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _emojiDict;
}

//发送按钮
- (UIButton *)sendButton {

    if (!_sendButton) {
        _sendButton = [[UIButton alloc]init];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage createImageWithColor:ColorRGB(0, 186, 255)] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendButttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
//根视图（最底部滚动视图）
- (UIScrollView *)baseView {

    if (!_baseView) {
        _baseView = [[UIScrollView alloc]init];
        _baseView.pagingEnabled = YES;
        _baseView.bounces = NO;
        _baseView.delegate = self;
        _baseView.showsHorizontalScrollIndicator = NO;
    }
    return _baseView;
}

#pragma mark ==== 重载系统方法 ==== 
//构造方法
- (instancetype)init {

    if (self = [super init]){[self method];}
    return self;
}

#pragma mark ==== 自定义方法 ====

+ (instancetype)showKeyBoardInView:(UIView *)view {

    if (!view) {return nil;}
    LiuqsEmoticonKeyBoard *keyboard = [[LiuqsEmoticonKeyBoard alloc]init];
    [view addSubview:keyboard];
    [view addSubview:keyboard.topicBar];
    return keyboard;
}
- (void)method {
    
    [self initSomeThing];
    [self configureSubViews];
    [self initSubViewFrames];
    [self creatPageViews];
    [self addNotifations];
}

- (void)hideKeyBoard {

    if (self.topicBar.textView.isFirstResponder) {
        [self.topicBar.textView resignFirstResponder];
    }
    [UIView animateWithDuration:keyBoardTipTime animations:^{
        self.topicBar.Ex_y = screenH - self.topicBar.Ex_height;
        self.Ex_y = screenH;
        self.topicBar.topBarEmotionBtn.selected = NO;
        self.topicBar.CurrentKeyBoardH = keyBoardH;
        [self UpdateSuperView];
    }];
    self.onlyHideSysKboard = NO;
}

//添加通知监听
- (void)addNotifations {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWillShow:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    NSValue *beginValue    = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue *endValue      = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect beginFrame      = beginValue.CGRectValue;
    CGRect endFrame        = endValue.CGRectValue;
    self.topicBar.CurrentKeyBoardH = endFrame.size.height;
    BOOL isNeedHandle = beginFrame.size.height > 0 && beginFrame.origin.y - endFrame.origin.y > 0;
    //处理键盘走多次
    if (isNeedHandle) {
        //处理键盘弹出
        [self handleKeyBoardShow:endFrame];
    }
}

- (void)keyBoardWillHide:(NSNotification *)noti {
    
    self.topicBar.CurrentKeyBoardH = keyBoardH;
    if (!self.onlyHideSysKboard) {
        [self hideKeyBoard];
    }
}

//更新父视图的UI（比如列表的高度）
- (void)UpdateSuperView {

    if ([self.delegate respondsToSelector:@selector(keyBoardChanged)]) {
        [self.delegate keyBoardChanged];
    }
}

//处理键盘弹出
- (void)handleKeyBoardShow:(CGRect)frame {
    
    self.topicBar.topBarEmotionBtn.selected = NO;
    [UIView animateWithDuration:keyBoardTipTime animations:^{
        
        self.topicBar.Ex_y = screenH - frame.size.height - self.topicBar.Ex_height;
        self.Ex_y = screenH - keyBoardH;
        [self UpdateSuperView];
    }];
}

//初始化参数
- (void)initSomeThing {
    
    if (!self.font) {self.font = [UIFont systemFontOfSize:17.0f];}
    _emotionSize = [self heightWithFont:self.font];
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
}
//配置子视图
- (void)configureSubViews {
    
    [self addSubview:self.baseView];
    [self addSubview:self.bottomBar];
    [self addSubview:self.sendButton];
    [self addSubview:self.pageControl];
}
- (void)initSubViewFrames {

    self.frame = CGRectMake(0, screenH, screenW, keyBoardH);
    self.baseView.frame = CGRectMake(0, 0, screenW, rows * emotionW +(rows + 1) * pageH);
    self.baseView.contentSize = CGSizeMake(screenW * pages + 1, rows * emotionW +(rows + 1) * pageH);
    self.sendButton.frame = CGRectMake(screenW - sendBtnW, CGRectGetHeight(self.frame) - bottomBarH, sendBtnW, bottomBarH);
    self.bottomBar.frame = CGRectMake(0, CGRectGetHeight(self.frame) - bottomBarH, screenW - sendBtnW, bottomBarH);
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.baseView.frame) - 5, screenW, 10);
}

//根据页数（通过拥有的表情的个数除以每页表情数计算出来）创建pageView
- (void)creatPageViews {

    for (int i = 0; i < pages; i ++) {
        LiuqsEmotionPageView *pageView = [[LiuqsEmotionPageView alloc]init];
        pageView.page = i;
        [self.baseView addSubview:pageView];
        pageView.frame = CGRectMake(i * screenW, 0, screenW, rows * emotionW +(rows + 1) * pageH);
        __weak typeof (self) weakSelf = self;
        [pageView setDeleteButtonClick:^(LiuqsButton *deleteButton) {
            [weakSelf deleteBtnClick:deleteButton];
        }];
        [pageView setEmotionButtonClick:^(LiuqsButton *emotionButton) {
            [weakSelf insertEmoji:emotionButton];
        }];
    }
}

#pragma mark ==== 事件 ====
//发送按钮事件
- (void)sendButttonClick:(UIButton *)button {

    NSString *plainStr = [self.textView.attributedText getPlainString];
    if ([self.delegate respondsToSelector:@selector(sendButtonEventsWithPlainString:)]) {
        [self.delegate sendButtonEventsWithPlainString:plainStr];
    }
}

//删除按钮事件
- (void)deleteBtnClick:(LiuqsButton *)btn {
    
    [self.textView deleteBackward];
}

//点击表情时，插入图片到输入框
- (void)insertEmoji:(LiuqsButton *)btn {
    //创建附件
    LiuqsTextAttachment *emojiTextAttachment = [LiuqsTextAttachment new];
    NSString *emojiTag = [self getKeyForValue:btn.emotionName fromDict:self.emojiDict];
    emojiTextAttachment.emojiTag = emojiTag;
    //取到表情对应的表情
    NSString *imageName = btn.emotionName;
    //给附件设置图片
    emojiTextAttachment.image = [UIImage imageNamed:imageName];
    // 给附件设置尺寸
    emojiTextAttachment.bounds = CGRectMake(0, -4, _emotionSize, _emotionSize);
    //textview插入富文本，用创建的附件初始化富文本
    [_textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment] atIndex:_textView.selectedRange.location];
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 1, _textView.selectedRange.length);
    //重设输入框字体
    [self resetTextStyle];
}

- (void)resetTextStyle {
    
    NSRange wholeRange = NSMakeRange(0, _textView.textStorage.length);
    [_textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_textView.textStorage addAttribute:NSFontAttributeName value:self.font range:wholeRange];
    [self.textView scrollRectToVisible:CGRectMake(0, 0, _textView.contentSize.width, _textView.contentSize.height) animated:NO];
    //重新设置输入框视图的frame
    [self.topicBar resetSubsives];
}

#pragma mark ==== topBar代理方法 ====
///代理方法，点击表情按钮触发方法
- (void)TopBarEmotionBtnDidClicked:(UIButton *)emotionBtn {

    if (emotionBtn.selected) {
        [self showSystemKeyBoard];
    }else {
        [self showEmotionKeyBorad];
    }
}

//展示表情键盘
- (void)showEmotionKeyBorad {
    
    if (self.textView.isFirstResponder) {
        self.onlyHideSysKboard = YES;
        [self.textView resignFirstResponder];
    }
    self.onlyHideSysKboard = NO;
    [UIView animateWithDuration:keyBoardTipTime animations:^{
       
        self.topicBar.Ex_y = screenH - self.topicBar.Ex_height - self.topicBar.CurrentKeyBoardH;
        self.Ex_y = screenH - self.Ex_height;
    }];
    self.topicBar.topBarEmotionBtn.selected = YES;
    [self UpdateSuperView];
}

//展示文字键盘
- (void)showSystemKeyBoard {

    self.onlyHideSysKboard = NO;
    if (!self.textView.isFirstResponder) {
        [self.textView becomeFirstResponder];
    }
    [UIView animateWithDuration:keyBoardTipTime animations:^{
        
        self.topicBar.Ex_y = screenH - self.topicBar.Ex_height - self.topicBar.CurrentKeyBoardH;
        self.Ex_y = screenH - self.Ex_height;
    }];
    self.topicBar.topBarEmotionBtn.selected = NO;
    [self UpdateSuperView];
}

- (void)needUpdateSuperView {

    [self UpdateSuperView];
}
//键盘发送事件
- (void)sendAction {

    [self sendButttonClick:nil];
}

#pragma mark ==== scrollView代理 ====
//改变pageControl
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
}

#pragma mark ==== 工具 ====
//根据字体计算表情的高度
- (CGFloat)heightWithFont:(UIFont *)font {
    
    if (!font){font = [UIFont systemFontOfSize:17];}
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize maxsize = CGSizeMake(100, MAXFLOAT);
    CGSize size = [@"/" boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height;
}
//通过value获取到对应的key
- (NSString *)getKeyForValue:(NSString *)value fromDict:(NSDictionary *)dict {

   __block NSString *resultKey;
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    
        if ([obj isEqualToString:value]) {
            resultKey = key;
        }
    }];
    return resultKey;
}


@end
