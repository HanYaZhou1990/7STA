//
//  UIViewController+NavigationBarHidden.h
//  STA
//
//  Created by 韩亚周 on 2021/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!隐藏导航栏，解决部分页面无导航栏，切换导航不协调问题*/
@interface UIViewController (NavigationBarHidden)

/*!是否隐藏导航栏。默认NO。*/
@property (nonatomic , assign) BOOL shouldNavigationBarHidden;

@end

NS_ASSUME_NONNULL_END
