//
//  SNExampleBaseTableViewCell.h
//  SportNews
//
//  Created by 根哥 on 2021/3/10.
//

#import <UIKit/UIKit.h>
#import "SNExampleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNExampleBaseTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView exampleModel:(SNExampleBaseModel *)model;

- (void)configureModelData:(SNExampleBaseModel *)model;

@end

NS_ASSUME_NONNULL_END
