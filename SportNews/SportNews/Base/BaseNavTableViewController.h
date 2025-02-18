//
//  BaseNavTableViewController.h
//  CIEX
//
//  Created by K哥 on 2019/9/23.
//  Copyright © 2019 K哥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseNavTableViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,JXCategoryListContentViewDelegate>

@property (nonatomic , assign) BOOL tableStyleGroup;

@property (nonatomic, strong ,readonly) UITableView *tableView;

//数据信息
@property (nonatomic, strong) NSMutableArray *datasArray;
 
- (void)prepareHeader;

- (void)prepareFooter;
 
#pragma mark -- 刷新数据 -- tablView
- (void)loadRefreshData;
#pragma mark -- 加载更多 -- tablView
- (void)loadMoreData;

- (UIView *)setupEmptyView;

- (UIView *)setupEmptyView:(UIImage *)image title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
