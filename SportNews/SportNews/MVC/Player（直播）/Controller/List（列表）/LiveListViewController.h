//
//  LiveListViewController.h
//  SportNews
//
//  Created by K哥 on 2021/1/9.
//

#import <UIKit/UIKit.h>
#import "LiveListCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface LiveListViewController : BaseGestureViewController

@property(nonatomic, strong) NSArray<LiveListCategoryModel *> *categoryListModelArray;

@property(nonatomic, strong) LiveListCategoryModel *categoryModel;
@property(nonatomic, assign) NSInteger pn;
@property(nonatomic, assign) NSInteger ps;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSString *startTime;


- (instancetype)initWithCategoryModel:(LiveListCategoryModel *)model type:(NSInteger)type isHot:(BOOL)isHot;

- (void)reloadDatas;

- (void)getDatas:(BOOL)isRefresh;

- (void)getCalendarData;

- (void)setupSubViews;
@end

NS_ASSUME_NONNULL_END
