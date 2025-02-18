//
//  SNOtherLiveTopCollectionViewCell.h
//  SportNews
//
//  Created by kkk on 2021/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNOtherLiveTopCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayNameLabel;

@end

NS_ASSUME_NONNULL_END
