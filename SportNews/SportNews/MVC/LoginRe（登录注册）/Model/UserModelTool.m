//
//  UserModelTool.m
//  EpochStore
//
//  Created by K哥 on 2019/7/11.
//  Copyright © 2019 K哥. All rights reserved.
//

#import "UserModelTool.h"

#define KFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userLogin.data"]

#define CategoryFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"category.data"]

@implementation UserModelTool

/**
 *  存储个人帐号
 */
+ (BOOL)save:(nullable LoginUserModel *)loginModel { 
    NSDictionary *loginDic = [loginModel mj_keyValues];
    NSData *encryptedData = [NSKeyedArchiver archivedDataWithRootObject:loginDic  requiringSecureCoding:YES error:nil];
    BOOL success = [encryptedData writeToFile:KFilepath options:NSDataWritingAtomic error:nil];
    // 归档
    if (loginModel == nil) {
        NSLog(@"token設定過期了!!");
    }
    return success;
}


/**
 *  读取个人帐号
 */
+ (LoginUserModel *)loginModel {
    
    NSData *data = [NSData dataWithContentsOfFile:KFilepath];
    // 读取帐号
    NSDictionary *loginDic = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSDictionary class] fromData:data error:nil];
    if (loginDic.count == 0) {
        return nil;
    }
    LoginUserModel *loginModel = [LoginUserModel mj_objectWithKeyValues:loginDic];
    return loginModel;
    
}

/**
 *  储存直播分类
 */
+ (BOOL)saveCategory:(NSArray *)categoryArray {
 
    NSArray *dataArray = [LiveListCategoryModel mj_keyValuesArrayWithObjectArray:categoryArray];
    NSData *encryptedData = [NSKeyedArchiver archivedDataWithRootObject:dataArray];
    BOOL success = [encryptedData writeToFile:CategoryFilepath options:NSDataWritingAtomic error:nil];
    // 归档
    return success;
}

/**
 *  读取分类
 */
+ (NSArray *)categoryArray {
    
    NSData *data = [NSData dataWithContentsOfFile:CategoryFilepath];
    NSArray *dataArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:@[[NSArray class],[NSDictionary class]]] fromData:data error:nil];
    NSArray *categorysArray = [LiveListCategoryModel mj_objectArrayWithKeyValuesArray:dataArray];
    return categorysArray;

}

@end
