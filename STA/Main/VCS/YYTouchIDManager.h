//
//  YYTouchIDManager.h
//  STA
//
//  Created by 韩亚周 on 2021/6/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!指纹、面容识别管理*/
@interface YYTouchIDManager : NSObject

+ (instancetype)shareManager;

- (BOOL)openTouchId:(BOOL)config block:(void (^)(BOOL isSuccess))rltHandle;

@end

NS_ASSUME_NONNULL_END
