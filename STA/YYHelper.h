//
//  YYHelper.h
//  STA
//
//  Created by 韩亚周 on 2021/6/22.
//

#ifndef YYHelper_h
#define YYHelper_h

#import "UIViewController+NavigationBarHidden.h"
#import "BaseViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>
#import "MBProgressHUD+YY.h"
#import "MJRefresh.h"
#import "UIImage+Colors.h"

#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#define ScreenPrecent  Main_Screen_Width / 320.0

//布局用弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define BASE_URL @"https://www.7techsg.com/"
//项目主要颜色
#define Color(colorName) [UIColor colorNamed:colorName]
/*!数据持久化*/
#define YYD(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#endif /* YYHelper_h */
