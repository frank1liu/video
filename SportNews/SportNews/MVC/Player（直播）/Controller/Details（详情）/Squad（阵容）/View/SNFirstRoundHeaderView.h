//
//  SNFirstRoundHeaderView.h
//  SportNews
//
//  Created by 根哥 on 2021/2/19.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNSquadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNFirstRoundHeaderView : UIView

@property(nonatomic, strong) LiveListModel *model;

@property(nonatomic, strong) SNSquadModel *squadModel;

@property(nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
