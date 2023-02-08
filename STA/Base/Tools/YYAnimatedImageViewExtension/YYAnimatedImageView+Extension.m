//
//  YYAnimatedImageView+Extension.m
//  VoQiPei
//
//  Created by 韩亚周 on 2021/4/9.
//

#import "YYAnimatedImageView+Extension.h"
#import <objc/runtime.h>

@implementation YYAnimatedImageView (Extension)

+(void)load {
    Method method1 = class_getInstanceMethod(self, @selector(displayLayer:));
    Method method2 = class_getInstanceMethod(self, @selector(dx_displayLayer:));
    method_exchangeImplementations(method1, method2);
}

-(void)dx_displayLayer:(CALayer *)layer {
    
    if ([UIImageView instancesRespondToSelector:@selector(displayLayer:)]) {
        [super displayLayer:layer];
    }
}

@end
