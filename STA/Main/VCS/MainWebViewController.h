//
//  MainWebViewController.h
//  STA
//
//  Created by 韩亚周 on 2021/6/23.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "LoginModel.h"
#import <LocalAuthentication/LocalAuthentication.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainWebViewController : BaseViewController <WKUIDelegate, WKNavigationDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) WKWebView *webView;
/*!登录结果数据*/
@property (nonatomic, strong) LoginModel *dataModel;
/*!指纹&人脸识别*/
@property (strong,nonatomic) LAContext* context;

@end

NS_ASSUME_NONNULL_END
