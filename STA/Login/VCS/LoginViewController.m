//
//  LoginViewController.m
//  STA
//
//  Created by 韩亚周 on 2021/6/22.
//

#import "LoginViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface LoginViewController () <UITextFieldDelegate>

/*!账号录入*/
@property (nonatomic, weak) IBOutlet UITextField *usernameTf;
/*!密码录入*/
@property (nonatomic, weak) IBOutlet UITextField *passwordTf;
/*!账号底部线*/
@property (nonatomic, weak) IBOutlet UIView *usernameLine;
/*!密码底部线*/
@property (nonatomic, weak) IBOutlet UIView *passwordLine;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setShouldNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _parameters = [[LoginModel alloc] init];
    
    _usernameTf.text = (_parameters.username && _parameters.username.length > 0) ? _parameters.username : @"";
    _passwordTf.text = (_parameters.password && _parameters.password.length > 0) ? _parameters.password : @"";
    //_usernameTf.text = @"Zhouwei@7tech.sg";
    //_passwordTf.text = @"Ir0nD0g2@yi";
    //_usernameTf.text = @"ctcco";
    //_passwordTf.text = @"1qazxsw2";
    WS(ws);
    [_usernameTf.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"_usernameTf:%@",x);
        if (x.length) {
            ws.usernameTf.text = x;
        } else {
            ws.usernameTf.text = @"";
        }
        ws.parameters.username = ws.usernameTf.text;
    }];
    [_passwordTf.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"_passwordTf:%@",x);
        if (x.length) {
            ws.passwordTf.text = x;
        } else {
            
        }
        ws.parameters.password = ws.passwordTf.text;
    }];
}

/*!登录*/
- (IBAction)lg:(UIButton *)sender {
    [self.view endEditing:YES];
    if (!_parameters.username || _parameters.username.length == 0) {
        [MBProgressHUD showError:@"Enter user name"];
        return ;
    }
    
    if (!_parameters.password || _parameters.password.length == 0) {
        [MBProgressHUD showError:@"Enter password"];
        return ;
    }
    //https://www.7techsg.com/phone/applogin.action
    WS(ws);
    [MBProgressHUD showMessage:@"loading..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:[NSString stringWithFormat:@"%@phone/applogin.action",BASE_URL]
       parameters:@{@"user.usercode":_parameters.username,@"user.password":_parameters.password,@"clienttype":@(_parameters.clienttype)}
          headers:@{}
         progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUD];
        LoginModel *responseModel = [LoginModel yy_modelWithDictionary:responseObject];
        if (responseModel.ret == 1) {
            responseModel.username = ws.parameters.username;
            responseModel.password = ws.parameters.password;
            responseModel.clienttype = ws.parameters.clienttype;
            MainWebViewController *webVC = [[MainWebViewController alloc] init];
            webVC.dataModel = responseModel;
            // 保存账号密码
            [[NSUserDefaults standardUserDefaults] setObject:@{@"user.usercode":responseModel.username,@"user.password":responseModel.password,@"token":responseModel.token} forKey:@"STAUP"];
            NSDictionary *firstDic = [NSDictionary dictionaryWithDictionary:YYD(@"FST")];
            LoginModel *firstModel = [LoginModel yy_modelWithDictionary:firstDic];
            if (firstModel.first && [firstModel.first isEqualToString:@""]) {
                [[NSUserDefaults standardUserDefaults] setObject:@{@"first":@"first"} forKey:@"FST"];
            } else {
                
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (ws.lgSuccess) {
                ws.lgSuccess(ws, responseModel, YES);
                [ws dismissViewControllerAnimated:YES completion:^{}];
            } else {
                [ws.navigationController pushViewController:webVC animated:YES];
            }
        } else {
            [MBProgressHUD showError:responseModel.msg];
        }
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"login fialed"];
    }];
}

#pragma mark -
#pragma mark UITextFieldDelegate -
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        _usernameLine.backgroundColor = [UIColor colorNamed:@"125A96"];
        _passwordLine.backgroundColor = [UIColor colorNamed:@"C8E2F8"];
    } else {
        _usernameLine.backgroundColor = [UIColor colorNamed:@"C8E2F8"];
        _passwordLine.backgroundColor = [UIColor colorNamed:@"125A96"];
    }
}

@end
