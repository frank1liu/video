//
//  SNLiveFootBallTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/1/20.
//

#import <UIKit/UIKit.h>
#import "SNFootBallResult.h"

NS_ASSUME_NONNULL_BEGIN

@class SNFootBallTextLiveModel;

@interface SNLiveFootBallTableViewCell : BaseXibTableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelRight;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property(nonatomic, strong) SNFootBallTextLiveModel *tModel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;

@end

NS_ASSUME_NONNULL_END
