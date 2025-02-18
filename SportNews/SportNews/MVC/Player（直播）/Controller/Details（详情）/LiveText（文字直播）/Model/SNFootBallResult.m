//
//  SNFooterBallResult.m
//  SportNews
//
//  Created by yang on 2021/1/20.
//

#import "SNFootBallResult.h"

@implementation SNFootBallResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"stats": @"SNFootBallStatsModel",
             @"tlive": @"SNFootBallTextLiveModel",
             @"incidents": @"SNFootBallIncidentsModel"
    };
}

@end


@implementation SNFootBallIncidentsModel

- (CGFloat)cellHeight {
    
    CGFloat height = 0;
    //事件发生方，0-中立 1-主队 2-客队
    if (_position.integerValue != 0) {
        CGFloat subCellHeight = 30;
        if (![CommonTools isBlankString:_player_name]||![CommonTools isBlankString:_player_id]) {
            height = height+26+subCellHeight;
            if (![CommonTools isBlankString:_assist1_id]||![CommonTools isBlankString:_assist1_id]) {
                height = height+subCellHeight;
            }
            if (![CommonTools isBlankString:_assist2_id]||![CommonTools isBlankString:_assist2_id]) {
                height = height+subCellHeight;
            }
        }else if (![CommonTools isBlankString:_in_player_name]&&![CommonTools isBlankString:_out_player_name]) {
            height = height+26+subCellHeight*2;
        }
    }
    return height == 0? 40:height;
}

- (NSString *)iconImageStr {
    switch (_type.intValue) {
        case 1: //进球
            return @"足球列表";
            break;
        case 2: //角球
            return @"角球";
            break;
        case 3: //黄牌
            return @"黄牌";
            break;
        case 4:  //红牌
            return @"红牌";
            break;
        case 8:  //点球
            return @"点球";
            break;
        case 9: //换人
            return @"交换";
            break;
        case 15: //两黄变红
            return @"两黄一红";
            break;
        case 16: //点球未进
            return @"点球未进";
            break;
        case 17:  //乌龙球
            return @"乌龙球";
            break;
        default:
            return @"信息";
            break;
    }
}

- (NSString *)typeStr {
    switch (_type.intValue) {
        case 5:
            return @"界外球";
            break;
        case 6:
            return @"任意球";
            break;
        case 7:
            return @"球门球";
            break;
        case 10:
            return @" 比赛开始";
            break;
        case 13:
            return @"半场比分";
            break;
        case 19:
            return @"伤停补时";
            break;
        case 21:
            return @"射正";
            break;
        case 22:
            return @"射偏";
            break;
        case 23:
            return @"进攻";
            break;
        case 24:
            return @"危险进攻";
            break;
        case 25:
            return @"控球率";
            break;
        case 26:
            return @"加时赛结束";
            break;
        case 27:
            return @"点球大战结束";
            break;
        case 28:
            return @"VAR(视频助理裁判)";
            break;
        default:
            return @"信息";
            break;
    }
}


@end


@implementation SNFootBallScoreModel

@end


@implementation SNFootBallStatsModel

- (NSString *)typeName{

    switch (_type) {
        case 2: //角球
        {
            return @"角球";

        }
            break;

        case 3: //黄牌
        {
            return @"黄牌";
        }
            break;
            
        case 4:  //红牌
        {
            return @"红牌";
        }
            break;
        case 21:  //射正球门
        {
            return @"射正球门";

        }
            break;
        case 22: //射偏球门
        {
            return @"射偏球门";

        }
            break;
            
        case 23: //进攻
        {
            return @"进攻";
        }
            break;
        case 24:  //危险进攻
        {
            return @"危险进攻";

        }
            break;
        case 25: //控球率
        {
            return @"控球率";
        }
            break;
        default:
            return @"";
            break;
    }
}
@end


@implementation SNFootBallTextLiveModel

- (NSString *)imageName {

    switch (_type.intValue) {
        case 1:  //进球
        {
            return @"足球列表";
        }
        case 2: //角球
        {
            return @"角球";
        }
            break;
        case 3: //黄牌
        {
            return @"黄牌";
        }
            break;
        case 4:  //红牌
        {
            return @"红牌";
        }
            break;
        case 8:  //点球
        {
            return @"点球";
        }
            break;
        case 10://比赛开始
        case 11://中场
        case 12: //结束
        case 26: //加时赛结束
        case 27: //点球大战结束
        {
            return @"口哨";
        }
        case 15:  //两黄一红
        {
            return @"两黄一红";
        }
            break;
        case 16:  //
        {
            return @"点球未进";
        }
            break;
        case 17:  //
        {
            return @"乌龙球";
        }
            break;
        default:
            return @"信息";
            break;
    }
}


@end
