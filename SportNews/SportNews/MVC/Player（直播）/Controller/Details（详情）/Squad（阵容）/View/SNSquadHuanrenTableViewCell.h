//
//  SNSquadHuanrenTableViewCell.h
//  SportNews
//
//  Created by K哥 on 2021/2/26.
//

#import <UIKit/UIKit.h>
#import "SNSquadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNSquadHuanrenTableViewCell : BaseXibTableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *corBackView;

@property (weak, nonatomic) IBOutlet UILabel *hNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hNumWidth;
@property (weak, nonatomic) IBOutlet UIImageView *hIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *hNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *aNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aNumWidth;
@property (weak, nonatomic) IBOutlet UIImageView *aIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *aNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aScoreLabel;

@property (nonatomic , strong) SNSquadPersonInfoModel *personModel;
 

- (void)cellIsHomeTeam:(BOOL)home;

- (void)cellIsLastOne:(BOOL)last;

@end

NS_ASSUME_NONNULL_END
