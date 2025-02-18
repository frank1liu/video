//
//  JCHATChatModel.h
//  test project
//
//  Created by guan jingFen on 14-3-10.
//  Copyright (c) 2014年 guan jingFen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCHATChatModel : NSObject
 
@property (nonatomic, copy) NSString            *msgId;
@property (nonatomic, copy) NSString            *fromType;
@property (nonatomic, copy) NSString            *serverMessageId;

@property (nonatomic, copy) NSString            *text;
@property (nonatomic, copy) NSString            *fromName;
@property(nonatomic, assign) NSInteger     contentType;

@property (nonatomic, strong) NSNumber *messageTime;
@property (nonatomic, assign) NSInteger level;

@property (nonatomic, assign) float contentHeight;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) NSString *timeId;
@property (nonatomic, assign) BOOL isTime;

@property (nonatomic, assign) BOOL isDefaultAvatar;
@property (nonatomic, assign) NSUInteger avatarDataLength;
@property (nonatomic, assign) NSUInteger messageMediaDataLength;

@property (nonatomic, assign) BOOL isErrorMessage;
@property (nonatomic, strong) NSError *messageError;

@property (nonatomic, assign) NSInteger gif;
@property (nonatomic, strong) NSString *bubbleAndroidUrl;
@property (nonatomic, strong) NSString *bubbleFrontColor;

- (CGFloat)getCellHeight;
  

@end
