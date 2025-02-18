//
//  SNExampleMoreListViewController.m
//  SportNews
//
//  Created by 根哥 on 2021/3/15.
//

#import "SNExampleMoreListViewController.h"
#import "SNExampleBaseTableViewCell.h"
#import "SNExampleMoreListCell.h"
#import "SNExampleBaseHeaderView.h"

@interface SNExampleMoreListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong , nonatomic)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray     *dataSource;

@end

@implementation SNExampleMoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
     
}
 
- (void)setupSubviews{
    if (self.model.rankType == SNBasketRankTypeInjuries) {
        self.titleString = self.model.team_name;
    }else {
        self.titleString = self.model.name;
    }
    [self.view addSubview:self.tableView];
    
}
#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       
    SNExampleBaseModel *model = self.model.list[indexPath.row];
    model.indexPath = indexPath;
    model.reuseCellId = self.model.reuseCellType;
    model.rankType = self.model.rankType;
    SNExampleBaseTableViewCell *cell = [SNExampleBaseTableViewCell cellWithTableView:tableView exampleModel:model];
    [cell configureModelData:model];
    
    return cell;

}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SNExampleBaseHeaderView *headerView = [SNExampleBaseHeaderView headerWithTableView:tableView exampleModel:self.model];
    headerView.model = self.model;
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 42;
}


- (UITableView *)tableView {
    if (!_tableView) {
        //44是page的高度
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, kScreenWidth, kScreenHeight - NavHeight)];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, xBottomHeight, 0);
        _tableView.backgroundColor = SRGB(248);
//        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //设置自动计算行号模式
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = 0;
        //设置预估行高
        _tableView.estimatedRowHeight = 40;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return _tableView;
}


@end
