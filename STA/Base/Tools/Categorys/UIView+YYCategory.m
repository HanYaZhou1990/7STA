//
//  UIView+YYCategory.m
//  JCExchange
//
//  Created by 韩亚周 on 2019/12/13.
//  Copyright © 2019 韩亚周. All rights reserved.
//

#import "UIView+YYCategory.h"
#import "CALayer+Category.h"

@implementation UIView (YYCategory)

///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGFloat)left {
 return self.frame.origin.x;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (void)setLeft:(CGFloat)x {
 CGRect frame = self.frame;
 frame.origin.x = x;
 self.frame = frame;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGFloat)top {
 return self.frame.origin.y;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (void)setTop:(CGFloat)y {
 CGRect frame = self.frame;
 frame.origin.y = y;
 self.frame = frame;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGFloat)right {
 return self.frame.origin.x + self.frame.size.width;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (void)setRight:(CGFloat)right {
 CGRect frame = self.frame;
 frame.origin.x = right - frame.size.width;
 self.frame = frame;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGFloat)bottom {
 return self.frame.origin.y + self.frame.size.height;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (void)setBottom:(CGFloat)bottom {
 CGRect frame = self.frame;
 frame.origin.y = bottom - frame.size.height;
 self.frame = frame;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGFloat)centerX {
 return self.center.x;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (void)setCenterX:(CGFloat)centerX {
 self.center = CGPointMake(centerX, self.center.y);
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGFloat)centerY {
 return self.center.y;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (void)setCenterY:(CGFloat)centerY {
 self.center = CGPointMake(self.center.x, centerY);
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGFloat)width {
 return self.frame.size.width;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (void)setWidth:(CGFloat)width {
 CGRect frame = self.frame;
 frame.size.width = width;
 self.frame = frame;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGFloat)height {
 return self.frame.size.height;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (void)setHeight:(CGFloat)height {
 CGRect frame = self.frame;
 frame.size.height = height;
 self.frame = frame;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGFloat)ttScreenX {
 CGFloat x = 0;
 for (UIView* view = self; view; view = view.superview) {
 x += view.left;
 }
 return x;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGFloat)ttScreenY {
 CGFloat y = 0;
 for (UIView* view = self; view; view = view.superview) {
 y += view.top;
 }
 return y;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGFloat)screenViewX {
 CGFloat x = 0;
 for (UIView* view = self; view; view = view.superview) {
 x += view.left;
 
 if ([view isKindOfClass:[UIScrollView class]]) {
 UIScrollView* scrollView = (UIScrollView*)view;
 x -= scrollView.contentOffset.x;
 }
 }
 
 return x;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGFloat)screenViewY {
 CGFloat y = 0;
 for (UIView* view = self; view; view = view.superview) {
 y += view.top;
 
 if ([view isKindOfClass:[UIScrollView class]]) {
 UIScrollView* scrollView = (UIScrollView*)view;
 y -= scrollView.contentOffset.y;
 }
 }
 return y;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGRect)screenFrame {
 return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
 }
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGPoint)origin {
 return self.frame.origin;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (void)setOrigin:(CGPoint)origin {
 CGRect frame = self.frame;
 frame.origin = origin;
 self.frame = frame;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (CGSize)size {
 return self.frame.size;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (void)setSize:(CGSize)size {
 CGRect frame = self.frame;
 frame.size = size;
 self.frame = frame;
 }
 
 -(NSArray*)allSubviews {
 NSMutableArray *arr = [NSMutableArray array];
 [arr addObject:self];
 for (UIView * subview in self.subviews) {
 [arr addObjectsFromArray:(NSArray*)[subview allSubviews]];
 }
 return arr;
 }
 
 
 - (void)setCornerRadius:(CGFloat)cornerRadius {
 self.layer.cornerRadius = cornerRadius;
 self.layer.masksToBounds = cornerRadius > 0;
 }
 
 - (CGFloat)cornerRadius {
 return self.layer.cornerRadius;
 }
 
 - (void)setBorderColor:(UIColor *)borderColor {
 self.layer.borderColor = borderColor.CGColor;
 }
 
 - (UIColor *)borderColor {
 return self.borderColor;
 }
 
 - (void)setBorderWidth:(CGFloat)borderWidth {
 self.layer.borderWidth = borderWidth;
 }
 
 - (CGFloat)borderWidth {
 return self.layer.borderWidth;
 }

- (void)addCorners:(CGFloat)radius roundingCorners:(UIRectCorner)corner {
    WS(ws);
    if (self.translatesAutoresizingMaskIntoConstraints) {
        [self.layer addCorners:radius roundingCorners:corner];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws.layer addCorners:radius roundingCorners:corner];
        });
    }
}

@end
