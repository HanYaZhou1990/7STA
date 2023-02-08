//
//  BaseViewController.m
//  STA
//
//  Created by 韩亚周 on 2021/6/22.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self setNaviTransparent:YES];
    [self naviTransparent:NO customColor:Color(@"FFFFFF")];
        
    self.view.backgroundColor = Color(@"FFFFFF");
    [self initUI];
    [self setDefaultBackButton];
    
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
//    [self.navigationController.navigationBar setTintColor:Color(@"333333")];
//    self.navigationController.navigationBar.translucent = NO;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self initData:YES];
}

//- (void)setNaviTransparent:(BOOL)transparent{
//    if (transparent) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    }else{
//        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:nil];
//    }
//}

/*!设置导航透明 YES透明 customColor自定义颜色，默认FFFFFF*/
- (void)naviTransparent:(BOOL)transparent customColor:(nullable UIColor *)color{
    if (transparent) {
        //navigation标题文字颜色
        NSDictionary *dic = @{NSForegroundColorAttributeName : Color(@"333333"),
                              NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
        if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
            barApp.backgroundColor = [UIColor clearColor];
            barApp.titleTextAttributes = dic;
            barApp.backgroundEffect = nil;
            barApp.shadowColor = nil;
            self.navigationController.navigationBar.scrollEdgeAppearance = nil;
            self.navigationController.navigationBar.standardAppearance = barApp;
        }else{
            self.navigationController.navigationBar.titleTextAttributes = dic;
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        }
        //透明
        self.navigationController.navigationBar.translucent = YES;
        //navigation控件颜色
        self.navigationController.navigationBar.tintColor = Color(@"333333");
    } else {
        //navigation标题文字颜色
        NSDictionary *dic = @{NSForegroundColorAttributeName : Color(@"333333"),
                              NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
        if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
            //barApp.backgroundColor = color ? color : Color(@"FFFFFF");
            barApp.backgroundImage = [[UIImage imageWithColor:Color(@"FFFFFF")] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            barApp.shadowColor = [UIColor clearColor];
            barApp.titleTextAttributes = dic;
            self.navigationController.navigationBar.scrollEdgeAppearance = barApp;
            self.navigationController.navigationBar.standardAppearance = barApp;
        } else {
            //背景色
            self.navigationController.navigationBar.barTintColor = color ? color : Color(@"FFFFFF");
            self.navigationController.navigationBar.titleTextAttributes = dic;
            //[self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"nav"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        }
        //不透明
        self.navigationController.navigationBar.translucent = NO;
        //navigation控件颜色
        self.navigationController.navigationBar.tintColor = Color(@"333333");
    }
}

- (void)setDefaultBackButton {
    //主要是以下两个图片设置
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"navbtnleftarrow"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"navbtnleftarrow"];

    //方法2:通过父视图NaviController来设置
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@""
                                                                style:UIBarButtonItemStylePlain
                                                               target:nil
                                                               action:@selector(back)];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:Color(@"333333")}];
}

- (void)back{}

/** 修改当前UIViewController的状态栏颜色为白色 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*!可实现此方法配置UI*/
- (void)initUI {
    
}
/*!可实现此方法请求进入页面时需要调用的接口*/
- (void)initData:(BOOL)isRefresh {
    
}
//
//- (void)setDefaultBackButton {
//    //主要是以下两个图片设置
//    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"navbtnleftarrow"];
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"navbtnleftarrow"];
//
//    //方法2:通过父视图NaviController来设置
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@""
//                                                                style:UIBarButtonItemStylePlain
//                                                               target:nil
//                                                               action:@selector(back)];
//    self.navigationItem.backBarButtonItem = backItem;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:Color(@"#333333")}];
//}

@end
