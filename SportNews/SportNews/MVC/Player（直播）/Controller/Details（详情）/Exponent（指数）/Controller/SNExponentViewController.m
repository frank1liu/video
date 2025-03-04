//
//  SNExponentViewController.m
//  SportNews
//
//  Created by kkk on 2021/2/5.
//

#import "SNExponentViewController.h"
#import "SportNews-Swift.h"
#import <Masonry/Masonry.h>
#import "TalkBaseViewController.h"

@interface SNExponentViewController ()

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) ExponentCategoriesView *categoriesView;

@property (nonatomic, strong) SNExponentModel *exponentModel;

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UIView *tBackgroundView;
@property(nonatomic, strong) UIImageView *tbImage;
@property(nonatomic, strong) UILabel *tbLabel;
@property(nonatomic, strong) UITapGestureRecognizer *tbTap;
@property (nonatomic, strong) UIView *talkBaseView;
@property (nonatomic, strong) TalkBaseViewController *talkBaseVC;

@end

@implementation SNExponentViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.playStatus == PlayingStatusLive) {
        self.talkBaseView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, kScreenHeight-kContentHeight-41-kBottomHeight)];
    } else {
        self.talkBaseView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, kScreenHeight-kContentHeight-41)];
    }
    
    self.talkBaseView.backgroundColor = UIColor.clearColor;

    self.talkBaseVC = [[TalkBaseViewController alloc]initWithNibName:@"TalkBaseViewController" bundle:nil];

    self.view.backgroundColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:1];
    
    self.categoriesView = [[ExponentCategoriesView alloc] initWithFrame:CGRectZero categories: [self.model.type isEqualToNumber:@1] ? @[@"让球", @"胜平负", @"总进球", @"角球"] : @[@"让分", @"胜负", @"总分"]];
    [self.view addSubview:self.categoriesView];
    [self.categoriesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(10);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.categoriesView.choiceCategoriesIndex = ^(NSInteger index) {
        AsianIndexView *current = [weakSelf.view viewWithTag:11011];
        NSMutableArray *arr = [NSMutableArray new];
        // 足球
        if (index == 0) {
            for (NSDictionary *dic in weakSelf.exponentModel.yazhi) {
                [arr addObject:[SNExponentContent mj_objectWithKeyValues:dic]];
            }
            current.models = arr;
        } else if (index == 1) {
            for (NSDictionary *dic in weakSelf.exponentModel.ouzhi) {
                [arr addObject:[SNExponentContent mj_objectWithKeyValues:dic]];
            }
            current.models = arr;
        } else if (index == 2) {
            for (NSDictionary *dic in weakSelf.exponentModel.daxiao) {
                [arr addObject:[SNExponentContent mj_objectWithKeyValues:dic]];
            }
            current.models = arr;
        } else {
            for (NSDictionary *dic in weakSelf.exponentModel.jiaoqiu) {
                [arr addObject:[SNExponentContent mj_objectWithKeyValues:dic]];
            }
            current.models = arr;
        }
//        if ([weakSelf.model.type isEqual:@1]) {
//            // 足球
//            if (index == 0) {
//                AsianIndexView *ai = [AsianIndexView new];
//                [weakSelf changeShow:ai];
//            } else if (index == 1) {
//                EuroIndexView *ei = [EuroIndexView new];
//                [weakSelf changeShow:ei];
//            } else {
//                EuroIndexView *ei = [EuroIndexView new];
//                [weakSelf changeShow:ei];
//            }
//        } else  {
//            // 篮球
//            if (index == 0) {
//                AsianIndexView *ai = [AsianIndexView new];
//                [weakSelf changeShow:ai];
//            } else if (index == 2) {
//                EuroIndexView *ei = [EuroIndexView new];
//                [weakSelf changeShow:ei];
//            } else {
//                EuroIndexView *ei = [EuroIndexView new];
//                [weakSelf changeShow:ei];
//            }
//        }
    };
    AsianIndexView *ai = [AsianIndexView new];
    ai.jump = ^(NSInteger ID){
        weakSelf.jumpDetail(weakSelf.categoriesView.current, ID);
    };
    [self changeShow:ai];
    self.categoriesView.choiceCategoriesIndex(0);
    [self.categoriesView setHidden:true];
    
    [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"数据加载中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadNoData];
    });

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTalkBaseView) name:@"ShowTalkBaseView" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTalkBaseView) name:@"HideTalkBaseView" object:nil];
}

- (void)showTalkBaseView {
    [self.view addSubview:self.talkBaseView];
    self.talkBaseView.backgroundColor = UIColor.yellowColor;
    [self addChildViewController:self.talkBaseVC];
    self.talkBaseVC.view.frame = self.talkBaseView.bounds;
    [self.talkBaseView addSubview:self.talkBaseVC.view];
    [self.view bringSubviewToFront:self.talkBaseView];
}

- (void)hideTalkBaseView {
    [self.talkBaseVC willMoveToParentViewController:nil];
    [self.talkBaseVC.view removeFromSuperview];
    [self.talkBaseVC removeFromParentViewController];
    self.talkBaseView.backgroundColor = UIColor.clearColor;
    [self.talkBaseView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!(self.exponentModel.daxiao.count == 0 &&
        self.exponentModel.jiaoqiu.count == 0 &&
        self.exponentModel.yazhi.count == 0 &&
        self.exponentModel.ouzhi.count == 0)) {
        [self.categoriesView setHidden:false];
        [self hideShow];
        self.categoriesView.choiceCategoriesIndex(self.categoriesView.current);
        return;
    }
    [self hideShow];
}

- (void)hideShow {
    UIView *current = [self.view viewWithTag:11011];
    [current setHidden:self.categoriesView.isHidden];
    [self.tBackgroundView setHidden:!self.categoriesView.isHidden];
}

- (void)changeShow:(UIView *)next {
    UIView *current = [self.view viewWithTag:11011];
    next.tag = 11011;
    [current removeFromSuperview];
    [self.view addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoriesView.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(12.5);
        make.right.equalTo(self.view).offset(-12.5);
        make.bottom.equalTo(self.view);
    }];
}

- (void)setupEmptyViewWithFrame:(CGRect)bounds title:(NSString *)title {
    if (!self.tBackgroundView) {
        self.tBackgroundView = [[UIView alloc] initWithFrame:bounds];
        [self.view addSubview:self.tBackgroundView];
    }
    if (!self.tbImage) {
        self.tbImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 201, 134.5)];
        [self.tBackgroundView addSubview:self.tbImage];
        self.tbImage.image = [UIImage imageNamed:@"暂无比赛"];
        self.tbImage.centerX = self.tBackgroundView.centerX;
    }
    if (!self.tbLabel) {
        self.tbLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tbImage.frame)+5, kScreenWidth, 25)];
        self.tbLabel.text = title;
        self.tbLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
        self.tbLabel.textColor = SRGB(102);
        self.tbLabel.textAlignment = NSTextAlignmentCenter;
        [self.tBackgroundView addSubview:self.tbLabel];
    } else {
        self.tbLabel.text = title;
    }
    if (!self.tbTap) {
        self.tbTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadDatas)];
    }
    
    if ([title containsString:@"加载失败"]) {
        [self.tBackgroundView addGestureRecognizer:self.tbTap];
    } else {
        [self.tBackgroundView removeGestureRecognizer:self.tbTap];
    }
}

- (void)reloadDatas {
    if (self.reloadDataBlock) {
        [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"数据加载中..."];
        self.reloadDataBlock();
    }
}

- (void)loadNoData {
    [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"暂无数据"];
}

- (void)loadDataFailure {
    [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"加载失败，点击重新加载"];
}

- (void)setupExponentModel:(SNExponentModel *)exponentModel {
    self.exponentModel = exponentModel;
    if (self.exponentModel.daxiao.count == 0 &&
        self.exponentModel.jiaoqiu.count == 0 &&
        self.exponentModel.yazhi.count == 0 &&
        self.exponentModel.ouzhi.count == 0) {
        [self loadNoData];
    } else {
        [self.categoriesView setHidden:false];
        [self hideShow];
        self.categoriesView.choiceCategoriesIndex(self.categoriesView.current);
    }
}
 
#pragma mark - JXPagerViewListViewDelegate
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

@end
