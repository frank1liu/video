//
//  JCHATChatModel.h
//  test project
//
//  Created by guan jingFen on 14-3-10.
//  Copyright (c) 2014年 guan jingFen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChatGiftModel : NSObject <NSCoding>
 
@property (nonatomic, strong) NSString      *level;    // V16
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSString      *yinlang;  // 音浪
@property (nonatomic, strong) NSString      *url;
@property (nonatomic, strong) NSString      *type;   // 0:禮物 1:等級 2:氣泡 3:本地
@property (nonatomic, strong) NSString      *giftID;
@property (nonatomic, strong) NSString      *gifUrl;
@property (nonatomic, strong) NSString      *_9file;
@property (nonatomic, strong) NSString      *_9fileBg;
@property (nonatomic, strong) NSString      *bubbleFrontColor;

@end
