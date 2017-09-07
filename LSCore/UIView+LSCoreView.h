//
//  UIView+LSCoreView.h
//
//

#import <UIKit/UIKit.h>

@interface UIView (LSCoreView)

@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat top;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic) CGFloat height;
@property(nonatomic) CGFloat width;

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;

- (void)changeFrame:(void(^)(CGRect *frame))changer;

@end
