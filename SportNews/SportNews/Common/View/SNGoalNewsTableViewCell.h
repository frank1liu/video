//
//  SNGoalNewsTableViewCell.h
//  ceshi
//
//  Created by kkk on 2021/4/7.
//

#import <UIKit/UIKit.h>
#import "SNGoalNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNGoalNewsTableViewCell : UITableViewCell
 
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong) SNGoalNewsModel *goalModel;

@end

NS_ASSUME_NONNULL_END
