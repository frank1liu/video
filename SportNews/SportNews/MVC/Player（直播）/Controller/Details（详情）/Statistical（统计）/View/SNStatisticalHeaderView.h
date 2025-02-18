//
//  SNStatisticalHeaderView.h
//  SportNews
//
//  Created by kkk on 2021/1/26.
//

#import <UIKit/UIKit.h>
#import "SNStatisticalModel.h"
#import "LiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNStatisticalHeaderView : UIView

@property(nonatomic, strong) SNStatisticalModel *statisticalModel;

//列表
@property(nonatomic, strong) LiveListModel *model;

@end


@interface SNStatisticalHeaderContentView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) void(^tap)(SNStatisticalHeaderMemberModel *model, bool left);

- (void)reloadModel:(SNStatisticalHeaderMemberModel *)awayModel homeModel:(SNStatisticalHeaderMemberModel *)homeModel;

@end

NS_ASSUME_NONNULL_END
