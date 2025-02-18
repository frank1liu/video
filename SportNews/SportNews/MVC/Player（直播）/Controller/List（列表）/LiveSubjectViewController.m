//
//  LiveSubjectViewController.m
//  SportNews
//
//  Created by pangchong on 2020/12/3.
//

#import "LiveSubjectViewController.h"
#import "LiveListViewController.h"
#import "OtherLiveListVC.h"

@interface LiveSubjectViewController ()

@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, strong) NSMutableDictionary *allVcDic;

@property(nonatomic, strong) LiveListViewController *currentVc;
@end

@implementation LiveSubjectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allVcDic = [NSMutableDictionary dictionary];
    
    for (UIView *subView in self.navView.subviews) {
        [subView removeFromSuperview];
    }
    self.myCategoryView.titles = self.titles;
    self.myCategoryView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
    self.myCategoryView.titleFont = UIFontMake(14);
    self.myCategoryView.titleSelectedFont = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    self.myCategoryView.titleColor = SRGB(80);
    self.myCategoryView.titleSelectedColor = Blue_Color;
    self.myCategoryView.titleColorGradientEnabled = YES;
    
    //背部颜色
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = 28;
    backgroundView.indicatorWidthIncrement = 20;
    backgroundView.indicatorCornerRadius = 5;
    if (self.type == 3) {
        backgroundView.alpha = 0.0;
    } else {
        backgroundView.alpha = 0.2;
    }
    backgroundView.indicatorColor = Blue_Color;
    self.myCategoryView.indicators = @[backgroundView];
    
    //下划线
    //    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    //    lineView.indicatorColor = Blue_Color;
    //    lineView.verticalMargin = 3;
    //    lineView.indicatorHeight = 3;
    //    self.myCategoryView.indicators = @[lineView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBtnAction) name:ListRefreshBtnAction object:nil];
}

- (void)refreshBtnAction {
    [self.currentVc reloadDatas];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.type == 3) {
        self.myCategoryView.frame = CGRectMake(0, 0, 0, 0);
        self.listContainerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kScreenHeight-NavHeight);
    } else {
        self.myCategoryView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        self.listContainerView.frame = CGRectMake(0, 40, SCREEN_WIDTH, kScreenHeight-NavHeight-40);
    }
}


- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    LiveListCategoryModel *categoryModel = self.categoryListModelArray[index];
    NSString *key = [categoryModel isKindOfClass:[LiveListCategoryModel class]] ? [NSString stringWithFormat:@"%@-%ld",categoryModel.ID, (long)self.type]:[NSString stringWithFormat:@"%ld",(long)self.type];
//    if (self.type == 3) {
//        key = [categoryModel isKindOfClass:[LiveListCategoryModel class]] ? [NSString stringWithFormat:@"%@-%ld",categoryModel.type, (long)self.type]:[NSString stringWithFormat:@"%ld",(long)self.type];
//    }
    LiveListViewController *list = self.allVcDic[key];
    [list reloadDatas];
    self.currentVc = list;
}


- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    LiveListCategoryModel *categoryModel = self.categoryListModelArray[index];
    NSString *key = [categoryModel isKindOfClass:[LiveListCategoryModel class]] ? [NSString stringWithFormat:@"%@-%ld",categoryModel.ID, (long)self.type]:[NSString stringWithFormat:@"%ld",(long)self.type];
//    if (self.type == 3) {
//        key = [categoryModel isKindOfClass:[LiveListCategoryModel class]] ? [NSString stringWithFormat:@"%@-%ld",categoryModel.type, (long)self.type]:[NSString stringWithFormat:@"%ld",(long)self.type];
//    }
    LiveListViewController *list = self.allVcDic[key];
    [list reloadDatas];
    self.currentVc = list;
}

#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    LiveListCategoryModel *categoryModel = self.categoryListModelArray[index];
    LiveListViewController *list = [[LiveListViewController alloc] initWithCategoryModel:categoryModel type:self.type isHot:self.type == -1 ? YES : NO];
    NSString *key = [categoryModel isKindOfClass:[LiveListCategoryModel class]] ? [NSString stringWithFormat:@"%@-%ld",categoryModel.ID, (long)self.type]:[NSString stringWithFormat:@"%ld",(long)self.type];
//    if (self.type == 3) {
//        list = [[OtherLiveListVC alloc] initWithCategoryModel:categoryModel type:self.type isHot:self.type == -1 ? YES : NO];
//        list.categoryListModelArray = self.categoryListModelArray;
//        key = [categoryModel isKindOfClass:[LiveListCategoryModel class]] ? [NSString stringWithFormat:@"%@-%ld",categoryModel.type, (long)self.type]:[NSString stringWithFormat:@"%ld",(long)self.type];
//    }
    [self.allVcDic setValue:list forKey:[NSString stringWithFormat:@"%@",key]];
    self.currentVc = list;
    return list;
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}




@end
