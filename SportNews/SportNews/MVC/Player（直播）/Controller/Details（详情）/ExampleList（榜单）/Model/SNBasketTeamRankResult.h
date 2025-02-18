//
//  SNBasketTeamRankResult.h
//  SportNews
//
//  Created by 根哥 on 2021/3/21.
//

#import <Foundation/Foundation.h>
#import "SNExampleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNBasketTeamRankResult : NSObject

@property (nonatomic, copy) NSString            *tagName;
@property (nonatomic, copy) NSString            *name;
@property (nonatomic, copy) NSString            *reuseCellType; 
@property (nonatomic, copy) NSString            *reuseSectionHeaderType;
@property (nonatomic, assign) NSInteger          index;
@property (nonatomic, assign) SNBasketRankType          rankType;

//球队榜
@property (nonatomic, strong) NSArray <SNExampleBaseModel *>          *list;
@property (nonatomic, assign) NSInteger          listCount;

//球员榜 name list


//伤停榜 team_id team_name injuryList
@property (nonatomic, assign) NSInteger          team_id;
@property (nonatomic, copy) NSString            *team_name;
@property (nonatomic, strong) NSArray <SNExampleBaseModel *>          *injuryList;

@end

NS_ASSUME_NONNULL_END
