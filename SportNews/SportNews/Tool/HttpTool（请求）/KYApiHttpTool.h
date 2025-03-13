//
//  KYApiHttpTool.h
//  ScenicNav
//
//  Created by laoK on 2019/1/18.
//  Copyright © 2019 xhkj. All rights reserved.
//

#import <Foundation/Foundation.h>
 
NS_ASSUME_NONNULL_BEGIN

@interface KYApiHttpTool : NSObject
  
/// 首页首次请求专用
+ (void)FirstGET:(NSString *)urlStr withParams:(NSDictionary  * _Nullable)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure;

/** GET请求 */
+ (void)GET:(NSString *)urlStr withParams:(NSDictionary  * _Nullable)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure;

/** GET请求 */
+ (void)GETNoHud:(NSString *)urlStr withParams:(NSDictionary  * _Nullable)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure;

+ (void)GETNoHud1:(NSString *)urlStr withParams:(NSDictionary  * _Nullable)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure;

/** POST请求 */
+ (void)POST:(NSString *)urlStr withParams:(NSDictionary  * _Nullable)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure;

+ (void)POST_TALK:(NSString *)urlStr withParams:(NSDictionary  * _Nullable)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure;

/** 单/多图上传 */
+ (void)UploadImage:(NSString *)urlStr withParams:(NSDictionary  * _Nullable)params withImages:(NSArray *)images success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure;

// 認證帳號使用
+ (void)GET_Account:(NSString *)urlStr withParams:(id)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure;

@end

NS_ASSUME_NONNULL_END
