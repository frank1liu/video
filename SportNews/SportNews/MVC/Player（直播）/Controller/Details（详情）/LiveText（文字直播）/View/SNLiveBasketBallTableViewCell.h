//
//  SNLiveBasketBallTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/1/20.
//

#import <UIKit/UIKit.h>
#import "SNBasketBallResult.h"
#import "LiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNLiveBasketBallTableViewCell : BaseXibTableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *xLineViewTop;
@property (weak, nonatomic) IBOutlet UIView *xLineViewBottom;
@property (weak, nonatomic) IBOutlet UIView *xLineView;

@property (weak, nonatomic) IBOutlet UIView *spotView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *contentBackView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelLeft;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView; 

- (void)cellIsLastOne:(BOOL)isLast;

- (void)cellIsfirstOne:(BOOL)isfirst;
 
@property(nonatomic, strong) SNBasketBallTliveModel *tLiveModel;

//列表
@property(nonatomic, strong) LiveListModel *model;

@end

NS_ASSUME_NONNULL_END
