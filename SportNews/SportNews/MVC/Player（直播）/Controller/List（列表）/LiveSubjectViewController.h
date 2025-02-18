//
//  LiveSubjectViewController.h
//  SportNews
//
//  Created by pangchong on 2020/12/3.
//

#import "BaseNavTableViewController.h"
#import "LiveListCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveSubjectViewController : BaseCategoryTableVC <JXCategoryListContentViewDelegate>

@property(nonatomic, strong) NSArray<LiveListCategoryModel *> *categoryListModelArray;

@property(nonatomic, assign) NSInteger type;


@end

NS_ASSUME_NONNULL_END
