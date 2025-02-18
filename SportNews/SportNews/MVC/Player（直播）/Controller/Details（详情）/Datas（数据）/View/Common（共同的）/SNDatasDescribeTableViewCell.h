//
//  SNDatasDescribeTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/2/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasDescribeTableViewCell : UITableViewCell

@property(nonatomic, copy) NSString *contentStr;

- (void)cellIsLastOne:(BOOL)isLast;

- (void)setRecentResult:(NSMutableAttributedString *)attr;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
