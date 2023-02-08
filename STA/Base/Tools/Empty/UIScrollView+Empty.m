//
//  UIScrollView+Empty.m
//  LiveHelper
//
//  Created by 韩亚周 on 2020/12/15.
//  Copyright © 2020 韩亚周. All rights reserved.
//

#import "UIScrollView+Empty.h"
#import <objc/runtime.h>
#import "EmptyView.h"

@implementation UIScrollView (Empty)

static NSString *kEmptyViewKey = @"EmptyViewKey";
static NSString *kEmptyEventBlockKey = @"EmptyEventBlockKey";

- (void)setEmptyView:(UIView *)emptyView {
    objc_setAssociatedObject(self, &kEmptyViewKey, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)emptyView {
    return objc_getAssociatedObject(self, &kEmptyViewKey);
}

- (void)setEmptyEventBlock:(FuncBlock)emptyEventBlock {
    objc_setAssociatedObject(self, &kEmptyEventBlockKey, emptyEventBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (FuncBlock)emptyEventBlock {
    return objc_getAssociatedObject(self, &kEmptyEventBlockKey);
}

- (void)setEmptyViewWithImage:(UIImage *__nullable)image title:(NSString *__nullable)title itemTit:(NSString *__nullable)itemTit eventBlock:(FuncBlock _Nullable)block {
    if (!self.emptyView) {
        EmptyView *topView =  [[UINib nibWithNibName:@"EmptyView" bundle:nil] instantiateWithOwner:self options:nil].lastObject;
        topView.funcHandle = ^{
            block();
        };
        topView.btn.hidden = !block;
        topView.icon.image = image ? image : [UIImage imageNamed:@"no_more_data"];
        topView.tit.text = title ? title : @"暂无数据";
        [topView.btn setTitle:itemTit forState:UIControlStateNormal];
        self.emptyView = topView;
        self.emptyView.frame = CGRectMake(34, 0, CGRectGetWidth(self.frame)-68, CGRectGetHeight(self.frame));
        [self addSubview:self.emptyView];
    }
    [self bringSubviewToFront:self.emptyView];
}

/// 更新界面，是否展示空值视图
- (void)refreshEmptyView {
    NSInteger section = 1;
    NSInteger rows = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)self;
        if (tableView.dataSource != nil && [tableView.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            
            if ([tableView.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
                section = [tableView.dataSource numberOfSectionsInTableView:tableView];
            }
            for (int i = 0; i < section; i++) {
                rows += [tableView.dataSource tableView:tableView numberOfRowsInSection:i];
            }
        }
    }else if ([self isKindOfClass:[UICollectionView class]]) {
        
        UICollectionView *collectionView = (UICollectionView *)self;
        if (collectionView.dataSource != nil && [collectionView.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            
            if ([collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
                section = [collectionView.dataSource numberOfSectionsInCollectionView:collectionView];
            }
            for (int i = 0; i < section; i++) {
                rows += [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:i];
            }
        }
    }
    
    if (rows == 0) {
        self.emptyView.hidden = NO;
        [self bringSubviewToFront:self.emptyView];
    }else{
        self.emptyView.hidden = YES;
        return;
    }
}


#pragma mark -- swizzing
+ (void)hookClass:(Class)classObject originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Class class = classObject;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    if (didAddMethod) {
        originalMethod = class_getInstanceMethod(class, originalSelector);
    }
    method_exchangeImplementations(swizzledMethod, originalMethod);
}

@end


@implementation UITableView (Empty)

-(void)addHeardTarget:(id)target Action:(SEL)action{
    self.header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
}
-(void)addFooterTarget:(id)target Action:(SEL)action{
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
}

+ (void)load {
    [super load];
    [self hookClass:[self class] originalSelector:@selector(reloadData) swizzledSelector:@selector(customReloadData)];
}
- (void)customReloadData {
    [self customReloadData];
    [self refreshEmptyView];
}

@end


@implementation UICollectionView (Empty)

-(void)addHeardTarget:(id)target Action:(SEL)action{
    self.header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
}
-(void)addFooterTarget:(id)target Action:(SEL)action{
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
}

+ (void)load {
    [super load];
    [self hookClass:[self class] originalSelector:@selector(reloadData) swizzledSelector:@selector(customReloadData)];
}

- (void)customReloadData {
    [self customReloadData];
    [self refreshEmptyView];
}

@end
