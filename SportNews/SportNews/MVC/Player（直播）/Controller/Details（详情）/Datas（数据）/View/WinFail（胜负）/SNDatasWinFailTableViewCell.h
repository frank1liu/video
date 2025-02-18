//
//  SNDatasWinFailTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/1/30.
//

#import <UIKit/UIKit.h>
#import "SNDatasModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasWinFailTableViewCell : UITableViewCell

@property(nonatomic, strong) SNDatasModel *datasModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)isDoubleCell:(BOOL)doubleCell;
 
- (void)cellIsLastOne:(BOOL)isLast;


/// 展示内容
/// @param contents 内容数组，如：[1,1,1,胜胜,0,0,0]，对应着界面上的数据。
- (void)showContentWithDatas:(NSArray *)contents;

@end

NS_ASSUME_NONNULL_END
