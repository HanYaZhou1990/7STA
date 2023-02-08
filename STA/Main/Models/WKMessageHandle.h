//
//  WKMessageHandle.h
//  STA
//
//  Created by 韩亚周 on 2021/6/23.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKMessageHandle : UIViewController <WKScriptMessageHandler>

@property (nonatomic, copy) void (^scriptMessageHandle) (WKUserContentController *userController, WKScriptMessage *message);

@end

NS_ASSUME_NONNULL_END
