//
//  MineTableViewCell.h
//  StockExchange
//
//  Created by kkk on 2020/11/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineTableViewCell : BaseXibTableViewCell
 
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

NS_ASSUME_NONNULL_END
