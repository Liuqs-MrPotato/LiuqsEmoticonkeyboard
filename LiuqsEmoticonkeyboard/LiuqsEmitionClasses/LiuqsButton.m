//
//  LiuqsEmotionButton.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/12.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "LiuqsButton.h"

@implementation LiuqsButton

- (void)setEmotionName:(NSString *)emotionName {

    _emotionName = emotionName;
    UIImage *image = [UIImage imageNamed:emotionName];
    if (image) {[self setImage:image forState:UIControlStateNormal];}
    self.userInteractionEnabled = image == nil ? NO : YES;
}


@end
