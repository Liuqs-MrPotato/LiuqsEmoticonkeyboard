//
//  TabbarViewController.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2017/1/11.
//  Copyright © 2017年 刘全水. All rights reserved.
//

#import "TabbarViewController.h"
#import "MessageViewController.h"
#import "FriendsViewController.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewControllers];
}

- (void)addViewControllers {
    
    //根控制器
    MessageViewController *messageVC = [[MessageViewController alloc]init];
    FriendsViewController *friendsVC = [[FriendsViewController alloc]init];
    //导航控制器
    UINavigationController *messageNav = [[UINavigationController alloc]initWithRootViewController:messageVC];
    UINavigationController *friendsNav = [[UINavigationController alloc]initWithRootViewController:friendsVC];
    messageNav.navigationBar.barStyle = UIBarStyleBlack;
    friendsNav.navigationBar.barStyle = UIBarStyleBlack;
    messageVC.title = @"消息";
    friendsVC.title = @"通讯录";
    //添加到tabar控制器
    [self addChildVcWithNav:messageNav title:@"消息" images:@{@"nor":@"message_nor",@"sel":@"message_sel"}];
    [self addChildVcWithNav:friendsNav title:@"通讯录" images:@{@"nor":@"friends_nor",@"sel":@"friends_sel"}];
    [self configureTabBarItem];
}

- (void)configureTabBarItem {

    //设置tabar字体
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12], NSFontAttributeName,nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12], NSFontAttributeName,nil] forState:UIControlStateSelected];
}

- (void)addChildVcWithNav:(UINavigationController *)nav title:(NSString *)title images:(NSDictionary *)images {
    
    //普通图片
    UIImage *narImage = [UIImage imageNamed:[images objectForKey:@"nor"]];
    //选中图片
    UIImage *selImage = [UIImage imageNamed:[images objectForKey:@"sel"]];
    //设置tabar
    nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:narImage selectedImage:selImage];
    [self addChildViewController:nav];
}


@end
