//
//  LoginModel.h
//  STA
//
//  Created by 韩亚周 on 2021/6/23.
//

#import <Foundation/Foundation.h>
#import "YYHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginModel : NSObject

/*!账号*/
@property (nonatomic, strong) NSString *username;
/*!密码*/
@property (nonatomic, strong) NSString *password;
/*!链接类型 2*/
@property (nonatomic, assign) NSInteger clienttype;
/*!判断返回是否正确 1正确*/
@property (nonatomic, assign) NSInteger ret;
/*!token*/
@property (nonatomic, strong) NSString *token;
/*!请求出问题的错误提示信息*/
@property (nonatomic, strong) NSString *msg;
/*!是否为第一次启动 first 第一次 其他不是*/
@property (nonatomic, strong) NSString *first;
/*!是否开启了指纹面容登录 open开(默认)  close关*/
@property (nonatomic, strong) NSString *biology;

@end

NS_ASSUME_NONNULL_END
