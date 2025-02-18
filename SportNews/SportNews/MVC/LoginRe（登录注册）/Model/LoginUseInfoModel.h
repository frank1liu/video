//
//  LoginUseInfoModel.h
//  ScenicNav
//
//  Created by laoK on 2019/1/21.
//  Copyright © 2019 xhkj. All rights reserved.
//

#import <Foundation/Foundation.h>
 
NS_ASSUME_NONNULL_BEGIN


@interface LoginUseInfoModel : NSObject

@property (nonatomic , copy) NSString *ids;

@property (nonatomic , assign) NSInteger status;

@property (nonatomic , copy) NSString *createtime;

@property (nonatomic , copy) NSString *head;

@property (nonatomic , copy) NSString *mobile;

@property (nonatomic , copy) NSString *qrCode;

@property (nonatomic , copy) NSString *inviteCode;

@property (nonatomic , assign) NSInteger source;
 
@property (nonatomic , copy) NSString *updatetime;

@property (nonatomic , copy) NSString *password;

@property (nonatomic , copy) NSString *reason;

@property (nonatomic , copy) NSString *username;

@property (nonatomic , copy) NSString *lastLoginTime;

@property (nonatomic , copy) NSString *nickname;

@property (nonatomic, assign) NSInteger isvip;

@property (nonatomic , copy) NSString *lastLoginIp;

@property (nonatomic , copy) NSString *email;

//0是普通用户  1是主播
@property (nonatomic, assign) NSInteger atype;

@property (nonatomic, assign) NSInteger level;


@property (nonatomic , copy) NSString *sign;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, copy) NSString *bobbleFrontColor;

@end

NS_ASSUME_NONNULL_END
