//
//  SNExampleMoreFooterView.h
//  SportNews
//
//  Created by 根哥 on 2021/3/15.
//

#import "SNExampleBaseHeaderView.h"
#import "SNBasketTeamRankResult.h"
NS_ASSUME_NONNULL_BEGIN

@interface SNExampleMoreFooterView : SNExampleBaseHeaderView

@property (nonatomic, copy) void(^clickedMoreBlock)(SNBasketTeamRankResult *model);

@end

NS_ASSUME_NONNULL_END
