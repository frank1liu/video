//
//  SNDatasFootPointRankTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/2/2.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNDatasModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasFootPointRankTableViewCell : UITableViewCell

@property(nonatomic, strong) LiveListModel *model;

@property(nonatomic, strong) SNDatasModel *datasModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
 
@end

@interface SNDatasFootPointRankContentView : UIView

- (void)setupTitle:(NSString *)title;
 
- (void)setupTeamName:(NSString *)teamName iconImage:(NSString *)iconStr;

- (void)setupDatasArray:(NSArray *)zongArray zhuArray:(NSArray *)zhuArray keArray:(NSArray *)keArray;

@end


@interface SNDatasFootPointRankView : UIView

@property(nonatomic, copy) NSString *firstText;

@property(nonatomic, strong) NSArray *datasArray;

- (void)isDoubleCell:(BOOL)doubleCell;

@end

NS_ASSUME_NONNULL_END
