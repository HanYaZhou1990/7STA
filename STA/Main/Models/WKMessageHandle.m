//
//  WKMessageHandle.m
//  STA
//
//  Created by 韩亚周 on 2021/6/23.
//

#import "WKMessageHandle.h"

@implementation WKMessageHandle

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (_scriptMessageHandle) {
        _scriptMessageHandle(userContentController, message);
    }
}

@end
