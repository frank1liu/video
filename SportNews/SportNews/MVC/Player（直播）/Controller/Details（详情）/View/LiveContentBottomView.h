//
//  LiveContentBottomView.h
//  SportNews
//
//  Created by K哥 on 2021/2/22.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNFootBallResult.h"
#import "SNBasketBallResult.h"
#import "SNShimmerLabelView.h"

@interface LiveContentBottomView : BaseXibView

@property (nonatomic, copy) void(^fblTap)(LiveCartoonModel *model);

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreWidth;

@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
 
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusRight;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dianLabel;

@property (weak, nonatomic) IBOutlet UILabel *hTeamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hTeamImageView;

@property (weak, nonatomic) IBOutlet UILabel *aTeamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aTeamImageView;


@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet SNShimmerLabelView *shimmerScoreView;
 
@property(nonatomic, strong) LiveListModel *model;

@property(nonatomic, strong) LiveCartoonModel *cartoonModel;

//直播
@property(nonatomic, strong) SNFootBallResult *resultFootObj;

//直播
@property(nonatomic, strong) SNBasketBallResult *resultBasketObj;

@property (weak, nonatomic) IBOutlet UIView *downloadBaseView;
@property (weak, nonatomic) IBOutlet UIScrollView *liveBtnsScrollView;

@property (nonatomic , copy) NSString *scoreStr;
@property(nonatomic, assign) NSInteger footStatus;
@property(nonatomic, assign) NSInteger basketStatus;
@property (nonatomic , copy) NSString *timeStr;
  
- (void)loadAnimate;
 

@end

