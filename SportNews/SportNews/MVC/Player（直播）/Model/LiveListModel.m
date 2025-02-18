//
//  LiveListModel.m
//  SportNews
//
//  Created by pangchong on 2020/12/7.
//

#import "LiveListModel.h"

@implementation LiveListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"live_cartoon_url" : [LiveCartoonModel class],
              @"live_urls" : [LiveCartoonModel class]
    };
}
 
@end
