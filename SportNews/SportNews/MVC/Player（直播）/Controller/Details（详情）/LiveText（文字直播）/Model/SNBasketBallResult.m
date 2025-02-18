//
//  SNBasketBallResult.m
//  SportNews
//
//  Created by kkk on 2021/1/21.
//

#import "SNBasketBallResult.h"

@implementation SNBasketBallResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (NSInteger)status {
    if (_score.count < 1) {
        return 0;
    }
    NSNumber *sta = _score[1];
    return sta.intValue;
}

- (NSString *)sectionString {
    if (_score.count < 1) {
        return @"第一节";
    }
    NSNumber *status = _score[1];
    switch ([status integerValue]) {
        case 1:
            return @"未开赛";
        break;
        case 2:
            return @"第一节";
        break;
        case 3:
            return @"第一节完";
        break;
            
        case 4:
            return @"第二节";
        break;
            
        case 5:
            return @"第二节完";
        break;
        case 6:
            return @"第三节";
        break;
        case 7:
            return @"第三节完";
        break;
        case 8:
            return @"第四节";
        break;
        case 9:
            return @"加时";
        break;
        case 10:
            return @"完场";
        break;
        case 11:
            return @"中断";
        break;
        case 12:
            return @"取消";
        break;
        case 13:
            return @"延期";
        break;
        case 14:
            return @"腰斩";
        break;
        case 15:
            return @"待定";
        break;
        default:
            return @"未开赛";
            break;
    }
}

- (NSArray *)tlive {
    
    @try {
        NSArray *tliveArray = [_tlive copy];
        NSMutableArray *tliveModelArray = [NSMutableArray arrayWithCapacity:tliveArray.count];
        for (NSArray *array in tliveArray) {
            if ([array.firstObject isKindOfClass:[SNBasketBallTliveModel class]]) {
                return _tlive;
            }
            NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:array.count];
            [array enumerateObjectsUsingBlock:^(NSString *stringObj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([stringObj isKindOfClass:[NSString class]]) {
                    SNBasketBallTliveModel *tliveModel = [self handleData:stringObj];
                    [tempArray addObject:tliveModel];
                }
            }];
            tempArray = [[tempArray reverseObjectEnumerator].allObjects mutableCopy];
            [tliveModelArray addObject:tempArray];
        }
        return tliveModelArray;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}
 
- (SNBasketBallTliveModel *)handleData:(NSString *)string {
    
    @try {
        NSArray *tempArray = [string componentsSeparatedByString:@"^"];
        SNBasketBallTliveModel *model = [[SNBasketBallTliveModel alloc]init];
        if (tempArray.count < 7) {
            return nil;
        }
        model.index = [tempArray.firstObject integerValue];
        model.section = tempArray[1];
        model.time = tempArray[2];
        model.t_type = [tempArray[3] integerValue];
        model.score = tempArray[5];
        model.text = tempArray[6];
        
        return model;
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }

}


@end

@implementation SNBasketBallTliveModel

- (NSString *)sectionString {
    switch ([_section integerValue]) {
        case 1:
            return @"第一节";
        break;
        case 2:
            return @"第二节";
        break;
            
        case 3:
            return @"第三节";
        break;
        case 4:
            return @"第四节";
        break;
        case 5:
            return @"加时一";
        break;
        case 6:
            return @"加时二";
        break;
        case 7:
            return @"加时三";
        break;
        case 8:
            return @"加时四";
        break;
        default:
            return @"加时五";
            break;
    }
}

@end
