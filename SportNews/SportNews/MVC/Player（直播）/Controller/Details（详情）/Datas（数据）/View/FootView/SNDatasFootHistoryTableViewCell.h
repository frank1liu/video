//
//  SNDatasFootHistoryTableViewCell.h
//  SportNews
//
//  Created by K哥 on 2021/2/1.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h" 
#import "SNDatasFootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasFootHistoryTableViewCell : BaseXibTableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;

@property(nonatomic, strong) LiveListModel *model;

//这个是历史交锋
@property(nonatomic, strong) SNDatasFootHistoryRecordModel *vsModel;

//近期战绩
@property(nonatomic, strong) SNDatasFootHistoryRecordModel *footModel;

@end

NS_ASSUME_NONNULL_END
