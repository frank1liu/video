//
//  SNTeamCompareTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/3/22.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNDatasModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNTeamCompareTableViewCell : UITableViewCell

@property(nonatomic, strong) LiveListModel *model;

@property(nonatomic, strong) SNDatasModel *datasModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

/// 原型进度条
@interface SNDatasProgressContentView : UIView

@property (nonatomic, strong) UILabel *centerLabel;

@property (nonatomic, strong) UILabel *leftLabel;
 
@property (nonatomic, strong) UILabel *rightLabel;

- (void)leftProgress:(NSInteger)progressL rightProgress:(NSInteger)progressR;


@end

NS_ASSUME_NONNULL_END
