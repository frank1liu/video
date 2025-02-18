//
//  MineInfoTableViewCell.h
//  SportNews
//
//  Created by kkk on 2020/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineInfoTableViewCell : BaseXibTableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subRight;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

NS_ASSUME_NONNULL_END
