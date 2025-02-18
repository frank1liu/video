//
//  SNExampleBaseHeaderView.h
//  SportNews
//
//  Created by 根哥 on 2021/3/10.
//

#import <UIKit/UIKit.h>
#import "SNBasketTeamRankResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNExampleBaseHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerWithTableView:(UITableView *)tableView exampleModel:(SNBasketTeamRankResult *)model;

@property (nonatomic, strong) SNBasketTeamRankResult                   *model;

@end

NS_ASSUME_NONNULL_END
