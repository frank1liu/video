//
//  UserModelTool.h
//  EpochStore
//
//  Created by K哥 on 2019/7/11.
//  Copyright © 2019 K哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginUserModel.h"
#import "LiveListCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModelTool : NSObject

/**
 *  存储个人帐号
 */
+ (BOOL)save:(nullable LoginUserModel *)loginModel;

/**
 *  读取个人帐号
 */
+ (LoginUserModel *)loginModel;

/**
 *  储存直播分类
 */
+ (BOOL)saveCategory:(NSArray *)categoryArray;

/**
 *  读取分类
 */
+ (NSArray *)categoryArray;




@end

NS_ASSUME_NONNULL_END
