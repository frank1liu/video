//
//  SNStatisticalModel.m
//  SportNews
//
//  Created by kkk on 2021/1/26.
//

#import "SNStatisticalModel.h"


@implementation SNStatisticalModel

- (NSArray *)allDatas {
    
    if (_players.count != 4) {
        return nil;
    }
    NSArray *tliveArray = @[_players[2],_players[3]];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:tliveArray.count];
    [tliveArray enumerateObjectsUsingBlock:^(NSString *stringObj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([stringObj isKindOfClass:[NSString class]]) {
            SNStatisticalPlayerBottomModel *dataModel = [self handleData:stringObj];
            [tempArray addObject:dataModel];
        }
    }];
    return tempArray;
    
}


- (SNStatisticalPlayerBottomModel *)handleData:(NSString *)string {
    
//   "0^44-89^14-30^28-37^15^31^46^21^13^10^15^19^0^130" 0(兼容忽略)^1命中次数-投篮次数^2三分球投篮命中次数-三分投篮次数^3罚球命中次数-罚球投篮次数^4进攻篮板^5防守篮板^6总的篮板^7助攻数^8抢断数^9盖帽数^10失误次数^11个人犯规次数^12(兼容忽略)^13得分
    NSArray *tempArray = [string componentsSeparatedByString:@"^"];
    if (tempArray.count < 14) {
        return nil;
    }
    SNStatisticalPlayerBottomModel *model = [[SNStatisticalPlayerBottomModel alloc] init];
    model.defen = [tempArray.lastObject integerValue];
    model.lanban = [tempArray[6] integerValue];
    model.zhugong = [tempArray[7] integerValue];
    model.gaimao = [tempArray[9] integerValue];
    model.qiangduan = [tempArray[8] integerValue];
    model.shiwu = [tempArray[10] integerValue];
    
    return model;

}

- (NSArray *)homePlayers {
    if (_players.count < 1) {
        return nil;
    }
    NSArray *tliveArray = _players[0];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:tliveArray.count];
    [tliveArray enumerateObjectsUsingBlock:^(NSArray *playerArray, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([playerArray isKindOfClass:[NSArray class]]) {
            SNStatisticalPlayerDataModel *dataModel = [self playerData:playerArray[6] withName:playerArray[1]];
            [tempArray addObject:dataModel];
        }
    }];
    return tempArray;
}

- (NSArray *)awayPlayers {
    if (_players.count < 2) {
        return nil;
    }
    NSArray *tliveArray = _players[1];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:tliveArray.count];
    [tliveArray enumerateObjectsUsingBlock:^(NSArray *playerArray, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([playerArray isKindOfClass:[NSArray class]]) {
            SNStatisticalPlayerDataModel *dataModel = [self playerData:playerArray[6] withName:playerArray[1]];
            [tempArray addObject:dataModel];
        }
    }];
    return tempArray;
}

- (SNStatisticalPlayerDataModel *)playerData:(NSString *)string withName:(NSString *)name {
    
//   "26^5-12^1-4^3-3^2^7^9^0^1^0^2^5^0^14^1^1^1"
//在场持续时间^命中次数-投篮次数^三分球投篮命中次数-三分投篮次数^罚球命中次数-罚球投篮次数^进攻篮板^防守篮板^总的篮板^助攻数^抢断数^盖帽数^失误次数^个人犯规次数^+/-值^得分^是否出场(1-出场，0-没出场)^是否在场上（0-在场上，1-没在场上）（用于赛中）^是否是替补（1-替补，0-首发）
    NSArray *tempArray = [string componentsSeparatedByString:@"^"];
    if (tempArray.count != 17) {
        return nil;
    }
    SNStatisticalPlayerDataModel *model = [[SNStatisticalPlayerDataModel alloc] init];
    model.name = name;
    
    model.time = tempArray[0];
    model.count = tempArray[1];
    model.threeCount = tempArray[2];
    model.faCount = tempArray[3];
    
    model.jGLanban = tempArray[4];
    model.fSLanban = tempArray[5];
    model.zongLanban = tempArray[6];
    model.zhugong = tempArray[7];
    
    model.qiangduan = tempArray[8];
    model.gaimao = tempArray[9];
    model.shiwu = tempArray[10];
    model.fangui = tempArray[11];
     
    model.defen = tempArray[13];
    model.isChuChang = [tempArray[14] integerValue];
    model.isPlaying = [tempArray[15] integerValue];
    model.isTiBu = [tempArray[16] integerValue];
      
    return model;

}

@end
 

@implementation SNStatisticalPlayerDataModel


@end


@implementation SNStatisticalPlayerBottomModel


@end



@implementation SNStatisticalHeaderTeamModel


@end




@implementation SNStatisticalHeaderMemberModel

@end




@implementation SNStatisticalPlayerModel

@end
