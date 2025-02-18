//
//  SNYinLangRecordListViewController.m
//  SportNews
//
//  Created by kkk on 2021/5/13.
//

#import "SNYinLangRecordListViewController.h"
#import "SNYinLangHeaderView.h"
#import "SNYinLangListTableViewCell.h"

@interface SNYinLangRecordListViewController ()

@end

@implementation SNYinLangRecordListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupTableHeaderView];
}

- (void)setupTableView {
    
    self.titleString = @"音浪明细";
    self.view.backgroundColor = SRGB(248);
    self.tableView.frame = CGRectMake(0, NavHeight +116, kScreenWidth, kScreenHeight -NavHeight -116);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, xBottomHeight, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"SNYinLangListTableViewCell" bundle:nil] forCellReuseIdentifier:@"SNYinLangListTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupTableHeaderView {
    SNYinLangHeaderView *headerView = [[SNYinLangHeaderView alloc] initWithFrame:CGRectMake(0, NavHeight, kScreenWidth, 116)];
    [self.view addSubview:headerView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNYinLangListTableViewCell *cell = [SNYinLangListTableViewCell cellWithTableView:tableView];
    return cell;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87;
}

@end
