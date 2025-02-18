//
//  SNSquadModel.m
//  SportNews
//
//  Created by kkk on 2021/2/5.
//

#import "SNSquadModel.h"

@implementation SNSquadModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ids": @"id",
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"home_zhengxing": @"SNSquadPersonInfoModel",
             @"away_zhengxing": @"SNSquadPersonInfoModel",
             
             @"home_huanren": @"SNSquadPersonInfoModel",
             @"away_huanren": @"SNSquadPersonInfoModel",
             
             @"home_tibu": @"SNSquadPersonInfoModel",
             @"away_tibu": @"SNSquadPersonInfoModel",
             
             @"home_injury": @"SNSquadPersonInfoModel",
             @"away_injury": @"SNSquadPersonInfoModel",
    };
}

@end

@implementation SNSquadPersonInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ids": @"id",
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"shijian": @"SNSquadShijianModel"
    };
}

@end


@implementation SNSquadShijianModel

/*
 type字段说明：
 | 状态码 |   描述
 | ------ | -------
 | 1      | 进球
 | 2      | 角球
 | 3      | 黄牌
 | 4      | 红牌
 | 5      | 界外球
 | 6      | 任意球
 | 7      | 球门球
 | 8      | 点球
 | 9      | 换人
 | 10     | 比赛开始
 | 11     | 中场
 | 12     | 结束
 | 13     | 半场比分
 | 15     | 两黄变红
 | 16     | 点球未进
 | 17     | 乌龙球
 | 19     | 伤停补时
 | 21     | 射正
 | 22     | 射偏
 | 23     | 进攻
 | 24     | 危险进攻
 | 25     | 控球率
 | 26     | 加时赛结束
 | 27     | 点球大战结束
 | 28     | VAR(视频助理裁判)
 | 29     | 点球(点球大战)(type_v2字段返回)
 | 30     | 点球未进(点球大战)(type_v2字段返回)
 | 31     |助攻 自己添加的
 
 */

- (NSString *)typeImage {
    switch (_type) {
        case 1:
            return @"足球列表"; 
        case 3:
            return @"黄牌";
            break;
        case 4:
            return @"红牌";
            break;
        case 9:
            return @"交换";
            break;
        case 15:
            return @"两黄一红";
            break;
        case 17:
            return @"乌龙球";
            break;
        case 29:
            return @"点球";
            break;
        case 31:
            return @"助攻";
            break;
        default:
            return @"";
            break;
    }
}
 
@end

@implementation SNPlayerDetail

@end
