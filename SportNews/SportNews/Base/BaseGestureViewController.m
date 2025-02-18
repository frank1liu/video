//
//  BaseGestureViewController.m
//  EpochStore
//
//  Created by K哥 on 2019/7/24.
//  Copyright © 2019 K哥. All rights reserved.
//

#import "BaseGestureViewController.h"

@interface BaseGestureViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic , assign) BOOL isCanSideBack;

@property (nonatomic, strong) UITableView *tableView;
 
@end

@implementation BaseGestureViewController

- (NSMutableArray *)datasArray {
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}
 
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated]; 
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self forbiddenSideBack];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = VCBackgroundColor;
    [self.view addSubview:self.navView];

    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.navView.title = titleString;
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

- (UITableView *)tableView {
    
    if (!_tableView) {
        //44是page的高度
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor =UIColor.clearColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, xBottomHeight, 0);
        _tableView.separatorStyle = 0;
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

- (BaseNavView *)navView {
    if (!_navView) {
        _navView = [[BaseNavView alloc] init];
        _navView.hiddenLineView = YES;
    }
    return _navView;
}

//禁用手势
/**
 * 禁用边缘返回
 */
-(void)forbiddenSideBack{
    self.isCanSideBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
         self.navigationController.interactivePopGestureRecognizer.delegate = self;
        
    }
    
} 

/*
 恢复边缘返回
 */
- (void)resetSideBack {
    self.isCanSideBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
         self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanSideBack;
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}


@end
