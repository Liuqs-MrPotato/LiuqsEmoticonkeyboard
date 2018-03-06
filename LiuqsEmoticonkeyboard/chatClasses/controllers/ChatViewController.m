//
//  ChatViewController.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/14.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatMessageCellOther.h"
#import "ChatMessageCellMe.h"
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
        _chatList.rowHeight = UITableViewAutomaticDimension;
        _chatList.estimatedRowHeight = 130;
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
    
    [self initData];
}


- (void)initData {
    ChatMessage *message = [[ChatMessage alloc]init];
    message.userType = userTypeOther;
    message.userId = 0;
    NSString *Lmessage = @"在村里，Lz辈分比较大，在我还是小屁孩的时候就有大人喊我叔了，这不算糗[委屈]。 成年之后，鼓起勇气向村花二丫深情表白了(当然是没有血缘关系的)[害羞]，结果她一脸淡定的回绝了:“二叔！别闹……”[尴尬]";
    message.messageContent = Lmessage;
    [self.dataSource addObject:message];
    NSMutableArray *messageArray = [LiuqsMessageDataBase queryData:nil];
    [messageArray enumerateObjectsUsingBlock:^(ChatMessage *message, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataSource addObject:message];
    }];
    [self.chatList reloadData];
    [self ScrollTableViewToBottom];
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
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController.menuVisible) {
        [menuController setMenuVisible:NO animated:YES];
    }
}

#pragma mark ==== LiuqsEmotionKeyBoardDelegate ====

//发送按钮的事件
- (void)sendButtonEventsWithPlainString:(NSString *)PlainStr {

    if (!PlainStr.length) {
        return;
    }
    //点击发送，发出一条消息
    ChatMessage *message = [[ChatMessage alloc]init];
    message.userType = userTypeMe;
    message.messageContent = PlainStr;
    message.userHeadImage = @"鸣人";
    message.userId = self.dataSource.count;
    [self.dataSource addObject:message];
    [self.chatList reloadData];
    [UIView animateWithDuration:0.25 animations:^{
       
        [self ScrollTableViewToBottom];
    }];
    self.keyboard.textView.text = @"";
    [self.keyboard.topBar resetSubsives];
    
    //保存到数据库
    NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@(userId,userName, userHeadImage, messageContent, userType) VALUES ('%zd','%@','%@', '%@', '%zd');" , tb_message, message.userId, message.userName, message.userHeadImage, message.messageContent, message.userType];
    
    [LiuqsMessageDataBase insertMessageWithSql:sql];
    
}

- (void)keyBoardChanged {

    [UIView animateWithDuration:keyBoardTipTime animations:^{
     
        [self updateChatList];
    }];
}


//重设tabbleview的frame并根据是否在底部来执行滚动到底部的动画（不在底部就不执行，在底部才执行）
- (void)updateChatList {

    CGFloat offSetY = self.chatList.contentSize.height - self.chatList.Ex_height;
    //判断是否需要滚动到底部，给一个误差值
    if (self.chatList.contentOffset.y > offSetY - 5 || self.chatList.contentOffset.y > offSetY + 5) {
        
        self.chatList.Ex_height = self.keyboard.topBar.Ex_y - 64;
        [self ScrollTableViewToBottom];
    }else {
    
        self.chatList.Ex_height = self.keyboard.topBar.Ex_y - 64;
    }
}

//这个方法是判断字符串长度的中文字符是2 英文字符是1（没啥用）
- (NSUInteger)textLength:(NSString *)text {
    
    NSUInteger Length = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        unichar Uchar = [text characterAtIndex: i];
        
        Length += isascii(Uchar) ? 1 : 2;
    }
    
    return Length;
}

//滚动到底部
- (void)ScrollTableViewToBottom {
    
    if (!self.dataSource.count) {return;}
    if (self.dataSource.count - 1 >= 1) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
        [self.chatList scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}


#pragma mark ==== tabbleView 代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ChatMessage *message = [self.dataSource objectAtIndex:indexPath.row];
    if (message.userType == userTypeMe) {
        ChatMessageCellMe *cell = [ChatMessageCellMe cellWithTableView:tableView];
        cell.message = message;
        __weak typeof (self) weakSelf = self;
        [cell setDeleteMessage:^(ChatMessage *message) {
            [weakSelf deleteCellWithMessage:message];
        }];
        return cell;
    }else {
        ChatMessageCellOther *cell = [ChatMessageCellOther cellWithTableView:tableView];
        cell.message = message;
        __weak typeof (self) weakSelf = self;
        [cell setDeleteMessage:^(ChatMessage *message) {
            [weakSelf deleteCellWithMessage:message];
        }];
        return cell;
    }
}

- (void)deleteCellWithMessage:(ChatMessage *)message {
    NSUInteger index = [self.dataSource indexOfObject:message];
    [self.dataSource removeObject:message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.chatList deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


@end
