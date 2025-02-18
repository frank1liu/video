//
//  LoginUserModel.h
//  V-talk
//
//  Created by K哥 on 2020/4/26.
//  Copyright © 2020 K哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginUseInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginUserModel : NSObject

@property (nonatomic , assign) NSInteger code;

@property (nonatomic , copy) NSString *msg;

@property (nonatomic , copy) NSString *uid;

@property (nonatomic , copy) NSString *token;
 
@property (nonatomic , strong) LoginUseInfoModel *userinfo;


@end

NS_ASSUME_NONNULL_END
