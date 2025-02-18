//
//  SNDatasFootInjuryTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/2/6.
//

#import <UIKit/UIKit.h>
#import "SNDatasFootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasFootInjuryTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong) SNDatasFootInjuryModel *injuryModel;

- (void)cellIsLastOne:(BOOL)isLast;

@end

NS_ASSUME_NONNULL_END
