//
//  YYTakePhotosViewController.h
//  STA
//
//  Created by 韩亚周 on 2021/6/28.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VQPNotchScreenUtil.h"

NS_ASSUME_NONNULL_BEGIN

/*!拍照*/
@interface YYTakePhotosViewController : BaseViewController <AVCapturePhotoCaptureDelegate>

/*!摄像头扫描的场景视图*/
@property (nonatomic, weak) IBOutlet UIView *avLayerView;
/*!拍照后生成的照片展示*/
@property (nonatomic, weak) IBOutlet UIImageView *photo;
/*!拍照*/
@property (nonatomic, weak) IBOutlet UIButton *take;
/*!切换摄像头*/
@property (nonatomic, weak) IBOutlet UIButton *switchBtn;
/*!NO 前置摄像图 YES后置摄像头 默认NO*/
@property (nonatomic, assign) BOOL frontCamera;
/*!待取图片的背景*/
//@property (nonatomic, weak) IBOutlet UIView *picBG;
@property (nonatomic, weak) IBOutlet UIImageView *coverImgView;
/*!*/
@property (nonatomic, weak) IBOutlet UIButton *collect;
/*!上传*/
@property (nonatomic, weak) IBOutlet UIButton *upload;

@property (nonatomic ,strong) AVCaptureSession *session;
@property (nonatomic ,strong) AVCaptureDevice *device;
@property (nonatomic ,strong) AVCaptureDeviceInput *deviceInput;//图像输入源
//@property (nonatomic ,strong) AVCaptureOutput *outPut;          //图像输出源
@property (nonatomic ,strong) AVCapturePhotoOutput *outPut;
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic , copy) void (^picBlock) (YYTakePhotosViewController *hdVC , UIImage * __nullable hdImg);
/*!需要上传的图片*/
@property (nonatomic ,strong) UIImage *uploadImg;

@end

NS_ASSUME_NONNULL_END
