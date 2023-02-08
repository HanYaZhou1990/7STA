//
//  UIImage+Colors.h
//  LiveHelper
//
//  Created by 韩亚周 on 2020/11/2.
//  Copyright © 2020 韩亚周. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!根据色值绘制渐变色图片*/
@interface UIImage (Colors)

/** 生成一张渐变色的图片
 @param colors 颜色数组
 @param rect 图片大小
 @return 返回渐变图片
 */
+ (UIImage *)drawGradientImageWithColors:(NSArray *)colors rect:(CGRect)rect;

/*!颜色生成图片*/
+(UIImage*)imageWithColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
