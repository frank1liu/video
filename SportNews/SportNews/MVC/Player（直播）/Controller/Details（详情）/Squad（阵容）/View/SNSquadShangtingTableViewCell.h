//
//  SNSquadShangtingTableViewCell.h
//  SportNews
//
//  Created by K哥 on 2021/2/26.
//

#import <UIKit/UIKit.h>
#import "SNSquadModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SNSquadPersonInfoModel;


@interface SNSquadShangtingTableViewCell : BaseXibTableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *corBackView;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numWidth;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (nonatomic , strong) SNSquadPersonInfoModel *personModel;

- (void)cellIsHomeTeam:(BOOL)home;

- (void)cellIsLastOne:(BOOL)last;


@end

NS_ASSUME_NONNULL_END
