//
//  BaseTableViewController.m
//  EpochStore
//
//  Created by K哥 on 2019/7/11.
//  Copyright © 2019 K哥. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BaseTableViewController

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
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

 
- (UIView *)setupEmptyView:(UIImage * _Nullable)image title:(NSString *)title {
    
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
 
- (UIView *)setupEmptyViewWithFrame:(CGRect)bounds title:(NSString *)title {
    
    UIView *backView = [[UIView alloc] initWithFrame:bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 201, 134.5)];
    [backView addSubview:imageView];
    if ([title containsString:@"聊天"]) {
        imageView.image = [UIImage imageNamed:@"暂无聊天"];
    }else {
        imageView.image = [UIImage imageNamed:@"暂无比赛"];
    }
    imageView.centerX = backView.centerX;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+5, kScreenWidth, 25)];
    self.remindLabel = label;
    label.text = title;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    label.textColor = SRGB(102);
    label.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadGetData)];
    [backView addGestureRecognizer:tap];
    return backView;
}

- (void)reloadGetData {
    
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
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, xBottomHeight + 10, 0);
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        //设置自动计算行号模式
        _tableView.rowHeight = UITableViewAutomaticDimension;
        //设置预估行高
        _tableView.estimatedRowHeight = 200;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
   
    }
    return _tableView;
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (void)dealloc {
    KKLog(@"---:%@被销毁了",NSStringFromClass([self class]));
}
@end
