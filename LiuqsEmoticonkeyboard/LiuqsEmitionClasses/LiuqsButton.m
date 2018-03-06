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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:emotionName ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {[self setImage:image forState:UIControlStateNormal];}
            self.userInteractionEnabled = image == nil ? NO : YES;
        });
    });
}


@end
