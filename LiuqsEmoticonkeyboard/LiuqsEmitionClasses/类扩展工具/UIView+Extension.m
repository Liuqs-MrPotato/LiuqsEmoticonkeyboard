//
//  UIView+Extension.m


#import "UIView+Extension.h"

@implementation UIView (Extension)


- (void)setEx_x:(CGFloat)Ex_x{
    CGRect frame = self.frame;
    frame.origin.x = Ex_x;
    self.frame = frame;
}

- (void)setEx_y:(CGFloat)Ex_y{
    CGRect frame = self.frame;
    frame.origin.y = Ex_y;
    self.frame = frame;
}

- (CGFloat)Ex_x{
    return self.frame.origin.x;
}

- (CGFloat)Ex_y{
    return self.frame.origin.y;
}

- (void)setEx_centerX:(CGFloat)Ex_centerX{
    CGPoint center = self.center;
    center.x = Ex_centerX;
    self.center = center;
}

- (CGFloat)Ex_centerX{
    return self.center.x;
}

- (void)setEx_centerY:(CGFloat)Ex_centerY{
    CGPoint center = self.center;
    center.y = Ex_centerY;
    self.center = center;
}

- (CGFloat)Ex_centerY{
    return self.center.y;
}

- (void)setEx_width:(CGFloat)Ex_width{
    CGRect frame = self.frame;
    frame.size.width = Ex_width;
    self.frame = frame;
}

- (void)setEx_height:(CGFloat)Ex_height{
    CGRect frame = self.frame;
    frame.size.height = Ex_height;
    self.frame = frame;
}

- (CGFloat)Ex_height{
    return self.frame.size.height;
}

- (CGFloat)Ex_width{
    return self.frame.size.width;
}

- (void)setEx_size:(CGSize)Ex_size{
    CGRect frame = self.frame;
    frame.size = Ex_size;
    self.frame = frame;
}

- (CGSize)Ex_size{
    return self.frame.size;
}

- (void)setEx_origin:(CGPoint)Ex_origin{
    CGRect frame = self.frame;
    frame.origin = Ex_origin;
    self.frame = frame;
}

- (CGPoint)Ex_origin{
    return self.frame.origin;
}

- (CGFloat)EX_bottom {

    return self.frame.origin.x + self.frame.size.height;
}

- (void)setEX_bottom:(CGFloat)EX_bottom {

    self.EX_bottom = EX_bottom;
}

- (void)setEX_right:(CGFloat)EX_right {

    self.EX_right = EX_right;
}

- (CGFloat)EX_right {

    return self.frame.origin.y + self.frame.size.width;
}


@end
