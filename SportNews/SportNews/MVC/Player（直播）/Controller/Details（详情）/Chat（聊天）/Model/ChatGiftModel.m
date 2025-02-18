//
//  JCHATChatModel.m
//  test project
//
//  Created by guan jingFen on 14-3-10.
//  Copyright (c) 2014年 guan jingFen. All rights reserved.
//

#import "ChatGiftModel.h"

@implementation ChatGiftModel

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder { 
    [coder encodeObject:_level forKey:@"level"];
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_yinlang forKey:@"yinlang"];
    [coder encodeObject:_url forKey:@"url"];
    [coder encodeObject:_type forKey:@"type"];
    [coder encodeObject:_giftID forKey:@"giftID"];
    [coder encodeObject:_gifUrl forKey:@"gifUrl"];
    [coder encodeObject:__9file forKey:@"9file"];
    [coder encodeObject:_bubbleFrontColor forKey:@"bubbleFrontColor"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if (self = [super init]) {
        _level = [coder decodeObjectForKey:@"level"];
        _name = [coder decodeObjectForKey:@"name"];
        _yinlang = [coder decodeObjectForKey:@"yinlang"];
        _url = [coder decodeObjectForKey:@"url"];
        _type = [coder decodeObjectForKey:@"type"];
        _giftID = [coder decodeObjectForKey:@"giftID"];
        _gifUrl = [coder decodeObjectForKey:@"gifUrl"];
        __9file = [coder decodeObjectForKey:@"9file"];
        _bubbleFrontColor = [coder decodeObjectForKey:@"bubbleFrontColor"];
    }
    return self;
}

@end
