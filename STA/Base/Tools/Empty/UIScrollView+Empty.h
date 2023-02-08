//
//  UIScrollView+Empty.h
//  LiveHelper
//
//  Created by 韩亚周 on 2020/12/15.
//  Copyright © 2020 韩亚周. All rights reserved.
//
/*
1、使用时只需调用此方法，即可在调用SEL: reloadData 时自动判断是否展示空值界面
2、更多定制可根据此实现方案进行相对应拓展  一般会对emptyView 进行定制操作

exp:

[_tableView setEmptyViewWithImage:[UIImage imageNamed:@"noresult"] title:@"暂无数据" eventBlock:^{
 NSLog(@"点击了，去刷新喽");
}];

*/

#import <UIKit/UIKit.h>
#import "YYHelper.h"

NS_ASSUME_NONNULL_BEGIN
/**
 点击事件回调
 */
typedef void(^FuncBlock) (void);

@interface UIScrollView (Empty)

@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, copy ) FuncBlock emptyEventBlock;

/**
 设置空值界面
 根据传入内容决定展示风格：  图片、文字、文字和图片、是否添加点击事件

 @param image 展示图片 可为空
 @param title 展示文字 可为空
 @param block 点击事件block 可为空（按钮隐藏）  为空则没有点击事件
 */
- (void)setEmptyViewWithImage:(UIImage *__nullable)image title:(NSString *__nullable)title itemTit:(NSString *__nullable)itemTit eventBlock:(FuncBlock _Nullable)block;

@end

@interface UITableView (Empty)

-(void)addHeardTarget:(id)target Action:(SEL)action;
-(void)addFooterTarget:(id)target Action:(SEL)action;
@property(nonatomic,strong)MJRefreshHeader *header;
@property(nonatomic,strong)MJRefreshFooter *footer;

@end

@interface UICollectionView (Empty)

-(void)addHeardTarget:(id)target Action:(SEL)action;
-(void)addFooterTarget:(id)target Action:(SEL)action;
@property(nonatomic,strong)MJRefreshHeader *header;
@property(nonatomic,strong)MJRefreshFooter *footer;

@end

NS_ASSUME_NONNULL_END

