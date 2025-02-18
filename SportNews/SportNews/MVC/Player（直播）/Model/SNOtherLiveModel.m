//
//  SNOtherLiveModel.m
//  SportNews
//
//  Created by kkk on 2021/5/6.
//

#import "SNOtherLiveModel.h"

@implementation SNOtherLiveModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ids" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{  
              @"live_urls" : [LiveCartoonModel class]
    };
}

@end
