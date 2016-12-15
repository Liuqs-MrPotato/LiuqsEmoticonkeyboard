//
//  LiuqsEmotionButton.h
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/12.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiuqsButton : UIButton
/*
 * 当前按钮对应的表情名字
 */
@property(nonatomic, copy) NSString *emotionName;
/*
 * 按钮的类型
 * 0是表情 1是删除
 */
@property(nonatomic, assign) NSUInteger btnType;

@end
