//
//  UIView+LSCoreView.m
//
//

#import "UIView+LSCoreView.h"

@implementation UIView (LSCoreView)

- (CGFloat)bottom {
    return self.top + self.height;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)changeFrame:(void (^)(CGRect *))changer {
    CGRect frame = self.frame;
    changer(&frame);
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)right {
    return self.left + self.width;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setBottom:(CGFloat)bottom {
    self.top = bottom - self.height;
}

- (void)setCenterX:(CGFloat)x {
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}

- (void)setCenterY:(CGFloat)y {
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}

- (void)setHeight:(CGFloat)height {
    [self changeFrame:^(CGRect *frame) {
        frame->size.height = height;
    }];
}

- (void)setLeft:(CGFloat)left {
    [self changeFrame:^(CGRect *frame) {
        frame->origin.x = left;
    }];
}

- (void)setOrigin:(CGPoint)origin {
    [self changeFrame:^(CGRect *frame) {
        frame->origin = origin;
    }];
}

- (void)setRight:(CGFloat)right {
    self.left = right - self.width;
}

- (void)setSize:(CGSize)size {
    [self changeFrame:^(CGRect *frame) {
        frame->size = size;
    }];
}

- (void)setTop:(CGFloat)top {
    [self changeFrame:^(CGRect *frame) {
        frame->origin.y = top;
    }];
}

- (void)setWidth:(CGFloat)width {
    [self changeFrame:^(CGRect *frame) {
        frame->size.width = width;
    }];
}

@end
