//
//  UIImage+extension.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/3.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "UIImage+extension.h"

@implementation UIImage (extension)

+ (UIImage *)createImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)resizebleImageWithName:(NSString *)imageName {
    
    UIImage *imageNor = [UIImage imageNamed:imageName];
    CGFloat w = imageNor.size.width;
    CGFloat h = imageNor.size.height;
    imageNor = [imageNor resizableImageWithCapInsets:UIEdgeInsetsMake(w * 0.5,h * 0.5 , w * 0.5, h * 0.5) resizingMode:UIImageResizingModeStretch];
    return imageNor;
}

@end
