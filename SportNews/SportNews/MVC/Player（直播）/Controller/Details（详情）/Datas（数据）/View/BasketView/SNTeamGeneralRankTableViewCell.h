//
//  SNTeamGeneralRankTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/3/22.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNDatasModel.h" 

NS_ASSUME_NONNULL_BEGIN

@interface SNTeamGeneralRankTableViewCell : UITableViewCell

@property(nonatomic, strong) LiveListModel *model;

@property(nonatomic, strong) SNDatasModel *datasModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end


@interface SNTeamCompareView : UIView
  
@property (nonatomic, strong) UILabel *centerLabel;

@property (nonatomic, strong) UILabel *leftLabel;
 
@property (nonatomic, strong) UILabel *rightLabel;
  
@end



NS_ASSUME_NONNULL_END
