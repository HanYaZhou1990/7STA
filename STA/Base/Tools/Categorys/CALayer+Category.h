//
//  CALayer+Category.h
//  LiveHelper
//
//  Created by 韩亚周 on 2020/10/16.
//  Copyright © 2020 韩亚周. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Category)

- (void)addCorners:(CGFloat)radius roundingCorners:(UIRectCorner)corner;

@end

NS_ASSUME_NONNULL_END
