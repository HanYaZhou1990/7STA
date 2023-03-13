//
//  MBProgressHUD+YY.m
//  HNRuMi
//
//  Created by 韩亚周 on 16/1/25.
//  Copyright © 2016年 HYZ. All rights reserved.
//

#import "MBProgressHUD+YY.h"
#import "SceneDelegate.h"

@implementation MBProgressHUD (YY)

/**
 *  显示信息
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil) view = [self keyWindow];
        // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:14.0f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorNamed:@"00000080"];
    hud.label.textColor = [UIColor colorNamed:@"FFFFFF"];
    hud.contentColor = [UIColor colorNamed:@"FFFFFF"];
        // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
        // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
        // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
        // 0.7秒之后再消失
    [hud hideAnimated:YES afterDelay:0.7];
}

/**
 *  显示成功信息
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success {
    [self showSuccess:success toView:nil];
}

/**
 *  显示成功信息
 *  @param success 信息内容
 *  @param view    显示信息的视图
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self show:success icon:@"hudsuccess.png" view:view];
}

/**
 *  显示错误信息
 *
 */
+ (void)showError:(NSString *)error {
    [self showError:error toView:nil];
}

/**
 *  显示错误信息
 *  @param error 错误信息内容
 *  @param view  需要显示信息的视图
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"huderror.png" view:view];
}

/**
 *  显示错误信息
 *  @param message 信息内容
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message {
    return [self showMessage:message toView:nil];
}

/**
 *  显示一些信息
 *
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [self keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.font = [UIFont systemFontOfSize:14.0f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorNamed:@"00000080"];
    hud.contentColor = [UIColor colorNamed:@"FFFFFF"];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    //hud.dimBackground = YES;
    return hud;
}

/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

/**
 *  手动关闭MBProgressHUD
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) view = [self keyWindow];

    [self hideHUDForView:view animated:YES];
}

+ (UIWindow *)keyWindow {
    UIWindow *window;
    if (@available(iOS 15, *)) {
        __block UIScene * _Nonnull tmpSc;
        [[[UIApplication sharedApplication] connectedScenes] enumerateObjectsUsingBlock:^(UIScene * _Nonnull obj, BOOL * _Nonnull stop) {
            if (obj.activationState == UISceneActivationStateForegroundActive) {
                tmpSc = obj;
                *stop = YES;
            }
        }];
        UIWindowScene *curWinSc = (UIWindowScene *)tmpSc;
        window = curWinSc.keyWindow;
    } else if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive){
                window = windowScene.windows.lastObject;
                if (!window) {
                    for (UIWindow *win in windowScene.windows){
                        if (window.isKeyWindow){
                            window = win;
                            break;
                        }
                    }
                } else {
                    break;
                }
            }
        }
    } else {
        window = [[UIApplication sharedApplication] windows].firstObject;
    }
    
    if (!window) {
        UIScene * _Nullable scene = [UIApplication sharedApplication].openSessions.allObjects.lastObject.scene;
        SceneDelegate *dlt = (SceneDelegate *)scene.delegate;
        window = dlt.window;
    }
    
    if (!window) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *wd in [windows reverseObjectEnumerator]) {
            if ([wd isKindOfClass:[UIWindow class]] && wd.windowLevel == UIWindowLevelNormal && CGRectEqualToRect(wd.bounds, [UIScreen mainScreen].bounds)) {
                window = wd;
                break;
            }
        }
    }
    
    return window;
}

@end
