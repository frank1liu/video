//
//  SNSquadTopTableViewCell.h
//  SportNews
//
//  Created by K哥 on 2021/2/26.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNSquadTopTableViewCell : BaseXibTableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *corBackView;

@property (weak, nonatomic) IBOutlet UIImageView *hIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *hNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *aNameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *lineView1;

@property(nonatomic, strong) LiveListModel *model;

@property (nonatomic , assign) BOOL isTop;

//是不是替补
- (void)cellIsTiBu:(BOOL)tibu;
 

@end

NS_ASSUME_NONNULL_END
