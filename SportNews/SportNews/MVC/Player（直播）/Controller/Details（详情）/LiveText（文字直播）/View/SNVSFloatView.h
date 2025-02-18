//
//  SNVSFloatView.h
//  SportNews
//
//  Created by kkk on 2021/3/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LiveListModel;
/// vs浮窗
@interface SNVSFloatView : UIView
@property (nonatomic, strong) NSArray<LiveListModel *>         *dataSource;  //数据源

@property (nonatomic, copy) dispatch_block_t  closeBlock;

@property (nonatomic, copy) void(^clickedItemBlock)(LiveListModel *model);

@end

NS_ASSUME_NONNULL_END
