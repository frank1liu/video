//
//  SNExampleBaseModel.m
//  SportNews
//
//  Created by 根哥 on 2021/3/10.
//

#import "SNExampleBaseModel.h"

@implementation SNExampleBaseModel
- (instancetype)init{
    self = [super init];
    if (self) {
//        _name = @"SNExampleBaseModel";
        _reuseCellId = @"SNExampleBaseModelId";
        _reuseHeaderId = @"reuseHeaderId";

    }
    return self;
}

- (NSString *)typeString{
    switch (_type) {
        case 1:
            return @"受伤";
            break;
        case 2:
            return @"停赛";
            break;
        case 3:
            return @"缺席";
            break;
            
        default:
            return @"受伤";
            break;
    }
}

- (NSString *)statusString{
    switch (_type) {
        case 1:
            return @"无法出场";
            break;
        case 2:
            return @"赛季报销";
            break;
        case 3:
            return @"每日观察";
            break;
            
        default:
            return @"无法出场";
            break;
    }
}
@end
