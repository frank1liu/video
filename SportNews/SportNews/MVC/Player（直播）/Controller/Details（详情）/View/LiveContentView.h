//
//  LiveContentView.h
//  SportNews
//
//  Created by K哥 on 2021/1/9.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNFootBallResult.h"
#import "SNBasketBallResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveContentView : BaseXibView
 

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *hTeamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hTeamImageView;
@property (weak, nonatomic) IBOutlet UILabel *hScoreLabel;


@property (weak, nonatomic) IBOutlet UILabel *aTeamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aTeamImageView;
@property (weak, nonatomic) IBOutlet UILabel *aScoreLabel;


@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel; 
@property (weak, nonatomic) IBOutlet UIView *animateBackView;
@property (weak, nonatomic) IBOutlet UILabel *animateLabel;
@property (weak, nonatomic) IBOutlet UIView *liveBackView;
@property (weak, nonatomic) IBOutlet UILabel *liveLabel;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;


@property (nonatomic , copy) void(^selectBlock)(NSInteger tag);

@property (nonatomic , copy) void(^countDownTime)(NSInteger time);

@property(nonatomic, strong) LiveListModel *model;

//直播
@property(nonatomic, strong) SNFootBallResult *resultFootObj;

//直播
@property(nonatomic, strong) SNBasketBallResult *resultBasketObj;

@property (nonatomic , copy) NSString *scoreStr;
@property(nonatomic, assign) NSInteger footStatus;
@property(nonatomic, assign) NSInteger basketStatus;

- (void)dellocTime;

@end

NS_ASSUME_NONNULL_END
