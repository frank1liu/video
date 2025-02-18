//
//  SNDatasHistoryJiaoFengTopTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/2/4.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNDatasModel.h"

typedef NS_ENUM(NSInteger,DatasProgressViewType) {
    DatasProgressViewTypeLeft,
    DatasProgressViewTypeRight
};

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasHistoryJiaoFengTopTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong) LiveListModel *model;

@property (nonatomic, copy) void(^clickButtonView)(BOOL isSelect);

@property (nonatomic, copy) void(^clickTongZhuKe)(BOOL isSelect);
 
//是否勾选了按钮
- (void)isCellSelectButton:(BOOL)isSelect;
//是否勾选了同主客
- (void)isCellTongZhuKe:(BOOL)isSelect;

//历史交锋所有数据
@property(nonatomic, strong) NSArray *vsArray;

@end



@interface SNDatasProgressView : UIView

@property(nonatomic, assign) CGFloat progress;

- (instancetype)initWithFrame:(CGRect)frame withType:(DatasProgressViewType)type;

@end

NS_ASSUME_NONNULL_END
