//
//  SNDatasFootTeamTopTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/2/3.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasFootTeamTopTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
 
@property(nonatomic, strong) LiveListModel *model;

//type = 1 有logo和队伍名字  0 没有
@property(nonatomic, assign) NSInteger type;

- (void)setupTeamName:(NSString *)teamName iconImage:(NSString *)iconStr;

@property (nonatomic, copy) void(^clickButtonView)(BOOL isSelect);

@property (nonatomic, copy) void(^clickTongZhuKe)(BOOL isSelect);

@property (nonatomic, copy) void(^clickTongSaiShi)(BOOL isSelect);

//是否勾选了按钮
- (void)isCellSelectButton:(BOOL)isSelect;
//是否勾选了同主客
- (void)isCellTongZhuKe:(BOOL)isSelect;
//是否勾选了同赛事
- (void)isCellTongSaiShi:(BOOL)isSelect;
 
//是不是最顶上的
- (void)cellIsTopOne:(BOOL)isTop;

@end

NS_ASSUME_NONNULL_END
