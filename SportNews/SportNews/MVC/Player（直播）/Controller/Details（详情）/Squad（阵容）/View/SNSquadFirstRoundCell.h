//
//  SNSquadFirstRoundCell.h
//  SportNews
//
//  Created by 根哥 on 2021/2/19.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNSquadModel.h"

typedef NS_ENUM(NSInteger, cellType) {
    cellTypeTop,
    celltypBottom,
};

NS_ASSUME_NONNULL_BEGIN
@class SNSquadPersonInfoModel;

@interface SNSquadFirstRoundCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier cellType:(cellType )type;

@property (nonatomic, strong) NSArray <SNSquadPersonInfoModel *>                  *dataSource;

@property(nonatomic, strong) LiveListModel *model;

@property(nonatomic, strong) SNSquadModel *squadModel;

@end


@interface SNPersonalInfoView : UIView

@property (nonatomic, copy) SNSquadPersonInfoModel            *personModel;


- (void)persionIsTop:(BOOL)isTop;

@end



NS_ASSUME_NONNULL_END
