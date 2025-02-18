//
//  SNDatasWinFailTeamTopTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/2/3.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasWinFailTeamTopTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
 
//type = 1 有右上角 按钮  0 没有
@property(nonatomic, assign) NSInteger type;

@property(nonatomic, strong) LiveListModel *model;

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

//是不是篮球的胜分差
- (void)basketWinFail:(BOOL)isWF;

//刷新title
- (void)reloadTitle:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
