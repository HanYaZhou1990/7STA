//
//  YYTouchIDManager.m
//  STA
//
//  Created by 韩亚周 on 2021/6/28.
//

#import "YYTouchIDManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

//static NSInteger login_count_error_time;

@interface YYTouchIDManager ()

@property (copy  ,readwrite, nonatomic) NSString *errorString;
@property (strong,nonatomic) LAContext* context;
@property (copy  ,readwrite,nonatomic) NSString * localString;

@end

@implementation YYTouchIDManager

+ (instancetype)shareManager {
    static YYTouchIDManager *manager = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (NSString *)localString{
    if (!_localString) {
        if (@available(iOS 11.0, *)) {
            if (self.context.biometryType == LABiometryTypeTouchID) {
                self.localString =  @"The device supports Touch ID";
            }else if (self.context.biometryType == LABiometryTypeFaceID){
                self.localString =  @"The device supports Face ID";
            }
        } else {
            self.localString = @"The device supports Touch ID";
        }
    }
    return _localString;
}

- (BOOL)openTouchId:(BOOL)config block:(void (^)(BOOL isSuccess))rltHandle {
    self.context = [[LAContext alloc] init];
    NSError* error = nil;
    if ([_context canEvaluatePolicy:1 error:&error]) {
        if (!error && !config) {
            [self touchId:_context andLockOut:NO block:^(BOOL isSuccess) {
                rltHandle(isSuccess);
            }];
        }
        return YES;
    }else{
        switch (error.code) {
            case LAErrorPasscodeNotSet:{
                rltHandle(NO);
               NSLog(@"Authentication cannot be started because the device does not have a password set.");
                break;
            }
            case LAErrorBiometryNotEnrolled:{
                rltHandle(NO);
           //你尚未设置Touch ID，请在手机系统“设置>Touch ID与密码“中添加指纹
            //You have not set up Touch ID, please add your fingerprint in the phone system "Settings -> Touch ID and password"
                break;
            }
            case LAErrorBiometryLockout:{
                [self touchId:_context andLockOut:YES block:^(BOOL isSuccess) {
                    rltHandle(isSuccess);
                }];
                return YES;
                break;
            }
            default:{
                rltHandle(NO);
                break;
            }
        }

    }
    return NO;
}

- (void)touchId:(LAContext *)contxt andLockOut:(BOOL)lock block:(void (^)(BOOL isSuccess))rltHandle {
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics ，指纹授权使用， 当设备不具有Touch ID的功能，或者在系统设置中没有设置开启指纹，授权将会失败。当指纹验证3+2次都没有通过的时候指纹验证就会被锁定，就需要先进行数字密码的解锁才能继续使用指纹密码。
    //LAPolicyDeviceOwnerAuthentication，指纹和数字密码的授权使用，当指纹可用且没有被锁定，授权后会进入指纹密码验证。不然的话会进入数字密码验证的页面。当系统数字密码没有设置不可用的时候，授权失败。
    //如果数字密码输入不正确，连续6次输入数字密码都不正确后，会停用鉴定过一定的间隔后才能使用，间隔时间依次增长.
    self.context.localizedFallbackTitle = !lock?@"Please try again":@"User password";

    NSInteger lopli =  lock?LAPolicyDeviceOwnerAuthentication:LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    NSString * result_cn = !lock?@"Please verify that you have a fingerprint":@"Too many errors, a password is required to enable TouchID";
    
    [contxt evaluatePolicy:lopli localizedReason:result_cn reply:^(BOOL success, NSError *error) {
        if (success) {
            //验证成功，主线程处理UI
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"success");
                rltHandle(YES);
            });
        }else{
            switch (error.code) {
                case LAErrorSystemCancel:{
                    //系统取消授权，如其他APP切入
                    break;
                }
                case LAErrorUserCancel:{
                    //用户取消验证Touch ID
                    break;
                }
                case LAErrorAuthenticationFailed:{
                    //授权失败
                    if ([error.localizedDescription isEqualToString:@"Application retry limit exceeded."]){
                        [self touchId:contxt andLockOut:NO block:^(BOOL isSuccess) {
                            rltHandle(NO);
                        }];
                    }
                    break;
                }
                case LAErrorPasscodeNotSet:{
                    //系统未设置密码
                    break;
                }
                case LAErrorBiometryNotAvailable:{
                    //设备Touch ID不可用，例如未打开
                    break;
                }
                case LAErrorUserFallback:{
                    // 多次验证，指纹或者人脸已失效  ，用户点击了使用密码按钮
                     [self touchId:contxt andLockOut:NO block:^(BOOL isSuccess) {
                         rltHandle(NO);
                     }];
                    break;
                }
                case LAErrorBiometryLockout:{
                    if ([error.localizedDescription isEqualToString:@"Biometry is disabled for unlock."]){
                        [self touchId:contxt andLockOut:NO block:^(BOOL isSuccess) {
                            rltHandle(NO);
                        }];
                    } else if ([error.localizedDescription isEqualToString:@"Biometry is locked out."]){
                        [self touchId:contxt andLockOut:YES block:^(BOOL isSuccess) {
                            rltHandle(NO);
                        }];
                    }
                    break;
                }
                case LAErrorAppCancel:{
                    //应用程序取消了身份验证（例如，调用了无效）。（正在进行身份验证）。
                    break;
                }
                default:{
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        //其他情况，切换主线程处理
                    }];
                    break;
                }
            }
        }
    }];
}
@end
