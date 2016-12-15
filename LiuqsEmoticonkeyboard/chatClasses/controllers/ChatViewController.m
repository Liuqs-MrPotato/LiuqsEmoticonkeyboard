//
//  ChatViewController.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/14.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatMessageCell.h"
#import "ChatMessage.h"

@interface ChatViewController ()<LiuqsEmotionKeyBoardDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) LiuqsEmoticonKeyBoard *keyboard;

@property(nonatomic, strong) UITableView *chatList;

@property(nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation ChatViewController

#pragma mark ==== 懒加载 === 

- (UITableView *)chatList {

    if (!_chatList) {
        _chatList = [[UITableView alloc]init];
        _chatList.frame = CGRectMake(0, 64, screenW, screenH - topBarH - 64);
        _chatList.backgroundColor = ColorRGB(236, 237, 241);
        _chatList.tableFooterView = [[UIView alloc]init];
        _chatList.delegate = self;
        _chatList.dataSource = self;
        _chatList.separatorStyle = UITableViewCellSeparatorStyleNone;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(listTap)];
        [_chatList addGestureRecognizer:tap];
    }
    return _chatList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSomeThing];
    [self addSubviews];
    self.dataSource = [NSMutableArray array];
    
    for (int i = 0; i < 2; i ++) {
      
        ChatMessageFrame *cellFrame = [[ChatMessageFrame alloc]init];
        ChatMessage *message = [[ChatMessage alloc]init];
        message.userType = i % 2 ? userTypeMe : userTypeOther;
        NSString *Lmessage = @"在村里，Lz辈分比较大，在我还是小屁孩的时候就有大人喊我叔了，这不算糗[委屈]。 成年之后，鼓起勇气向村花二丫深情表白了(当然是没有血缘关系的)[害羞]，结果她一脸淡定的回绝了:“二叔！别闹……”[尴尬]";
        NSString *Mmessage = @"小学六年级书法课后不知是哪个用红纸写了张六畜兴旺贴教室门上，上课语文老师看看门走了过了一会才来过了几天去办公室交作业听见语文老师说：看见那几个字我本来是不想进去的，但是后来一想养猪的也得进去喂猪[奸笑]";
        message.messageContent = message.userType != userTypeMe ? Mmessage : Lmessage;
        cellFrame.message = message;
        [self.dataSource addObject:cellFrame];
    }
    [self.chatList reloadData];
    
}

- (void)addSubviews {

    self.keyboard = [LiuqsEmoticonKeyBoard showKeyBoardInView:self.view];
    self.keyboard.delegate = self;
    [self.view addSubview:self.chatList];
}

- (void)initSomeThing {
    
    self.view.backgroundColor = ColorRGB(250, 250, 250);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"路飞";
}

#pragma mark ==== 事件 ==== 

- (void)listTap {

    [self.keyboard hideKeyBoard];
}

#pragma mark ==== LiuqsEmotionKeyBoardDelegate ====

//发送按钮的事件
- (void)sendButtonEventsWithPlainString:(NSString *)PlainStr {

    //点击发送，发出一条消息
    ChatMessageFrame *cellFrame = [[ChatMessageFrame alloc]init];
    ChatMessage *message = [[ChatMessage alloc]init];
    message.messageContent = PlainStr;
    message.userType = userTypeOther;
    cellFrame.message = message;
    [self.dataSource addObject:cellFrame];
    [self.chatList reloadData];
    [UIView animateWithDuration:0.25 animations:^{
       
        [self ScrollTableViewToBottom];
    }];
    self.keyboard.textView.text = @"";
    [self.keyboard.topicBar resetSubsives];
}

- (void)keyBoardChanged {

    [UIView animateWithDuration:keyBoardTipTime animations:^{
     
        [self updateChatList];
    }];
}

//重设tabbleview的frame并根据是否在底部来执行滚动到底部的动画（不在底部就不执行，在底部才执行）
- (void)updateChatList {

    CGFloat offSetY = self.chatList.contentSize.height - self.chatList.Ex_height;
    //判断是否需要滚动到底部，会有一个误差值
    if (self.chatList.contentOffset.y > offSetY - 5 || self.chatList.contentOffset.y > offSetY + 5) {
        
        self.chatList.Ex_height = self.keyboard.topicBar.Ex_y - 64;
        [self ScrollTableViewToBottom];
    }else {
    
        self.chatList.Ex_height = self.keyboard.topicBar.Ex_y - 64;
    }
}

//滚动到底部
- (void)ScrollTableViewToBottom {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
    [self.chatList scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark ==== tabbleView 代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ChatMessageCell *cell = [ChatMessageCell cellWithTableView:tableView];
    cell.tag = indexPath.row;
    ChatMessageFrame *cellFrame = [self.dataSource objectAtIndex:indexPath.row];
    cell.MessageFrame = cellFrame;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    ChatMessageFrame *cellFrame = [self.dataSource objectAtIndex:indexPath.row];
    return cellFrame.cellHeight;
}


@end
