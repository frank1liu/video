//
//  SNLiveSourcesView.h
//  cess
//
//  Created by kkk on 2021/6/4.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNLiveSourcesView : UIView

- (instancetype)initWithFrame:(CGRect)frame withModel:(LiveListModel *)model;

@property (nonatomic, copy) void(^sourceWithTag)(NSInteger tag);

@property(nonatomic, assign) CGFloat contentHeight;
 

@end

NS_ASSUME_NONNULL_END
