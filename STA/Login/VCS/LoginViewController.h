//
//  LoginViewController.h
//  STA
//
//  Created by 韩亚周 on 2021/6/22.
//

#import "BaseViewController.h"
#import "MainWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

/*!登录*/
@interface LoginViewController : BaseViewController

/*!请求参数及返回结果*/
@property (nonatomic, strong) LoginModel *parameters;
/*!登录成功回调*/
@property (nonatomic, copy ) void (^lgSuccess) (LoginViewController *hdVC, LoginModel *hdModel,BOOL rlt);

@end

NS_ASSUME_NONNULL_END
