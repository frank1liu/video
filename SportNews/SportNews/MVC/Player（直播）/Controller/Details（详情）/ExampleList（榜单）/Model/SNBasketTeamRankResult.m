//
//  SNBasketTeamRankResult.m
//  SportNews
//
//  Created by 根哥 on 2021/3/21.
//

#import "SNBasketTeamRankResult.h"

@implementation SNBasketTeamRankResult


+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list": @"SNExampleBaseModel",
             @"injuryList": @"SNExampleBaseModel",
    };
}

- (NSString *)reuseCellType{
    switch (_rankType) {
        case SNBasketRankTypeTeam:
        {
            if ([_name isEqualToString:@"东部排行"] ||[_name isEqualToString:@"西部排行"] ) {
                return @"SNTeamRankCell";
            }else if ([_name isEqualToString:@"分区排行"]) {
                return @"SNTeamRankFenQuCell";
            }else{
                return @"SNPlayerDefenCell";
            }
        }
            break;
        case SNBasketRankTypePlayer:
        {
            return @"SNExamplePlayerRankCell";
            
        }
            break;
        case SNBasketRankTypeInjuries:
        {
            return @"SNExamplePlayerRankCell";
        }
            break;
        case SNBasketRankTypeDay:
        {
            return @"SNExamplePlayerRankCell";
        }
            break;
        case SNBasketRankTypeUnknow:
        {
            return @"SNExamplePlayerRankCell";
        }
            break;
    }
    return @"SNPlayerDefenCell";

   
}


- (NSString *)reuseSectionHeaderType{
    if ([_name isEqualToString:@"东部排行"] || [_name isEqualToString:@"西部排行"] ) {
        return @"SNTeamRankHeaderView";
    }else if ([_name isEqualToString:@"分区排行"]) {
        return @"SNFenQuRankHeaderView";
    }else{
        return @"SNPlayerDefenHeaderView";
    }
}

- (NSInteger)listCount {
    _listCount = self.list.count;
    if ([self.reuseSectionHeaderType isEqualToString:@"SNPlayerDefenHeaderView"]) {
        _listCount = _listCount > 5 ? 5:_listCount;
    }
    return _listCount;
}

- (NSArray<SNExampleBaseModel *> *)list {
    if (_injuryList && _injuryList.count>0) {
        return _injuryList;
    }
    return _list;
}

@end
