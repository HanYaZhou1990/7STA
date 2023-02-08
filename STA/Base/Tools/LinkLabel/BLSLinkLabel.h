//
//  BLSLinkLabel.h
//  VoQiPei
//
//  Created by 韩亚周 on 2021/4/9.
//

#import <UIKit/UIKit.h>
@class BLSLinkConfig;

NS_ASSUME_NONNULL_BEGIN

/*!设置部分文字高亮且可增加点击,实现clickedHandle即可拿到点击事件
   先赋值lable.text，然后lable.config即可
   此工具类，只能使用在开头需要点击时
 */
@interface BLSLinkLabel : UILabel

@property (nonatomic, strong) BLSLinkConfig *config;
/*!高亮文字点击*/
@property (nonatomic, copy ) void (^clickedHandle) (BLSLinkLabel *hdLab);
/*!普通文字点击*/
@property (nonatomic, copy ) void (^otherClickedHandle) (BLSLinkLabel *hdLab);

@end

@interface BLSLinkConfig : NSObject

/*!高亮文本*/
@property (nonatomic, strong) NSString *hStr;
/*!高亮文本颜色 默认blueColor*/
@property (nonatomic, strong) UIColor *hColor;
/*!高亮文本字体大小 默认17号字*/
@property (nonatomic, strong) UIFont *hFont;

@end

NS_ASSUME_NONNULL_END
