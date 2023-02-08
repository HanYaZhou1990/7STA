//
//  EmptyView.m
//  LiveHelper
//
//  Created by 韩亚周 on 2020/12/15.
//  Copyright © 2020 韩亚周. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

- (IBAction)funcHandle:(id)sender {
    if (_funcHandle) {
        _funcHandle();
    }
}

@end
