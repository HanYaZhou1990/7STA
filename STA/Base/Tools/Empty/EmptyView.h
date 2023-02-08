//
//  EmptyView.h
//  LiveHelper
//
//  Created by 韩亚周 on 2020/12/15.
//  Copyright © 2020 韩亚周. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!空页面*/
@interface EmptyView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *icon;
@property (nonatomic, strong) IBOutlet UILabel *tit;
@property (nonatomic, strong) IBOutlet UIButton *btn;

@property (nonatomic, copy ) void (^funcHandle) (void);

@end

NS_ASSUME_NONNULL_END
