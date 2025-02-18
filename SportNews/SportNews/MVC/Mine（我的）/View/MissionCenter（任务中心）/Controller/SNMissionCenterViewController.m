//
//  SNMissionCenterViewController.m
//  SportNews
//
//  Created by kkk on 2021/5/12.
//

#import "SNMissionCenterViewController.h"
#import "SNMissionCenterTableHeaderView.h"
#import "SNMissionCenterWatchTimeCell.h"
#import "SNMissionCenterTaskCell.h"
#import "SNYinLangRecordListViewController.h"

@interface SNMissionCenterViewController ()

@property(nonatomic, strong) UIView *backLayerView;
@property(nonatomic, strong) SNMissionCenterTableHeaderView *headerView;

@end

@implementation SNMissionCenterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
      
    [self setupNavView];
    
    [self setupTableView];
    
    [self setupTableHeaderView];
}
  
- (void)setupNavView {
    
    self.titleString = @"任务中心";
    [self.navView rightItemWithImageName:nil rightTitle:@"音浪明细" size:CGSizeZero target:self action:@selector(yinlangList)];
    [self.navView leftItemWithImageName:@"返回白" leftTitle:nil size:CGSizeMake(10, 25) target:self action:@selector(popViewBack)];
    [self.navView setHiddenBackImage:NO];
    self.navView.currentStyle = NavStateStyleLight;
    
    CAGradientLayer* gradinentlayer=[CAGradientLayer layer];
    gradinentlayer.colors=@[(__bridge id)RGB(25, 171, 245).CGColor,(__bridge id)RGB(69, 224, 154).CGColor];
    gradinentlayer.locations = @[@0.0,@1.0];
    gradinentlayer.startPoint = CGPointMake(0, 0.5);
    gradinentlayer.endPoint = CGPointMake(1, 0.5);
    gradinentlayer.frame = CGRectMake(0, 0, kScreenWidth, NavHeight);
    [self.navView.backImageView.layer addSublayer:gradinentlayer];
    
    
}

- (void)setupTableView {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, kScreenWidth, kScreenHeight-NavHeight-xBottomHeight)];
    self.backLayerView = backView;
    CAGradientLayer* gradinentlayer=[CAGradientLayer layer];
    gradinentlayer.colors=@[(__bridge id)RGB(25, 171, 245).CGColor,(__bridge id)RGB(69, 224, 154).CGColor];
    gradinentlayer.locations = @[@0.0,@1.0];
    gradinentlayer.startPoint = CGPointMake(0, 0.5);
    gradinentlayer.endPoint = CGPointMake(1, 0.5);
    gradinentlayer.frame = backView.bounds;
    [self.view addSubview:backView];
    [backView.layer addSublayer:gradinentlayer];
    
    self.tableView.frame = CGRectMake(0, NavHeight, kScreenWidth, kScreenHeight-NavHeight);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, xBottomHeight, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"SNMissionCenterWatchTimeCell" bundle:nil] forCellReuseIdentifier:@"SNMissionCenterWatchTimeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SNMissionCenterTaskCell" bundle:nil] forCellReuseIdentifier:@"SNMissionCenterTaskCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = SRGB(248);
}

- (void)setupTableHeaderView {
    SNMissionCenterTableHeaderView *headerView = [[SNMissionCenterTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 109+((kScreenWidth - 100)/4*91/69*2+ 44+12+12)+12+(kScreenWidth-40)*65/335+12)];
    headerView.backgroundColor = SRGB(248);
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
}


- (void)popViewBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)yinlangList {
    SNYinLangRecordListViewController *VC = [[SNYinLangRecordListViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SNMissionCenterWatchTimeCell *cell = [SNMissionCenterWatchTimeCell cellWithTableView:tableView];
        [cell setupTime:31];
        return cell;
    }else {
        SNMissionCenterTaskCell *cell = [SNMissionCenterTaskCell cellWithTableView:tableView];
        cell.indexPath = indexPath;
        return cell;
    }
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 145;
    }
    return 160;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    self.backLayerView.hidden = y > 0? YES:NO;
    self.tableView.backgroundColor = y > 0? SRGB(248):UIColor.clearColor;
}

@end
