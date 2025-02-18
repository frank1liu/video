//
//  SNLiveDetailVSCollectionViewCell.h
//  SportNews
//
//  Created by kkk on 2021/3/26.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNLiveDetailVSCollectionViewCell : UICollectionViewCell
 
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *hTeamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hTeamImageView;
@property (weak, nonatomic) IBOutlet UILabel *hScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *aTeamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aTeamImageView;
@property (weak, nonatomic) IBOutlet UILabel *aScoreLabel;
 
 
@property (weak, nonatomic) IBOutlet UIView *verLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verLineTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verLineBottom;


@property (weak, nonatomic) IBOutlet UIView *horLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horLineLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horLiveRight;


@property(nonatomic, strong) LiveListModel *model;



@end

NS_ASSUME_NONNULL_END
