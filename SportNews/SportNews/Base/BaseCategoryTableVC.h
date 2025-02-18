//
//  BaseCategoryTableVC.h
//  SportNews
//
//  Created by pangchong on 2020/12/3.
//

#import "BaseNavTableViewController.h"
#import <JXCategoryView/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCategoryTableVC : BaseGestureViewController<JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) JXCategoryBaseView *categoryView;

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, assign) BOOL isNeedIndicatorPositionChangeItem;

- (JXCategoryBaseView *)preferredCategoryView;

- (CGFloat)preferredCategoryViewHeight;

@end

NS_ASSUME_NONNULL_END
