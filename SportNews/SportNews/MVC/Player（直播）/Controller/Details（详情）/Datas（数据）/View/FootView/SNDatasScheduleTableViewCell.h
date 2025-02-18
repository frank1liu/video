//
//  SNDatasScheduleTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/1/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasScheduleTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)isDoubleCell:(BOOL)doubleCell;

- (void)isBenChangeGame:(BOOL)isBen;

- (void)cellIsLastOne:(BOOL)isLast;

- (void)reloadData:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
