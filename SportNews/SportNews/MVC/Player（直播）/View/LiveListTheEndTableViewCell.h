//
//  LiveListTheEndTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/3/31.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveListTheEndTableViewCell : BaseXibTableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *hNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *hScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hSanImageView;

@property (weak, nonatomic) IBOutlet UILabel *aNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *aScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aSanImageView;

@property (weak, nonatomic) IBOutlet UIButton *huifangBtn;

@property(nonatomic, strong) LiveListModel *model; 

@end

NS_ASSUME_NONNULL_END
