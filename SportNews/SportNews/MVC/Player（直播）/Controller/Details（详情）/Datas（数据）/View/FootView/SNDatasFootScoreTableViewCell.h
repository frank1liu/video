//
//  SNDatasFootScoreTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/2/2.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNDatasModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasFootScoreTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong) LiveListModel *model;

@property(nonatomic, strong) SNDatasModel *datasModel;

@end


@interface SNDatasFootScoreView : UIView

@property(nonatomic, strong) NSArray *datasArray;

@property(nonatomic, strong) UIColor *normalColor;

@property(nonatomic, strong) UIColor *selectColor;

@end

NS_ASSUME_NONNULL_END
