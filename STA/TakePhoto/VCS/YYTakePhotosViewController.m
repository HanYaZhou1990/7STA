//
//  YYTakePhotosViewController.m
//  STA
//
//  Created by 韩亚周 on 2021/6/28.
//

#import "YYTakePhotosViewController.h"

@interface YYTakePhotosViewController ()

@end

@implementation YYTakePhotosViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setShouldNavigationBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setShouldNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Face Identification";
    _frontCamera = NO;
    
    self.view.backgroundColor = Color(@"00000080");
    
    [self authorization];
}

#pragma mark - 相机授权
-(void)authorization {
    //请求相机权限
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            WS(ws);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [ws authorization];
                }else{
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"The album camera permission is not enabled, please go to Phone -> Settings to enable the camera permission" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [ws.navigationController popViewControllerAnimated:YES];
                        [ws dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [controller addAction:action];
                    [ws presentViewController:controller animated:YES completion:nil];
                    return;
                }
            });
        }];
        
    }else if (status == AVAuthorizationStatusDenied) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"Camera permission is not enabled, please go to Phone-Settings to enable camera permission" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
        return;
    }else if (status == AVAuthorizationStatusAuthorized){
        [self configData];
    }
}

-(void)configData {
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //如果不放在子线程里，跳转到相机的时候，会卡
        [self addPicIO];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            self.previewLayer.frame = self.avLayerView.frame;
            [self.avLayerView.layer insertSublayer:self.previewLayer atIndex:0];
            [self.session startRunning];
        });
    });
}

#pragma mark 设置 拍照类型的输入输出源
-(void)addPicIO {
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
    if (!error) {
        if (self.deviceInput && [self.session.inputs containsObject:self.deviceInput]) {
            [self.session removeInput:self.deviceInput];
        }
        if ([self.session canAddInput:deviceInput]) {
            [self.session addInput:deviceInput];
            self.deviceInput = deviceInput;
        } else {
            [self.session addInput:self.deviceInput];
        }
        
        if (self.outPut && [self.session.outputs containsObject:self.outPut]) {
            [self.session removeOutput:self.outPut];
        }
        if ([self.session canAddOutput:self.outPut]) {
            [self.session addOutput:self.outPut];
        } else {
            [self.session addOutput:self.outPut];
        }
        [self.session commitConfiguration];
    }
}

-(AVCaptureDevice *)device{
    if (!_device) {
        if (_frontCamera) {
            _device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        } else {
            _device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
        }
        [_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus];
    }
    return _device;
}

-(AVCaptureOutput *)outPut{
    if (!_outPut) {
        _outPut = [[AVCapturePhotoOutput alloc] init];
        [self.outPut.connections.lastObject setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    return _outPut;
}

/*!切换摄像头*/
-(IBAction)fixCamera:(UIButton *)sender {
    self.frontCamera = !self.frontCamera;
    self.device = nil;
    [self addPicIO];
}

/*!拍照*/
-(IBAction)takePicture:(UIButton *)sender {
    // 防止快速连点
    sender.userInteractionEnabled = NO;
    //AVCapturePhotoSettings *set = [AVCapturePhotoSettings photoSettings];
    AVCapturePhotoSettings *set = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecTypeJPEG}];
    [self.outPut capturePhotoWithSettings:set delegate:self];
}

/*!取消重新拍照*/
- (IBAction)collect:(UIButton *)sender {
    _avLayerView.alpha = 1;
    self.photo.image = nil;
    self.photo.hidden = YES;
    _take.hidden = NO;
    _switchBtn.hidden = NO;
    _collect.hidden = YES;
    _upload.hidden = YES;
    [self.session startRunning];
}

- (IBAction)upLoad:(UIButton *)sender {
    if (_picBlock) {
        if (_uploadImg) {
            _picBlock(self, _uploadImg);
        } else {
            _picBlock(self, nil);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*!取照片*/
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error  API_AVAILABLE(ios(11.0)){
    if (!error) {
        //前置摄像头拍照会旋转180解决办法
        CGImageRef cgImage = [photo CGImageRepresentation];
        UIImageOrientation imgOrientation = UIImageOrientationLeftMirrored;
        UIImage *image = [[UIImage alloc]initWithCGImage:cgImage scale:1.0f orientation:imgOrientation];
        
        
        //CGRect convertRect = [_picBG convertRect:_picBG.frame toView:_photo];
        //CGFloat stateH = [VQPNotchScreenUtil getIPhoneNotchScreenHeight] + 24;
        //CGRect convertRect = CGRectMake(CGRectGetMinX(_picBG.frame), CGRectGetMinY(_picBG.frame) - (stateH), CGRectGetWidth(_picBG.frame), CGRectGetHeight(_picBG.frame));
        
        //2023/02/16注释，使用下方convertRect
        //CGFloat stateH = [VQPNotchScreenUtil getIPhoneNotchScreenHeight] + 24;
        //CGRect convertRect = CGRectMake(CGRectGetMinX(self.coverImgView.frame), CGRectGetMinY(self.coverImgView.frame) - (stateH), CGRectGetWidth(self.coverImgView.frame), CGRectGetHeight(self.coverImgView.frame));
        CGRect convertRect = CGRectMake(0, (CGRectGetHeight(self.coverImgView.frame) - CGRectGetWidth(self.coverImgView.frame))/4.4f, CGRectGetWidth(self.coverImgView.frame), CGRectGetWidth(self.coverImgView.frame));
        
        
        //UIImage *nowImg = [self editImageWithOldImage:image OldFrame:_photo.frame CropFrame:_picBG.frame Scale:0.5];
        UIImage *nowImg = [self editImageWithOldImage:image OldFrame:_photo.frame CropFrame:convertRect Scale:0.5];

        _uploadImg = nowImg;
        self.photo.image = nowImg;
        self.photo.hidden = NO;
        [self.session stopRunning];
        
        if (self.uploadImg) {
            self.picBlock(self, nowImg);
        } else {
            self.picBlock(self, nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
        //保存到相册
        //UIImageWriteToSavedPhotosAlbum(nowImg, nil, nil, nil);
    }
    _avLayerView.alpha = 0;
    _take.userInteractionEnabled = YES;
    _take.hidden = YES;
    _switchBtn.hidden = YES;
    _collect.hidden = NO;
    _upload.hidden = NO;
    [self.session startRunning];
}

/// 截图 保证清晰度
- (UIImage *)editImageWithOldImage:(UIImage *)image OldFrame:(CGRect)oldFrame CropFrame:(CGRect)cropFrame Scale:(float)scale {
    image = [self fixOrientation:image];
    CGSize editSize = oldFrame.size;
    CGSize imgSize = image.size;
    CGFloat widthScale;
    CGRect rct;
    if (imgSize.width < editSize.width) {
        widthScale = imgSize.width / editSize.width;
        rct = CGRectMake(cropFrame.origin.x*widthScale, cropFrame.origin.y*widthScale, cropFrame.size.width*widthScale, cropFrame.size.height*widthScale);
    } else {
        widthScale = editSize.width / imgSize.width;
        rct = CGRectMake(cropFrame.origin.x/widthScale, cropFrame.origin.y/widthScale, cropFrame.size.width/widthScale, cropFrame.size.height/widthScale);
    }
 
    CGPoint origin = CGPointMake(-rct.origin.x, -rct.origin.y);
    UIImage *img = nil;
    UIGraphicsBeginImageContextWithOptions(rct.size, NO, image.scale);
    [image drawAtPoint:origin];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
 
    return img;
}

/// 图片方向调整
- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
