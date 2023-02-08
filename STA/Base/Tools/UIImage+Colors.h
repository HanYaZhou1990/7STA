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

/*!渐变色图片*/
+ (UIImage *)gradientImg:(CGFloat)wth ht:(CGFloat)ht colors:(NSArray <UIColor *> *)colors;
/**
 生成一张渐变色的图片 从左下到右上
 @param colors 颜色数组
 @param rect 图片大小
 @return 返回渐变图片
 */
+ (UIImage *)drawGradientImageWithCls:(NSArray *)colors rect:(CGRect)rect;
/*!生成二维码*/
+ (UIImage *)creatQRCode:(NSString *)string size:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
