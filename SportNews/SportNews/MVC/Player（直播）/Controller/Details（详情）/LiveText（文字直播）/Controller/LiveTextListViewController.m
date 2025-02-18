//
//  LiveTextListViewController.m
//  SportNews
//
//  Created by kkk on 2021/1/16.
//

#import "LiveTextListViewController.h"
#import "SNLiveFootBallHeaderView.h"
#import "SNLiveBasketBallHeaderView.h"
#import "SNLiveFootBallTableViewCell.h"
#import "SNLiveBasketBallTableViewCell.h"
#import "SNLiveFootBallSectionHeaderView.h"
#import "SNLiveBasketBallSectionHeaderView.h"
#import "SNFootBallImportantEventsCell.h"

@interface LiveTextListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) UITableView *tableView;

//数据信息
@property (nonatomic, strong) NSMutableArray *datasArray;

@property (nonatomic, strong) SNLiveFootBallHeaderView *footHeaderView;

@property(nonatomic, strong) SNLiveFootBallSectionHeaderView *footSectionView;

@property(nonatomic, assign) NSInteger footTag;

@property (nonatomic, strong) SNLiveBasketBallHeaderView *basketHeaderView;
@property (nonatomic, strong) UIView *basketBackHeaderView;

@property (nonatomic, assign) NSInteger       section; //篮球的小节
@property (nonatomic, strong)SNLiveBasketBallSectionHeaderView *basketSectionHeader;

@property(nonatomic, strong) UIView *tBackgroundView;

@end

@implementation LiveTextListViewController
static NSString *reuseIndentifier = @"reuseIndentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self prepareHeader];
}

- (void)setupSubViews {
    
    self.footTag = 0;
    CGFloat height = 0;
    if (self.playStatus == PlayingStatusAnimate) {
        height = kScreenHeight-kContentHeight-41;
    }else if (self.playStatus == PlayingStatusLive) {
        height = kScreenHeight-kContentHeight-41-kBottomHeight;
    }else {
        height = kScreenHeight-NavHeight-41;
    }
    CGRect extractedExpr = CGRectMake(0, 0, kScreenWidth, height);
    self.tableView.frame = extractedExpr;
    self.tableView.backgroundColor = SRGB(250);
    [self.view addSubview:self.tableView];
    if (self.model.type.intValue == 1) {
        if (self.resultFootObj == nil) {
            self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"文字直播加载中..."];
            [self.tableView addSubview:self.tBackgroundView];
        }
    }else if (self.model.type.intValue == 2) {
        if (self.resultBasketObj == nil) {
            self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"文字直播加载中..."];
            [self.tableView addSubview:self.tBackgroundView];
        }
    }
    
    if (self.model.type.integerValue == 1) {
        //足球
        self.tableView.tableHeaderView = self.footHeaderView;
        self.footHeaderView.teamLabelA.text = self.model.hteam_name;
        self.footHeaderView.teamLabelB.text = self.model.ateam_name;
    }else {
        self.tableView.tableHeaderView = self.basketBackHeaderView;
        self.basketHeaderView.hNameLabel.text = self.model.ateam_name;
        self.basketHeaderView.gNameLabel.text = self.model.hteam_name;
    }

}

- (void)prepareHeader {
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadDatas)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];
     
}

- (void)reloadDatas {
    if (self.reloadDataBlock) {
        self.reloadDataBlock();
    }
}
- (UIView *)setupEmptyViewWithFrame:(CGRect)bounds title:(NSString *)title {
    if (self.tBackgroundView.superview) {
        [self.tBackgroundView removeFromSuperview];
    }
    UIView *backView = [[UIView alloc] initWithFrame:bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 201, 134.5)];
    [backView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"暂无比赛"];
    imageView.centerX = backView.centerX;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+5, kScreenWidth, 25)];
    label.text = title;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    label.textColor = SRGB(102);
    label.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label];
    if ([title containsString:@"加载失败"]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadData)];
        [backView addGestureRecognizer:tap];
    }
    return backView;
}
 
- (void)reloadData {
    self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"文字直播加载中..."];
    [self.tableView addSubview:self.tBackgroundView];
    if (self.reloadDataBlock) {
        self.reloadDataBlock();
    }
}
 

- (void)updateScrollViewHeight:(PlayingStatus)playStatus {
    _playStatus = playStatus;
   if (playStatus == PlayingStatusAnimate) {
       self.tableView.height = kScreenHeight-kContentHeight-41;
   }else if (playStatus == PlayingStatusLive) {
       self.tableView.height = kScreenHeight-kContentHeight-41-kBottomHeight;
   }else {
       self.tableView.height = kScreenHeight-NavHeight-41;
   }
}

- (void)loadDataFailure {
    if ((self.model.type.intValue == 1 && self.resultFootObj == nil) ||
        (self.model.type.intValue == 2 && self.resultBasketObj == nil)) {
        self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"加载失败，点击重新加载"];
        [self.tableView addSubview:self.tBackgroundView];
    }
}

//足球数据
- (void)setResultFootObj:(SNFootBallResult *)resultFootObj {
    _resultFootObj = resultFootObj;
    if (resultFootObj.score.count == 0 && resultFootObj.stats.count == 0 && self.resultFootObj.tlive.count == 0) {
        self.footHeaderView.hidden = YES;
        self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 120, kScreenWidth, 180) title:@"暂无数据"];
        [self.tableView addSubview:self.tBackgroundView];
        return;
    }
    self.footHeaderView.dataSource = resultFootObj.stats;
    if(self.footTag == 0) {
        NSArray *resultLive = [self.resultFootObj.tlive reverseObjectEnumerator].allObjects;
        self.datasArray = [resultLive mutableCopy];
        if (self.datasArray.count == 0) {
            self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 500, kScreenWidth, 180) title:@"暂无文字直播中"];
            [self.tableView addSubview:self.tBackgroundView];
        }else {
            if (self.tBackgroundView.superview) {
                [self.tBackgroundView removeFromSuperview];
            }
        }
    }else{
        NSArray *resultLive = self.resultFootObj.incidents;
        self.datasArray = [resultLive mutableCopy];
        if (self.datasArray.count == 0) {
            self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 500, kScreenWidth, 180) title:@"暂无重要事件"];
            [self.tableView addSubview:self.tBackgroundView];
        }else {
            SNFootBallIncidentsModel *shaoziModel = [[SNFootBallIncidentsModel alloc] init];
            shaoziModel.position = @"4";
            SNFootBallIncidentsModel *timeModel = [[SNFootBallIncidentsModel alloc] init];
            timeModel.position = @"3";
            [self.datasArray insertObject:shaoziModel atIndex:0];
            [self.datasArray addObject:timeModel];
            if (self.tBackgroundView.superview) {
                [self.tBackgroundView removeFromSuperview];
            }
        }
    } 
    self.footHeaderView.hidden = NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

//篮球数据
- (void)setResultBasketObj:(SNBasketBallResult *)resultBasketObj {
    _resultBasketObj = resultBasketObj;
    self.basketHeaderView.resultBasketObj = resultBasketObj;
    [self.datasArray removeAllObjects];
    [self.datasArray addObjectsFromArray:resultBasketObj.tlive];
    self.section = self.datasArray.count > 0? self.datasArray.count - 1 : 0;
    [self.basketSectionHeader reloadDataWithModel:resultBasketObj];
    if (self.tBackgroundView.superview) {
        [self.tBackgroundView removeFromSuperview];
    }
    self.basketBackHeaderView.hidden = NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
}

//篮球 切换 第一二三四 节数据 tag = 1234
- (void)basketBallChangeDataWithTag:(NSInteger)tag {
    if (self.section == tag) {
        return;
    }
    self.section = tag;
    [self.tableView reloadData];
}

//足球切换文字直播和重要事件 0，1
- (void)footBallChangeDataWithTag:(NSInteger)tag {
    if (self.footTag == tag) {
        return;
    }
    self.footTag = tag;
    if(tag == 0){
        NSArray *resultLive = [self.resultFootObj.tlive reverseObjectEnumerator].allObjects;
        self.datasArray = [resultLive mutableCopy];
        if (self.datasArray.count == 0) {
            self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 500, kScreenWidth, 180) title:@"暂无文字直播"];
            [self.tableView addSubview:self.tBackgroundView];
        }else {
            if (self.tBackgroundView.superview) {
                [self.tBackgroundView removeFromSuperview];
            }
        }
    }else{
        NSArray *resultLive = self.resultFootObj.incidents;
        self.datasArray = [resultLive mutableCopy];
        if (self.datasArray.count == 0) {
            self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 500, kScreenWidth, 180) title:@"暂无重要事件"];
            [self.tableView addSubview:self.tBackgroundView];
        }else {
            SNFootBallIncidentsModel *shaoziModel = [[SNFootBallIncidentsModel alloc] init];
            shaoziModel.position = @"4";
            SNFootBallIncidentsModel *timeModel = [[SNFootBallIncidentsModel alloc] init];
            timeModel.position = @"3";
            [self.datasArray insertObject:shaoziModel atIndex:0];
            [self.datasArray addObject:timeModel];
            if (self.tBackgroundView.superview) {
                [self.tBackgroundView removeFromSuperview];
            }
        }
    }
 
    [self.tableView reloadData];
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model.type.integerValue == 1) {
        return self.datasArray.count;
    }else {
        if (self.datasArray.count > 0) {
            NSArray *tempArray = [self.datasArray objectAtIndex:self.section];;
            return tempArray.count;
        }else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.type.integerValue == 1) {
        //足球
        if (self.footTag == 0) {
            SNFootBallTextLiveModel *tModel = [self.datasArray objectAtIndex:indexPath.row];
            SNLiveFootBallTableViewCell *cell = [SNLiveFootBallTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = 0;
            cell.tModel = tModel;
            return cell;
        }else{
            SNFootBallIncidentsModel *incidentModel = [self.datasArray objectAtIndex:indexPath.row];
            FBImportantEventsCellType cellType = [incidentModel.position integerValue];
            SNFootBallImportantEventsCell *cell = [[SNFootBallImportantEventsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier cellType:cellType];
            cell.resultFootObj = self.resultFootObj;
            cell.model = incidentModel;
            if (indexPath.row == 0) {
                cell.position = 1;
            }else if (indexPath.row == self.datasArray.count - 1) {
                cell.position = 2;
            }else {
                cell.position = 0;
            }
            return cell;
            
        }
        
    }else {
        SNLiveBasketBallTableViewCell *cell = [SNLiveBasketBallTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = 0;
        NSArray *tempArray = [self.datasArray objectAtIndex:self.section];;
        SNBasketBallTliveModel *model = tempArray[indexPath.row];
        model.section = [NSString stringWithFormat:@"%ld",self.section+1];
        cell.model = self.model;
        cell.tLiveModel = model;
        [cell cellIsfirstOne:(indexPath.row == 0)?YES:NO]; 
        [cell cellIsLastOne:(indexPath.row == tempArray.count - 1)?YES:NO];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
    if (self.model.type.integerValue == 1) {
        //足球
        if (self.footTag == 0) {
            SNFootBallTextLiveModel *tModel = [self.datasArray objectAtIndex:indexPath.row];
            if (tModel.isNew) {
                CGFloat labelH = [self evaluteHeight:Font(14) withText:tModel.data width:kScreenWidth - 117];
                return labelH+33;
            }
            CGFloat labelH = [self evaluteHeight:Font(14) withText:tModel.data width:kScreenWidth - 82];
            return labelH+33;
        }else{
            SNFootBallIncidentsModel *incidentModel  = [self.datasArray objectAtIndex:indexPath.row];
            return incidentModel.cellHeight;
        }
  
    }else {
        //需要显示 球队logo contentLabelLeft = 42.5 不要 = 12.5
        NSArray *tempArray = [self.datasArray objectAtIndex:self.section];;
        SNBasketBallTliveModel *model = tempArray[indexPath.row];
        CGFloat labelH = [self evaluteHeight:Font(12) withText:model.text width:model.t_type == 0? kScreenWidth - 82:kScreenWidth - 112];
        return labelH+60;
    }
}
 
- (CGFloat)evaluteHeight:(UIFont *)font withText:text width:(CGFloat)width {
    NSDictionary *textAtt = @{NSFontAttributeName : font};
    CGSize evaluteLabelSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGFloat evaluteLabelSizeH = evaluteLabelSize.height + 2;
    return evaluteLabelSizeH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section { 
    if (self.model.type.integerValue == 1) {
        //足球
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        SNLiveFootBallSectionHeaderView *footSectionView = [[SNLiveFootBallSectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        WeakSelf
        footSectionView.footHeaderClickWithTag = ^(NSInteger tag) {
            [weakSelf footBallChangeDataWithTag:tag];
        };
        [backView addSubview:footSectionView];
        footSectionView.footTag = self.footTag;
        return backView;
    }else {
        return self.basketSectionHeader;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.model.type.integerValue == 1) {
        //足球
        if (self.resultFootObj) {
            return 50;
        }
        return 0;
    }else {
        if (self.resultBasketObj) {
            return 86;
        }
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y > 0) {
        self.scrollCallback(scrollView);
    }
}


- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}
 
#pragma mark -- getter 懒加载
- (NSMutableArray *)datasArray {
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}
 
- (SNLiveFootBallHeaderView *)footHeaderView {
    if (!_footHeaderView) {
        _footHeaderView = [[SNLiveFootBallHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 280)];
        _footHeaderView.hidden = YES;
        WeakSelf
        _footHeaderView.checkMore = ^{
            weakSelf.footHeaderView.height = 400;
            weakSelf.tableView.tableHeaderView = weakSelf.footHeaderView;
        };
    }
    return _footHeaderView;
}

- (SNLiveFootBallSectionHeaderView *)footSectionView {
    if (!_footSectionView) {
        _footSectionView = [[SNLiveFootBallSectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        WeakSelf
        _footSectionView.footHeaderClickWithTag = ^(NSInteger tag) {
            [weakSelf footBallChangeDataWithTag:tag];
        };
    }
    return _footSectionView;
}

- (SNLiveBasketBallHeaderView *)basketHeaderView {
    if (!_basketHeaderView) {
        _basketHeaderView = [[SNLiveBasketBallHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 290)];
    }
    return _basketHeaderView;
}

- (UIView *)basketBackHeaderView {
    if (!_basketBackHeaderView) {
        _basketBackHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 290)];
        [_basketBackHeaderView addSubview:self.basketHeaderView];
        _basketBackHeaderView.hidden = YES;
    }
    return _basketBackHeaderView;
}

- (SNLiveBasketBallSectionHeaderView *)basketSectionHeader{
    if (!_basketSectionHeader) {
        _basketSectionHeader = [[SNLiveBasketBallSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 86) datasArray:self.datasArray];
        WeakSelf
        _basketSectionHeader.buttonClickWithTag = ^(NSInteger tag) {
            [weakSelf basketBallChangeDataWithTag:tag];
        };
    }
    return _basketSectionHeader;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        //44是page的高度
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor =UIColor.clearColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, xBottomHeight + 10, 0);
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //设置自动计算行号模式
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[SNFootBallImportantEventsCell class] forCellReuseIdentifier:@"SNFootBallImportantEventsCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SNLiveFootBallTableViewCell" bundle:nil] forCellReuseIdentifier:@"SNLiveFootBallTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SNLiveBasketBallTableViewCell" bundle:nil] forCellReuseIdentifier:@"SNLiveBasketBallTableViewCell"];
        //设置预估行高
        _tableView.estimatedRowHeight = 200;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}


@end
