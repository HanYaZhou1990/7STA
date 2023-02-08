//
//  UIViewController+NavigationBarHidden.m
//  STA
//
//  Created by 韩亚周 on 2021/4/7.
//

#import "UIViewController+NavigationBarHidden.h"

#import <objc/runtime.h>

@implementation UIViewController (NavigationBarHidden)

- (BOOL)shouldNavigationBarHidden{
    return [objc_getAssociatedObject(self, @selector(shouldNavigationBarHidden)) boolValue];
}

- (void)setShouldNavigationBarHidden:(BOOL)shouldNavigationBarHidden{
    objc_setAssociatedObject(self, @selector(shouldNavigationBarHidden), @(shouldNavigationBarHidden), OBJC_ASSOCIATION_ASSIGN);
}


@end
