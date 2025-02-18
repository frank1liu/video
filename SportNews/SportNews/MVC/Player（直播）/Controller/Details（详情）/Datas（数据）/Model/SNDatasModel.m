//
//  SNDatasModel.m
//  SportNews
//
//  Created by kkk on 2021/1/30.
//

#import "SNDatasModel.h"

@implementation SNDatasModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ids" : @"id"};
}
 

@end


@implementation SNDatasHistoryModel
 
- (NSArray<SNDatasBasketHistoryRecordModel *> *)basketVs {
    if ([_basketVs.firstObject isKindOfClass:[SNDatasBasketHistoryRecordModel class]]) {
        return _basketVs;
    }
    NSArray *basketVsArray = [self getBasketHistoryRecordArray:self.vs];
    _basketVs = basketVsArray;
    return basketVsArray;
}

- (NSArray<SNDatasBasketHistoryRecordModel *> *)basketHome {
    if ([_basketHome.firstObject isKindOfClass:[SNDatasBasketHistoryRecordModel class]]) {
        return _basketHome;
    }
    NSArray *basketVsArray = [self getBasketHistoryRecordArray:self.home];
    _basketHome = basketVsArray;
    return basketVsArray;
}


- (NSArray<SNDatasBasketHistoryRecordModel *> *)basketAway {
    if ([_basketAway.firstObject isKindOfClass:[SNDatasBasketHistoryRecordModel class]]) {
        return _basketAway;
    }
    NSArray *basketVsArray = [self getBasketHistoryRecordArray:self.away];
    _basketAway = basketVsArray;
    return basketVsArray;
}

- (NSArray *)getBasketHistoryRecordArray:(NSArray *)dataArray {
    @try {
        NSMutableArray *basketVsArray = [NSMutableArray array];
        [dataArray enumerateObjectsUsingBlock:^( NSArray *listArray, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= 10) {
                *stop = true;
                return;
            }
            if (listArray.count >= 19) {
                SNDatasBasketHistoryRecordModel *basketModel = [[SNDatasBasketHistoryRecordModel alloc] init];
                basketModel.ids = listArray[0];
                basketModel.count = listArray[1];
                basketModel.cid = listArray[2];
                basketModel.gameName = listArray[3];
                basketModel.status = listArray[4];
                NSNumber *time = listArray[5];
                basketModel.time = [NSDate timeStringWithInterval:time.integerValue];
                basketModel.LeaveTime = listArray[6];
                basketModel.hIds = listArray[7];
                basketModel.hName = listArray[8];
                basketModel.aIds = listArray[9];
                basketModel.aName = listArray[10];
                basketModel.scoreQuan = listArray[11];
                if ([basketModel.scoreQuan containsString:@"-"]) {
                    NSArray *score = [basketModel.scoreQuan componentsSeparatedByString:@"-"];
                    basketModel.hScore =  [NSString stringWithFormat:@"%@",score.firstObject];
                    basketModel.aScore =  [NSString stringWithFormat:@"%@",score.lastObject];
                }
                basketModel.totalScoreQuan = listArray[12];
                basketModel.scoreBan = listArray[13];
                if ([basketModel.scoreBan containsString:@"-"]) {
                    NSArray *score = [basketModel.scoreBan componentsSeparatedByString:@"-"];
                    basketModel.hScoreBan =  [NSString stringWithFormat:@"%@",score.firstObject];
                    basketModel.aScoreBan =  [NSString stringWithFormat:@"%@",score.lastObject];
                }
                basketModel.totalScoreBan = listArray[14];
                basketModel.scoreRang = listArray[15];
                basketModel.describeRang = listArray[16];
                basketModel.scoreZong = listArray[17];
                basketModel.describeZong = listArray[18];
                [basketVsArray addObject:basketModel];
            }
        }];
     
        return basketVsArray;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}



- (NSArray<SNDatasFootHistoryRecordModel *> *)footVs {
   if ([_footVs.firstObject isKindOfClass:[SNDatasFootHistoryRecordModel class]]) {
       return _footVs;
   }
   NSArray *basketVsArray = [self getFootHistoryRecordArray:self.vs];
    _footVs = basketVsArray;
   return basketVsArray;
}

- (NSArray<SNDatasFootHistoryRecordModel *> *)footHome {
   if ([_footHome.firstObject isKindOfClass:[SNDatasFootHistoryRecordModel class]]) {
       return _footHome;
   }
   NSArray *basketVsArray = [self getFootHistoryRecordArray:self.home];
    _footHome = basketVsArray;
   return basketVsArray;
}


- (NSArray<SNDatasFootHistoryRecordModel *> *)footAway {
   if ([_footAway.firstObject isKindOfClass:[SNDatasFootHistoryRecordModel class]]) {
       return _footAway;
   }
   NSArray *basketVsArray = [self getFootHistoryRecordArray:self.away];
    _footAway = basketVsArray;
   return basketVsArray;
}
 
- (NSArray *)getFootHistoryRecordArray:(NSArray *)dataArray {
    
    @try {
        
        NSMutableArray *footArray = [NSMutableArray array];
        [dataArray enumerateObjectsUsingBlock:^( NSArray *listArray, NSUInteger idx, BOOL * _Nonnull stop) {
            if (listArray.count >= 16) {
                SNDatasFootHistoryRecordModel *footModel = [[SNDatasFootHistoryRecordModel alloc] init];
                footModel.ids = listArray[0];
                footModel.cid = listArray[1];
                footModel.gameName = listArray[2];
                footModel.status = listArray[3];
                NSNumber *time = listArray[4];
                footModel.time = [NSDate timeStringWithInterval:time.integerValue];
                footModel.LeaveTime = listArray[5];
                footModel.hIds = listArray[6];
                footModel.hName = listArray[7];
                footModel.aIds = listArray[8];
                footModel.aName = listArray[9];
                footModel.scoreQuan = listArray[10];
                if ([footModel.scoreQuan containsString:@"-"]) {
                    NSArray *score = [footModel.scoreQuan componentsSeparatedByString:@"-"];
                    footModel.hScore =  [NSString stringWithFormat:@"%@",score.firstObject];
                    footModel.aScore =  [NSString stringWithFormat:@"%@",score.lastObject];
                }
                footModel.scoreBan = listArray[11];
                footModel.valuePan = listArray[12];
                footModel.describePan = listArray[13];
                footModel.scoreQiu = listArray[14];
                footModel.describeQiu = listArray[15];
                footModel.jiaoCount = listArray[16];
                [footArray addObject:footModel];
            }
        }];
     
        return footArray;
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}


@end


@implementation SNDatasInjuryModel
 

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"home":[SNDatasFootInjuryModel class],
             @"away":[SNDatasFootInjuryModel class],
    };
}

@end


@implementation SNDatasInfoModel
 

@end


@implementation SNDatasTableModel
 

@end

@implementation SNDatasTableDataModel
 

@end

@implementation SNDatasGoalDistributionModel
 

@end


@implementation SNDatasFixtureModel
 

@end


@implementation SNDatasRecentMatch


@end

@implementation SNDatasRankModel


@end


@implementation SNDatasCompareModel


@end
