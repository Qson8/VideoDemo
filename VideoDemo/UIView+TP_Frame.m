
#import "UIView+TP_Frame.h"

@implementation UIView (TP_Frame)

- (void)setX:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setW:(CGFloat)w {
    CGRect rect = self.frame;
    rect.size.width = w;
    self.frame = rect;
}

- (CGFloat)w {
    return self.frame.size.width;
}

- (void)setH:(CGFloat)h {
    CGRect rect = self.frame;
    rect.size.height = h;
    self.frame = rect;
}

- (CGFloat)h {
    return self.frame.size.height;
}

- (void)setCenter_x:(CGFloat)center_x {
    CGPoint center = self.center;
    center.x = center_x;
    self.center = center;
}

- (CGFloat)center_x {
    return self.center.x;
}

- (void)setCenter_y:(CGFloat)center_y {
    CGPoint center = self.center;
    center.y = center_y;
    self.center = center;
}

- (CGFloat)center_y {
    return self.center.y;
}


@end
