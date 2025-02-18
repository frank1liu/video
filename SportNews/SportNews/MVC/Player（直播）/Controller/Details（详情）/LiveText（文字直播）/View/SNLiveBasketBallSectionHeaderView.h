//
//  SNLiveBasketBallSectionHeaderView.h
//  SportNews
//
//  Created by kkk on 2021/1/20.
//

#import <UIKit/UIKit.h>
#import "SNBasketBallResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNLiveBasketBallSectionHeaderView : UIView
 

- (instancetype)initWithFrame:(CGRect)frame datasArray:(NSArray *)datasArray;

- (void)reloadDataWithModel:(SNBasketBallResult *)resultBasketObj;

@property (nonatomic, copy) void(^buttonClickWithTag)(NSInteger tag);
 

@end

NS_ASSUME_NONNULL_END
