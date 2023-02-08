//
//  VQPNotchScreenUtil.h
//  VoQiPei
//
//  Created by 韩亚周 on 2021/4/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!刘海屏工具*/
@interface VQPNotchScreenUtil : NSObject

/*!判断是否是刘海屏*/
+(BOOL)isIPhoneNotchScreen;

/*!获取刘海屏高度*/
+(CGFloat)getIPhoneNotchScreenHeight;

@end

NS_ASSUME_NONNULL_END
