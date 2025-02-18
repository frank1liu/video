//
//  SNDatasHistoryTableViewCell.h
//  SportNews
//
//  Created by K哥 on 2021/1/31.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNDatasBasketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasHistoryTableViewCell : BaseXibTableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;

@property(nonatomic, strong) LiveListModel *model;

@property(nonatomic, assign) BOOL isZhudui;

@property(nonatomic, strong) SNDatasBasketHistoryRecordModel *vsModel;

@property(nonatomic, strong) SNDatasBasketHistoryRecordModel *basketModel;

@end

NS_ASSUME_NONNULL_END
