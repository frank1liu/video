//
//  BaseGestureViewController.h
//  EpochStore
//
//  Created by K哥 on 2019/7/24.
//  Copyright © 2019 K哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavView.h"
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseGestureViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, JXCategoryListContentViewDelegate>

@property (nonatomic, strong ,readonly) UITableView *tableView;

//数据信息
@property (nonatomic, strong) NSMutableArray *datasArray;
  
@property (nonatomic , strong) NSString  *titleString;

@property (nonatomic , strong) BaseNavView *navView;

@end

NS_ASSUME_NONNULL_END
