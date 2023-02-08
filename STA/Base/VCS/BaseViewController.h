//
//  BaseViewController.h
//  STA
//
//  Created by 韩亚周 on 2021/6/22.
//

#import <UIKit/UIKit.h>
#import "YYHelper.h"

NS_ASSUME_NONNULL_BEGIN

/*!基础ViewContrller父类，尽量继承，可不继承*/
@interface BaseViewController : UIViewController

/*!设置transparent*/
//- (void)setNaviTransparent:(BOOL)transparent;
/*!可实现此方法配置UI*/
- (void)initUI;
/*!空方法，可实现此方法请求进入页面时需要调用的接口, 在ViewDidLoad中默认调用，默认可以直接实现，将进入页面需要调用的接口写入 ，直接调用可不用参数。需要下拉刷新YES，上提加载NO*/
- (void)initData:(BOOL)isRefresh;

/*!设置transparent 设置导航透明 YES透明 customColor自定义颜色，默认FFFFFF*/
- (void)naviTransparent:(BOOL)transparent customColor:(nullable UIColor *)color;

@end

NS_ASSUME_NONNULL_END
