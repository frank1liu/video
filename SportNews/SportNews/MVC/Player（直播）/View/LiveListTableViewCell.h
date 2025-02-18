//
//  LiveListTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/1/3.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNShimmerLabelView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveListTableViewCell : BaseXibTableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreWidth;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusRight;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dianLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
 
@property (weak, nonatomic) IBOutlet UILabel *banchangLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *banchangLabelRight;

@property (weak, nonatomic) IBOutlet UILabel *jiaoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *huoImageView;
  
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *hTeamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hTeamImageView;

@property (weak, nonatomic) IBOutlet UILabel *aTeamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aTeamImageView;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet SNShimmerLabelView *shimmerScoreView;

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIButton *zanWu;

@property(nonatomic, strong) LiveListModel *model;
@property (nonatomic, copy) void(^resolutionBtnClicked)(LiveCartoonModel *cartoonModel);

@end

NS_ASSUME_NONNULL_END
