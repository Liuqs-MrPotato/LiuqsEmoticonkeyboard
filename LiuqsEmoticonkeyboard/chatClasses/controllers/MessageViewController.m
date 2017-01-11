//
//  ViewController.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/11/15.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "MessageViewController.h"
#import "ChatViewController.h"

@interface MessageViewController ()


@end

@implementation MessageViewController

- (void)viewDidLoad {

    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:self.view.bounds];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"单击开始聊天";
    [self.view addSubview:label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    ChatViewController *chatVC = [[ChatViewController alloc]init];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}


@end
