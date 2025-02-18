//
//  BaseTableViewController.h
//  EpochStore
//
//  Created by K哥 on 2019/7/11.
//  Copyright © 2019 K哥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,JXCategoryListContentViewDelegate>

@property (nonatomic , assign) BOOL tableStyleGroup;

@property (nonatomic, strong ,readonly) UITableView *tableView;

@property(nonatomic, strong) UILabel *remindLabel;
//数据信息
@property (nonatomic, strong) NSMutableArray *datasArray;
 
- (void)reloadGetData;

//设置空站位
- (UIView *)setupEmptyView:(UIImage * _Nullable)image title:(NSString *)title;


- (UIView *)setupEmptyViewWithFrame:(CGRect)bounds title:(NSString *)title;


@end

NS_ASSUME_NONNULL_END
