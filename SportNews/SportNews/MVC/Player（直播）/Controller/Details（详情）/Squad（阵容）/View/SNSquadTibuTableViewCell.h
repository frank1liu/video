//
//  SNSquadTibuTableViewCell.h
//  SportNews
//
//  Created by K哥 on 2021/2/26.
//

#import <UIKit/UIKit.h>
#import "SNSquadModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SNSquadPersonInfoModel;

@interface SNSquadTibuTableViewCell : BaseXibTableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *corBackView;

@property (weak, nonatomic) IBOutlet UILabel *hNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hNumWidth;
@property (weak, nonatomic) IBOutlet UIImageView *hIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *hNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hScoreLabel;
 
@property (weak, nonatomic) IBOutlet UILabel *aNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aNumWidth;
@property (weak, nonatomic) IBOutlet UIImageView *aIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *aNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aScoreLabel;

@property (nonatomic , strong) SNSquadPersonInfoModel *hPersonModel;

- (void)hideHomeSubView:(BOOL)isHide;

@property (nonatomic , strong) SNSquadPersonInfoModel *aPersonModel;

- (void)hideAwaySubView:(BOOL)isHide;

- (void)cellIsLastOne:(BOOL)last;

@end

NS_ASSUME_NONNULL_END
