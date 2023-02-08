//
//  SceneDelegate.m
//  STA
//
//  Created by 韩亚周 on 2021/6/22.
//

#import "SceneDelegate.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:64];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
        
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.frame = windowScene.coordinateSpace.bounds;
    LoginModel *model = [[LoginModel alloc] init];
    BOOL hasLogin = (model.token && model.token.length > 10);
    LoginViewController *lgVC = [LoginViewController new];
    MainWebViewController *webVC = [MainWebViewController new];
    webVC.dataModel = model;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:(hasLogin ? webVC : lgVC)];
    [navVC setNavigationBarHidden:YES animated:YES];
    //navVC.shouldNavigationBarHidden = YES;
    /*
    MainWebViewController *webVC = [MainWebViewController new];
    webVC.dataModel = model;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:lgVC];
    navVC.navigationBarHidden = YES;
    if (hasLogin) {
        [navVC pushViewController:webVC animated:YES];
    } else {
        
    }
    lgVC.view.alpha = 1.0f;
     */
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].delegate.window = self.window;
}


- (void)sceneDidDisconnect:(UIScene *)scene {}

- (void)sceneDidBecomeActive:(UIScene *)scene {}

- (void)sceneWillResignActive:(UIScene *)scene {}

- (void)sceneWillEnterForeground:(UIScene *)scene {}

- (void)sceneDidEnterBackground:(UIScene *)scene {}


@end
