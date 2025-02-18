//
//  SNLiveListCollectionViewCell.h
//  SportNews
//
//  Created by kkk on 2021/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNLiveListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countWidth;

- (void)setupCount;

@end

NS_ASSUME_NONNULL_END
