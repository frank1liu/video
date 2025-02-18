//
//  BaseNavTableViewController.m
//  CIEX
//
//  Created by K哥 on 2019/9/23.
//  Copyright © 2019 K哥. All rights reserved.
//

#import "BaseNavTableViewController.h"

@interface BaseNavTableViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BaseNavTableViewController 

- (NSMutableArray *)datasArray {
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setOtherParam];
    
}

- (void)setOtherParam {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:view];
    self.view.backgroundColor = VCBackgroundColor;
    [self.view addSubview:self.navView];

}
 
//准备刷新控件--tableView
- (void)prepareHeader {
    
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];
     
}

//准备刷新控件--tableView
- (void)prepareFooter {
     
    MJRefreshAutoNormalFooter *Footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    Footer.hidden = YES;
    self.tableView.mj_footer = Footer;
    [self.tableView.mj_footer endRefreshing];
    
}

- (UIView *)setupEmptyView:(UIImage *)image title:(NSString *)title {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    UIImageView *imageView = [[UIImageView alloc] init];
    [backView addSubview:imageView];
    imageView.image = image;
    [imageView sizeToFit];
    imageView.center = backView.center;
    imageView.y = 208;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+5, kScreenWidth, 20)];
    label.text = title;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label];
    
    return backView;
}

- (UIView *)setupEmptyView {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [backView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"ic_nodatafound"];
    imageView.center = backView.center; 
    return backView;
}


//刷新方法
- (void)loadRefreshData {
}
- (void)loadMoreData {
}

//刷新列表
- (void)reloadData {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

/**
 *  设置tableView每个section的head和foot
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


- (UITableView *)tableView {
    
    if (!_tableView) {
        
        //44是page的高度
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableStyleGroup? UITableViewStyleGrouped:UITableViewStylePlain];
        _tableView.backgroundColor =UIColor.clearColor;
        _tableView.separatorStyle = 0;
        _tableView.separatorColor = UIColor.clearColor;
        //设置自动计算行号模式
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        //设置预估行高
        _tableView.estimatedRowHeight = 200;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

@end
