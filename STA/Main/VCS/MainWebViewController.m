//
//  MainWebViewController.m
//  STA
//
//  Created by 韩亚周 on 2021/6/23.
//

#import "MainWebViewController.h"
#import "WKMessageHandle.h"
#import "LoginViewController.h"
#import "YYTouchIDManager.h"
#import <CoreLocation/CoreLocation.h>
#import "YYTakePhotosViewController.h"
#import <SDWebImage/SDWebImage.h>
#import "VQPNotchScreenUtil.h"

@interface MainWebViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) LoginModel *userModel;

@end

@implementation MainWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setShouldNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSHTTPCookie *cook = [[NSHTTPCookie alloc] initWithProperties:@{@"usercode":@1}];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cook];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectZero];
    topView.backgroundColor = [UIColor colorNamed:@"FFFFFF"];
    [self.view addSubview:topView];
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[topView]|"
                               options:1.0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(topView)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[topView(64)]"]
                               options:1.0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(topView)]];
    
    NSDictionary *firstDic = [NSDictionary dictionaryWithDictionary:YYD(@"FST")];
    LoginModel *firstModel = [LoginModel yy_modelWithDictionary:firstDic];
    if (firstModel.first && [firstModel.first isEqualToString:@"first"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@{@"biology":@"close"} forKey:@"Biology"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        
    }
    self.view.backgroundColor = [UIColor colorNamed:@"FFFFFF"];
    NSDictionary *biologyDic = [NSDictionary dictionaryWithDictionary:YYD(@"Biology")];
    LoginModel *biologyModel = [LoginModel yy_modelWithDictionary:biologyDic];
    //[MBProgressHUD showMessage:@"Loading..."];
    NSString *urlStr = [NSString stringWithFormat:@"%@admin/login.action?user.usercode=%@&user.password=%@&token=%@&clienttype=%ld",self.userModel.url,_dataModel.username,_dataModel.password,_dataModel.token,_dataModel.clienttype];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"%@",urlStr);
    
    if (biologyModel.biology && [biologyModel.biology isEqualToString:@"open"]) {
        WS(ws);
        NSString *bsUrl = (self.userModel.url && self.userModel.url.length>0) ? self.userModel.url : BASE_URL;
        NSString *urlStr = [NSString stringWithFormat:@"%@admin/login.action?user.usercode=%@&user.password=%@&token=%@&clienttype=%ld",bsUrl,_dataModel.username,_dataModel.password,_dataModel.token,_dataModel.clienttype];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSLog(@"%@",urlStr);
        [[YYTouchIDManager shareManager] openTouchId:NO block:^(BOOL isSuccess) {
            if (isSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ws.view.backgroundColor = [UIColor colorNamed:@"3B404D"];
                    [ws.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10]];
                });
            } else {
                [[YYTouchIDManager shareManager] openTouchId:NO block:^(BOOL isSuccess) {
                    if (isSuccess) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            ws.view.backgroundColor = [UIColor colorNamed:@"3B404D"];
                            [ws.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10]];
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showError:@"Verification failed"];
                            NSString *jsStr = [NSString stringWithFormat:@"failLocation()"];
                            [ws.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                                if (error) {
                                    NSLog(@"初次加载错误:%@", error.localizedDescription);
                                }
                            }];
                        });
                    }
                }];
            }
        }];
    } else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10]];
    }
    //http://eleapp.7tech.sg/admin/login.action?user.usercode=admin&user.password=111111&token=sadfaf&clienttype=2
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    WS(ws);
    CLLocation *curLocation = [locations lastObject];
    // 通过location  或得到当前位置的经纬度
    CLLocationCoordinate2D curCoordinate2D = curLocation.coordinate;
    [manager stopUpdatingLocation];//定位成功后停止定位
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:curLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
       if(!error){
           for (CLPlacemark *place in placemarks) {
               //道路+门牌号 name
               //thoroughfare 道路
               //门牌号 subThoroughfare
               //城市 locality
               // 县区subLocality
               // 县区？（大陆为空）subAdministrativeArea
               // 国家地区country
               NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@%@",place.subAdministrativeArea ? place.subAdministrativeArea : (place.administrativeArea),place.locality,place.subLocality,place.thoroughfare,place.name];
               NSLog(@"%@",addressStr);
               NSString *jsStr = [NSString stringWithFormat:@"toLocation(%f,%f,'%@')",curCoordinate2D.longitude, curCoordinate2D.latitude, addressStr];
               [ws.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                   if (error) {
                       NSLog(@"定位错误:%@", error.localizedDescription);
                   }
               }];
            break;
           }
       }
   }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  if (error.code == kCLErrorDenied) {
    // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
      NSString *jsStr = [NSString stringWithFormat:@"failLocation()"];
      [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
          if (error) {
              NSLog(@"定位失败错误:%@", error.localizedDescription);
          }
      }];
  }
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuretion = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        //WKWebViewConfiguration *configuretion = self.webView.configuration;
        configuretion.preferences = [[WKPreferences alloc]init];
        configuretion.preferences.minimumFontSize = 8;
        configuretion.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuretion.processPool = [[WKProcessPool alloc] init];
        // 通过js与webview内容交互配置
        configuretion.userContentController = [[WKUserContentController alloc] init];
        //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        //OC注册供JS调用的方法
        //WKMessageHandle *handle = [[WKMessageHandle alloc] initWithDelegate:self];
        WKMessageHandle *handle = [[WKMessageHandle alloc] init];
        WS(ws);
        handle.scriptMessageHandle = ^(WKUserContentController * _Nonnull userController, WKScriptMessage * _Nonnull message) {
            NSLog(@"回调");
            SEL selector = NSSelectorFromString(message.name);
            ((void (*)(id, SEL))[ws methodForSelector:selector])(ws, selector);
        };
        //启用相机拍照
        [configuretion.userContentController addScriptMessageHandler:handle name:@"startCamera"];
        //启动定位
        [configuretion.userContentController addScriptMessageHandler:handle name:@"getLocation"];
        //开启指纹或者人脸
        [configuretion.userContentController addScriptMessageHandler:handle name:@"openBiology"];
        //关闭指纹，或者人脸。
        [configuretion.userContentController addScriptMessageHandler:handle name:@"closeBiology"];
        [configuretion.userContentController addScriptMessageHandler:handle name:@"drawRect"];
        [configuretion.userContentController addScriptMessageHandler:handle name:@"popBack"];
        [configuretion.userContentController addScriptMessageHandler:handle name:@"uploadPic"];
        //_webView.customUserAgent = @"Mozilla/5.0 (iPad; CPU OS 12_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1.2 Mobile/15E148 Safari/604.1";
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuretion];
        _webView.scrollView.bounces = NO;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_webView];
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|[_webView]|"
                                   options:1.0
                                   metrics:nil
                                   views:NSDictionaryOfVariableBindings(_webView)]];
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-[_webView]-|"]
                                   options:1.0
                                   metrics:nil
                                   views:NSDictionaryOfVariableBindings(_webView)]];
    }
    return _webView;
}

- (LAContext *)context {
    if (!_context) {
        self.context = [[LAContext alloc] init];
        self.context.localizedFallbackTitle = @"User password";
    }
    return _context;
}

/*!签名*/
- (void)drawRect {
    NSLog(@"drawRect");
}

/*!退出登录*/
- (void)popBack {
    NSLog(@"popBack");
    //清空缓存的用户信息
    WS(ws);
    [[NSUserDefaults standardUserDefaults] setObject:@{@"user.usercode":@"",@"user.password":@"",@"token":@"",@"url":@""} forKey:@"STAUP"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        LoginViewController *lgVC = [LoginViewController new];
        lgVC.modalPresentationStyle = UIModalPresentationFullScreen;
        lgVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:lgVC animated:YES completion:^{}];
        lgVC.lgSuccess = ^(LoginViewController * _Nonnull hdVC, LoginModel * _Nonnull hdModel, BOOL rlt) {
            ws.dataModel = hdModel;
            //根据新登录账号重新加载
            NSString *urlStr = [NSString stringWithFormat:@"%@admin/login.action?user.usercode=%@&user.password=%@&token=%@&clienttype=%ld",self.userModel.url,ws.dataModel.username,ws.dataModel.password,ws.dataModel.token,ws.dataModel.clienttype];
            urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [ws.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10]];
        };
    }
}
/*!上传图片*/
- (void)uploadPic {
    //唤起相册或打开相机
    WS(ws);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"choose photo" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /*拍照*/
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = ws;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [ws presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    UIAlertAction *photoAblumAction = [UIAlertAction actionWithTitle:@"Photo album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /*去相册中取图片*/
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = ws;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [ws presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    /*!判断是否支持相机*/
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [alertController addAction:takePhotoAction];
    }else{
        
    }
    [alertController addAction:photoAblumAction];
    [alertController addAction:cancelAction];
    [ws presentViewController:alertController animated:YES completion:nil];
}

- (void)updataFaceImage:(UIImage *)image {
    [MBProgressHUD showMessage:@"Loading..."];
    WS(ws);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:[NSString stringWithFormat:@"%@phone/fileupload.action",self.userModel.url]
       parameters:@{}
          headers:@{}
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *fileName = [NSString stringWithFormat:@"%@_face.png",[formatter stringFromDate:[NSDate date]]];
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8)
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/png"];
    }
         progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"ret"] boolValue]) {
            //tobackuploadpath
            //tofaceuploadpath
            NSString *jsStr = [NSString stringWithFormat:@"tofaceuploadpath('%@')", responseObject[@"filepath"]];
            [ws.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"上传头像错误:%@", error.localizedDescription);
                }
            }];
        } else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"Save failed"];
    }];
}

/*!打开相机*/
- (void)startCamera {
    WS(ws);
    YYTakePhotosViewController *pVC = [YYTakePhotosViewController new];
    pVC.modalPresentationStyle = UIModalPresentationFullScreen;
    pVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    pVC.picBlock = ^(YYTakePhotosViewController * _Nonnull hdVC, UIImage * _Nullable hdImg) {
        hdImg = [hdImg sd_resizedImageWithSize:CGSizeMake(320, 320) scaleMode:SDImageScaleModeFill];
        //NSLog(@"%@",NSStringFromCGSize(hdImg.size));
        //计算图片大小
        //[ws calulateImageFileSize:hdImg];
        [ws updataFaceImage:hdImg];
    };
    [self.navigationController pushViewController:pVC animated:YES];
}

- (void)updataImage:(UIImage *)image {
    [MBProgressHUD showMessage:@"Loading..."];
    WS(ws);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:[NSString stringWithFormat:@"%@phone/fileupload.action",self.userModel.url]
       parameters:@{}
          headers:@{}
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *fileName = [NSString stringWithFormat:@"%@_header.png",[formatter stringFromDate:[NSDate date]]];
    [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.1)
                                name:@"file"
                            fileName:fileName
                            mimeType:@"image/png"];
} progress:^(NSProgress * _Nonnull uploadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    [MBProgressHUD hideHUD];
    if ([responseObject[@"ret"] boolValue]) {
        NSString *jsStr = [NSString stringWithFormat:@"tobackuploadpath('%@')", responseObject[@"filepath"]];
        [ws.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            if (error) {
                NSLog(@"上传图片错误:%@", error.localizedDescription);
            }
        }];
    } else {
        [MBProgressHUD showError:responseObject[@"msg"]];
    }
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"Save failed"];
}];
    
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    WS(ws);
    [picker dismissViewControllerAnimated:YES completion:^{
        [ws updataImage:image];
    }];
}

- (void)calulateImageFileSize:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 0.8);//需要改成0.5才接近原图片大小，原因请看下文
    }
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    NSLog(@"image = %.3f %@",dataLength,typeArray[index]);
}

/*!开始定位*/
- (void)getLocation {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
    } else {
        [_locationManager startUpdatingLocation];
    }
}
/*开启指纹或者人脸*/
- (void)openBiology {
    [[NSUserDefaults standardUserDefaults] setObject:@{@"biology":@"open"} forKey:@"Biology"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*关闭指纹或者人脸*/
- (void)closeBiology {
    [[NSUserDefaults standardUserDefaults] setObject:@{@"biology":@"close"} forKey:@"Biology"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 代理方法 WKNavigationDelegate WKScriptMessageHandler
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.view.backgroundColor = [UIColor colorNamed:@"3B404D"];
    [MBProgressHUD hideHUD];
    [MBProgressHUD showMessage:@"loading..."];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [MBProgressHUD hideHUD];
    //判断是否支持指纹或者面容
    //admin/login.action?user.usercode=
    NSDictionary *firstDic = [NSDictionary dictionaryWithDictionary:YYD(@"FST")];
    LoginModel *firstModel = [LoginModel yy_modelWithDictionary:firstDic];
    if (firstModel.first && [firstModel.first isEqualToString:@"first"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@{@"first":@"NOfirst"} forKey:@"FST"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self authorization];
    } else {
        NSDictionary *biologyDic = [NSDictionary dictionaryWithDictionary:YYD(@"Biology")];
        NSString *jsStr = @"";
        LoginModel *biologyModel = [LoginModel yy_modelWithDictionary:biologyDic];
        if (biologyModel.biology && [biologyModel.biology isEqualToString:@"open"]) {
            jsStr = [NSString stringWithFormat:@"callBiology('1')"];
        } else {
            jsStr = [NSString stringWithFormat:@"callBiology('0')"];
        }
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            if (error) {
                NSLog(@"加载完成错误:%@", error.localizedDescription);
            }
        }];
    }
    /*
    //获取所有的HTML
    NSString *doc = @"document.documentElement.innerHTML";
    [webView evaluateJavaScript:doc completionHandler:^(NSString *htmlStr, NSError * _Nullable error) {
        if (error) {
            NSLog(@"JSError:%@",error);
        } else {
            NSLog(@"html--:%@",htmlStr);
        }
    }];
     */
}

//请求页面过程中的错误 服务器接收到请求，并开始返回数据给到客户端的过程中出现传输错误 传输过程中，断网了或者服务器down掉
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:error.localizedDescription];
}

//在开始加载的数据时发生错误时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"在开始加载的数据时发生错误时调用");
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:error.localizedDescription];
}

//9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"web内容处理中断时会触发");
    [MBProgressHUD hideHUD];
    [webView reload];
}

//服务器开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"sub web URl : %@",navigationAction.request.URL);

    decisionHandler(WKNavigationActionPolicyAllow);
}



////解决cookies丢失问题  收到响应后决定是否跳转 (服务器收到请求后)
//- (void)webView:(WKWebView*)webView decidePolicyForNavigationResponse:(WKNavigationResponse*)navigationResponse decisionHandler:(void(^)(WKNavigationResponsePolicy))decisionHandler{
//    if (@available(iOS 12.0, *)) {
//        //iOS11也有这种获取方式，但是我使用的时候iOS11系统可以在response里面直接获取到，只有iOS12获取不到
//        WKHTTPCookieStore *cookieStore = webView.configuration.websiteDataStore.httpCookieStore;
//        [cookieStore getAllCookies:^(NSArray* cookies) {
//            [self setCookie:cookies];
//        }];
//    }else {
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
//        NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
//        [self setCookie:cookies];
//    }
//    decisionHandler(WKNavigationResponsePolicyAllow);
//}
//
//-(void)setCookie:(NSArray *)cookies {
//    NSLog(@"cookies ： %@",cookies);
//    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@" %@",obj.name);
//    }];
////    if (cookies.count > 0) {
////        for (NSHTTPCookie *cookie in cookies) {
////            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
////        }
////    }
//}

// 接收到服务器跳转请求之后调用 主机地址被重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"接收到服务器跳转请求之后调用");
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"内容开始返回");
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUD];
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"释放");
}

/*判断当前手机是否支持指纹解锁或者人脸识别功能*/
-(void)authorization {
    NSError *authError = nil;
    BOOL isCanEvaluatePolicy = [self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError];
    if (authError) {
        [MBProgressHUD showError:@"The device does not support biometry."];
        NSString *jsStr = [NSString stringWithFormat:@"callBiology('0')"];
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            if (error) {
                NSLog(@"是否支持指纹解锁或者人脸识别1错误:%@", error.localizedDescription);
            }
        }];
        [self closeBiology];
    } else {
        if (isCanEvaluatePolicy) {
            if (self.context.biometryType == LABiometryTypeTouchID) {
                //当前支持指纹密码
                NSLog(@"The device supports Touch ID.");
            } else if (self.context.biometryType == LABiometryTypeFaceID) {
                //当前支持指纹密码 @"人脸识别");
                NSLog(@"The device supports Face ID.");
            }else {
                //当前不支持指纹密码指纹密码"
                NSLog(@"The device does not support biometry.");
            }
            
            WS(ws);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Open Touch ID or Face ID" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [ws openBiology];
                NSString *jsStr = [NSString stringWithFormat:@"callBiology('1')"];
                [ws.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"是否支持指纹解锁或者人脸识别2错误:%@", error.localizedDescription);
                    }
                }];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [ws closeBiology];
                NSString *jsStr = [NSString stringWithFormat:@"callBiology('0')"];
                [ws.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"是否支持指纹解锁或者人脸识别3错误:%@", error.localizedDescription);
                    }
                }];
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [ws presentViewController:alertController animated:YES completion:nil];
        } else {
            if (authError.code == LAErrorBiometryNotEnrolled) {
                [MBProgressHUD showError:@"TouchID is not enrolled."];
                NSLog(@"TouchID is not enrolled TouchID未注册");
            } else if (authError.code == LAErrorPasscodeNotSet) {
                [MBProgressHUD showError:@"A passcode has not been set."];
                NSLog(@"A passcode has not been set 未设置密码");
            } else {
                [MBProgressHUD showError:@"TouchID not available TouchID."];
                NSLog(@"TouchID not available TouchID不可用");
            }
            NSString *jsStr = [NSString stringWithFormat:@"callBiology('0')"];
            [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"是否支持指纹解锁或者人脸识别4错误:%@", error.localizedDescription);
                }
            }];
            [self closeBiology];
        }
    }
}
- (LoginModel *)userModel {
    if (!_userModel) {
        _userModel = [[LoginModel alloc] init];
    }
    return _userModel;
}

/*
- (void)evaluatePolicy {
    WS(ws);
    [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Authenticate to access" reply:^(BOOL success, NSError * _Nullable error) {
                if(success) {
                    NSString *urlStr = [NSString stringWithFormat:@"%@admin/login.action?user.usercode=%@&user.password=%@&token=%@&clienttype=%ld",BASE_URL,ws.dataModel.username,ws.dataModel.password,ws.dataModel.token,ws.dataModel.clienttype];
                    NSLog(@"%@",urlStr);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ws.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
                    });
                } else {
                    NSLog(@"指纹认证失败，%@",error.description);

                    NSLog(@"%ld", (long)error.code); // 错误码 error.code
                    switch (error.code)
                    {
                        case LAErrorAuthenticationFailed: // Authentication was not successful, because user failed to provide valid credentials
                        {
                            NSLog(@"授权失败"); // -1 连续三次指纹识别错误
                        }
                            break;
                        case LAErrorUserCancel: // Authentication was canceled by user (e.g. tapped Cancel button)
                        {
                            NSLog(@"用户取消验证Touch ID"); // -2 在TouchID对话框中点击了取消按钮

                        }
                            break;
                        case LAErrorUserFallback: // Authentication was canceled, because the user tapped the fallback button (Enter Password)
                        {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                NSLog(@"用户选择输入密码，切换主线程处理"); // -3 在TouchID对话框中点击了输入密码按钮
                            }];

                        }
                            break;
                        case LAErrorSystemCancel: // Authentication was canceled by system (e.g. another application went to foreground)
                        {
                            NSLog(@"取消授权，如其他应用切入，用户自主"); // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                        }
                            break;
                        case LAErrorPasscodeNotSet: // Authentication could not start, because passcode is not set on the device.

                        {
                            NSLog(@"设备系统未设置密码"); // -5
                        }
                            break;
                        case LAErrorBiometryNotAvailable: // Authentication could not start, because Touch ID is not available on the device
                        {
                            NSLog(@"设备未设置Touch ID"); // -6
                        }
                            break;
                        case LAErrorBiometryNotEnrolled: // Authentication could not start, because Touch ID has no enrolled fingers
                        {
                            NSLog(@"用户未录入指纹"); // -7
                        }
                            break;

    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
                        case LAErrorBiometryLockout:
                            //Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite 用户连续多次进行Touch ID验证失败，Touch ID被锁，需要用户输入密码解锁，先Touch ID验证密码
                        {
                            NSLog(@"Touch ID被锁，需要用户输入密码解锁"); // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                        }
                            break;
                        case LAErrorAppCancel: // Authentication was canceled by application (e.g. invalidate was called while authentication was in progress) 如突然来了电话，电话应用进入前台，APP被挂起啦");
                        {
                            NSLog(@"用户不能控制情况下APP被挂起"); // -9
                        }
                            break;
                        case LAErrorInvalidContext: // LAContext passed to this call has been previously invalidated.
                        {
                            NSLog(@"LAContext传递给这个调用之前已经失效"); // -10
                        }
                            break;
    #else
    #endif
                        default:
                        {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                NSLog(@"其他情况，切换主线程处理");
                            }];
                            break;
                        }
                    }
                }
            }];

}
 */

@end
