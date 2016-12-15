//
//  NSAttributedString+LiuqsExtension.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/14.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "NSAttributedString+LiuqsExtension.h"
#import "LiuqsTextAttachment.h"

@implementation NSAttributedString (LiuqsExtension)

- (NSString *)getPlainString {
    
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(LiuqsTextAttachment *value, NSRange range, BOOL *stop) {
                      if (value) {
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:value.emojiTag];
                          base += value.emojiTag.length - 1;
                      }
                  }];
    return plainString;
}


@end
