//
//  SNOtherLiveCollectionViewCell.h
//  SportNews
//
//  Created by kkk on 2021/5/6.
//

#import <UIKit/UIKit.h>
#import "SNOtherLiveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNOtherLiveCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *liveBackView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@property(nonatomic, strong) SNOtherLiveModel *model;
@property(nonatomic, strong) NSArray<LiveListCategoryModel *> *categoryListModelArray;

@property(nonatomic, assign) BOOL isAll;

@end

NS_ASSUME_NONNULL_END
