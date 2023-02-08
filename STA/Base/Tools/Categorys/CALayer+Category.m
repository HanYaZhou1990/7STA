//
//  CALayer+Category.m
//  LiveHelper
//
//  Created by 韩亚周 on 2020/10/16.
//  Copyright © 2020 韩亚周. All rights reserved.
//

#import "CALayer+Category.h"

@implementation CALayer (Category)

/*!View设置切角，可设置任意角切除*/
- (void)addCorners:(CGFloat)radius roundingCorners:(UIRectCorner)corner {
    CGRect rect = CGRectMake(0, 0, MAX(radius, self.bounds.size.width), MAX(radius, self.bounds.size.height));
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    if (! (radius > self.bounds.size.width || radius > self.bounds.size.height)) {
        CAShapeLayer *maskLayer;
        if (corner & UIRectCornerBottomLeft) {
            rect.origin = CGPointMake(0, self.bounds.size.height - rect.size.height);
            maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = rect;
            maskLayer.path = path.CGPath;
        }
        
        if (corner & UIRectCornerBottomRight) {
            rect.origin = CGPointMake(self.bounds.size.width - rect.size.width, self.bounds.size.height - rect.size.height);
            if (!maskLayer) {
                maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = rect;
                maskLayer.path = path.CGPath;
            } else {
                CAShapeLayer *mLayer = [[CAShapeLayer alloc] init];
                mLayer.frame = rect;
                mLayer.path = path.CGPath;
                [maskLayer addSublayer:mLayer];
            }
        }
        if (corner & UIRectCornerTopLeft) {
            rect.origin = CGPointZero;
            if (!maskLayer) {
                maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = rect;
                maskLayer.path = path.CGPath;
            } else {
                CAShapeLayer *mLayer = [[CAShapeLayer alloc] init];
                mLayer.frame = rect;
                mLayer.path = path.CGPath;
                [maskLayer addSublayer:mLayer];
            }
        }
        if (corner & UIRectCornerTopRight) {
            rect.origin = CGPointMake(self.bounds.size.width, 0.0f);
            if (!maskLayer) {
                maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = rect;
                maskLayer.path = path.CGPath;
            } else {
                CAShapeLayer *mLayer = [[CAShapeLayer alloc] init];
                mLayer.frame = rect;
                mLayer.path = path.CGPath;
                [maskLayer addSublayer:mLayer];
            }
        }
        self.mask = maskLayer;
    } else {
        //DLog(@"切太大了");
    }
}

@end
