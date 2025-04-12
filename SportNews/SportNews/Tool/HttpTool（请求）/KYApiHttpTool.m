//
//  KYApiHttpTool.m
//  ScenicNav
//
//  Created by laoK on 2019/1/18.
//  Copyright © 2019 xhkj. All rights reserved.
//

#import "KYApiHttpTool.h"
#import "LoginViewController.h"
#import "AFNetworking.h"
#import "MSNetwork.h"
#import "DNSResolver.h"

@implementation KYApiHttpTool

+ (void)request:(NSString *)url withParams:(NSDictionary  * _Nullable)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure {
    [MSNetwork setRequestTimeoutInterval:60.0f];
    [MSNetwork closeLog];
    NSLog(@"[Adam][GET]第1次请求参数:%@", [params mj_JSONString]);
    NSLog(@"[Adam][GET]第1次请求：%@", url);
    [MSNetwork GET:url parameters:params headers:nil cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                success(responseObject);
                return;
            }
        }
        NSLog(@"[Adam][GET]第2次请求参数:%@", [params mj_JSONString]);
        NSLog(@"[Adam][GET]第2次请求：%@", url);
        [MSNetwork GET:url parameters:params headers:nil cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
            if (responseObject) {
                if ([responseObject[@"code"] integerValue] == 0) {
                    success(responseObject);
                    return;
                }
            }
            NSLog(@"[Adam][GET]第3次请求参数:%@", [params mj_JSONString]);
            NSLog(@"[Adam][GET]第3次请求：%@", url);
            [MSNetwork GET:url parameters:params headers:nil cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
                if (responseObject) {
                    if ([responseObject[@"code"] integerValue] == 0) {
                        success(responseObject);
                        return;
                    }
                    success(responseObject);
                    return;
                }
                failure(nil);
            } failure:^(NSError * _Nonnull error) {
                failure(error);
            }];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"[Adam][GET]第3次请求失敗参数:%@", [params mj_JSONString]);
            NSLog(@"[Adam][GET]第3次请求失敗：%@", url);
            [MSNetwork GET:url parameters:params headers:nil cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
                if (responseObject) {
                    if ([responseObject[@"code"] integerValue] == 0) {
                        success(responseObject);
                        return;
                    }
                    success(responseObject);
                    return;
                }
                failure(nil);
            } failure:^(NSError * _Nonnull error) {
                failure(error);
            }];
        }];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"[Adam][GET]第2次请求失敗参数:%@", [params mj_JSONString]);
        NSLog(@"[Adam][GET]第2次请求失敗：%@", url);
        [MSNetwork GET:url parameters:params headers:nil cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
            if (responseObject) {
                if ([responseObject[@"code"] integerValue] == 0) {
                    success(responseObject);
                    return;
                }
            }
            NSLog(@"[Adam][GET]第3次请求：%@", url);
            [MSNetwork GET:url parameters:params headers:nil cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
                if (responseObject) {
                    if ([responseObject[@"code"] integerValue] == 0) {
                        success(responseObject);
                        return;
                    }
                    success(responseObject);
                    return;
                }
                failure(nil);
            } failure:^(NSError * _Nonnull error) {
                failure(error);
            }];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"[Adam][GET]第3次请求：%@", url);
            [MSNetwork GET:url parameters:params headers:nil cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
                if (responseObject) {
                    if ([responseObject[@"code"] integerValue] == 0) {
                        success(responseObject);
                        return;
                    }
                    success(responseObject);
                    return;
                }
                failure(nil);
            } failure:^(NSError * _Nonnull error) {
                failure(error);
            }];
        }];
    }];
}

/** GET请求 */
+ (void)FirstGET:(NSString *)urlStr withParams:(NSDictionary  * _Nullable)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure {
 
    @try {
        //路径
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,urlStr];
        NSLog(@"[Adam][GET]请求参数:%@", [params mj_JSONString]);
        NSLog(@"[Adam][GET]请求：%@", url);
        [self request:url withParams:params success:^(id  _Nonnull responseObject) {
            if (![self notHideHUDView:urlStr]) {
                [MBProgressHUD hideHUD];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [KYRemindView dismiss];
                });
            }
            if (responseObject) {
                NSLog(@"[Adam][GET] 回應：%@", responseObject);
                if ([responseObject[@"code"] integerValue] != 0) {
                    if ([responseObject[@"code"] integerValue] == 909011) {
                        [UserModelTool save:nil];
                        LoginViewController *loginVc = [LoginViewController new];
                        GKNavigationController *nav = [[GKNavigationController alloc] initWithRootViewController:loginVc];
                        nav.modalPresentationStyle = 0;
                        nav.navigationBarHidden = YES;
                        [[CommonTools currentViewController] presentViewController:nav animated:YES completion:nil];
                    }else if ([responseObject[@"code"] integerValue] == 1 && [responseObject[@"msg"] isEqualToString:@"token invalid"]) {
                        //token过期了
                        [UserModelTool save:nil];
                        NSLog(@"[Adam][GET] token過期了!!");
                    }else {
                        [KYRemindView showWithStatus:responseObject[@"msg"]];
                    }
                    if (failure) {
                        failure(nil);
                    }
                }else {
                    if (success) {
                        NSLog(@"[Adam][GET]请求 成功");
                        success(responseObject);
                    }
                }
            }else {
                if (failure) {
                    failure(nil);
                }
            }
        } failure:^(NSError * _Nonnull error) {
            if (![self notHideHUDView:urlStr]) {
                [MBProgressHUD hideHUD];
                [KYRemindView dismiss];
            }
            [self showMsgWithError:error];
            if (failure) {
                failure(error);
            }
        }];
    } @catch (NSException *exception) {
        
    } @finally {
            
    }
    
}
 
/** GET请求 */
+ (void)GET:(NSString *)urlStr withParams:(id)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure {

    @try {
        //路径
        NSString *url = @"";
        if ((NSMutableDictionary *)params[@"account"]) {        // 新註冊
            url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"loginNew"];
            urlStr = @"loginNew";
        } else {
            url = [NSString stringWithFormat:@"%@%@",BaseUrl,urlStr];
        }
        NSLog(@"[Adam][GET]参数:%@", [(NSMutableDictionary *)params mj_JSONString]);
        NSLog(@"[Adam][GET]请求:%@", url);
        [MSNetwork setRequestTimeoutInterval:60.0f];
        [MSNetwork closeLog];
        [MSNetwork GET:url parameters:(NSMutableDictionary *)params headers:nil cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
            if (![self  notHideHUDView:urlStr]) {
                [MBProgressHUD hideHUD];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [KYRemindView dismiss];
                });
            }
            if (responseObject) {
                NSLog(@"[Adam][GET]返回:%@", [responseObject mj_JSONString]);
                if ([responseObject[@"code"] integerValue] != 0) {
                    if ([responseObject[@"code"] integerValue] == 909011) {
                        [UserModelTool save:nil];
                        LoginViewController *loginVc = [LoginViewController new];
                        GKNavigationController *nav = [[GKNavigationController alloc] initWithRootViewController:loginVc];
                        nav.modalPresentationStyle = 0;
                        nav.navigationBarHidden = YES;
                        [[CommonTools currentViewController] presentViewController:nav animated:YES completion:nil];
                    } else if ([responseObject[@"code"] integerValue] == 50012) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [MBProgressHUD showSuccess:responseObject[@"msg"] toView:nil];
                        });
                    }
                    else if ([responseObject[@"code"] integerValue] == 1 && [responseObject[@"msg"] isEqualToString:@"token invalid"]) {
                        //token过期了
                        [UserModelTool save:nil];
                        NSLog(@"[Adam][GET] token過期了!!");
                    } else if ([responseObject[@"code"] integerValue] == 7 ||
                               [responseObject[@"code"] integerValue] == -3 ||
                               [responseObject[@"code"] integerValue] == 50012) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [MBProgressHUD showSuccess:responseObject[@"msg"] toView:nil];
                        });
                    } else {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if ((NSMutableDictionary *)params[@"account"]) {
                                if ([responseObject[@"msg"] isEqualToString:@"验证码错误"]) {
                                    [KYRemindView showWithStatus: @"帐号或密码不正确"];
                                } else {
                                    [KYRemindView showWithStatus:responseObject[@"msg"]];
                                }
                            }
                        });
                    }
                    if (failure) {
                        failure(nil);
                    }
                }else {
                    if (success) {
                        NSLog(@"[Adam][GET]请求 成功");
                        success(responseObject);
                    }
                }
            }else {
                if (failure) {
                    failure(nil);
                }
            }
        } failure:^(NSError * _Nonnull error) {
            if (![self notHideHUDView:urlStr]) {
                [MBProgressHUD hideHUD];
                [KYRemindView dismiss];
            }
            [self showMsgWithError:error];
            if (failure) {
                failure(error);
            }
        }];
        
    } @catch (NSException *exception) {
        
    } @finally {
            
    }
}

/** GET请求 */
+ (void)GETNoHud:(NSString *)urlStr withParams:(NSDictionary  * _Nullable)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure {
    
       @try {
           //路径 
           NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,urlStr];
           if ([urlStr containsString:@"http"]) {
               url = urlStr;
           }
           NSLog(@"[Adam][GET]请求参数:%@", [params mj_JSONString]);
           NSLog(@"[Adam][GET]请求：%@", url);
           [MSNetwork setRequestTimeoutInterval:60.0f];
           [MSNetwork closeLog];
           [MSNetwork GET:url parameters:params headers:nil cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
               if (responseObject) {
                   if ([responseObject[@"code"] integerValue] != 0) {
                       if ([responseObject[@"code"] integerValue] == 909011) {
                           [UserModelTool save:nil];
                           LoginViewController *loginVc = [LoginViewController new];
                           GKNavigationController *nav = [[GKNavigationController alloc] initWithRootViewController:loginVc];
                           nav.modalPresentationStyle = 0;
                           nav.navigationBarHidden = YES;
                           [[CommonTools currentViewController] presentViewController:nav animated:YES completion:nil];
                       }else if ([responseObject[@"code"] integerValue] == 1 && [responseObject[@"msg"] isEqualToString:@"token invalid"]) {
                           //token过期了, 這邊之前有mark
                           [UserModelTool save:nil];
                           NSLog(@"[Adam][GET] token過期了!!");
                       }else {
                           [MBProgressHUD showError:responseObject[@"msg"] toView:nil];
                       }
                       if (failure) {
                           failure(nil);
                       }
                   }else {
                       if (success) {
                           NSLog(@"[Adam][GET]请求 成功");
                           success(responseObject);
                       }
                   }
               }else {
                   if (failure) {
                       failure(nil);
                   }
               }
           } failure:^(NSError * _Nonnull error) {
               if (failure) {
                   failure(error);
               }
           }];
           
       } @catch (NSException *exception) {
           
       } @finally {
               
       }
}

/** GET请求 */
+ (void)GETNoHud1:(NSString *)urlStr withParams:(NSDictionary  * _Nullable)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure {
    
       @try {
           //路径
           NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,urlStr];
           if ([urlStr containsString:@"http"]) {
               url = urlStr;
           }
           [MSNetwork setRequestTimeoutInterval:60.0f];
           [MSNetwork closeLog];
           [MSNetwork GET:url parameters:params headers:nil cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
               NSLog(@"[Adam][GET]请求参数:%@", [params mj_JSONString]);
               NSLog(@"[Adam][GET]请求：%@", url);
               if (responseObject) {
                   if (success) {
                       NSLog(@"[Adam][GET]请求 成功");
                       success(responseObject);
                   }
               }else {
                   if (failure) {
                       NSLog(@"[Adam][GET]请求 失敗");
                       failure(nil);
                   }
               }
           } failure:^(NSError * _Nonnull error) {
               if (failure) {
                   NSLog(@"[Adam][GET]请求 失敗");
                   failure(error);
               }
           }];
           
       } @catch (NSException *exception) {
           
       } @finally {
               
       }
}

/** POST请求 */
+ (void)POST:(NSString *)urlStr withParams:(NSDictionary  * _Nullable)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure {
 
    @try {
        //路径
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,urlStr];
        [MSNetwork setRequestTimeoutInterval:60.0f];
        [MSNetwork closeLog];
        [MSNetwork POST:url parameters:params headers:nil cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
            NSLog(@"[Adam][POST]请求参数:%@", [params mj_JSONString]);
            NSLog(@"[Adam][POST]请求：%@", url);
            if (![self notHideHUDView:urlStr]) {
                [MBProgressHUD hideHUD];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [KYRemindView dismiss];
                });
            }
            if (responseObject) {
                if ([responseObject[@"code"] integerValue] != 0) {
                    if ([responseObject[@"code"] integerValue] == 909011) {
                        [UserModelTool save:nil];
                        LoginViewController *loginVc = [LoginViewController new];
                        GKNavigationController *nav = [[GKNavigationController alloc] initWithRootViewController:loginVc];
                        nav.modalPresentationStyle = 0;
                        nav.navigationBarHidden = YES;
                        [[CommonTools currentViewController] presentViewController:nav animated:YES completion:nil];
                    }else if ([responseObject[@"code"] integerValue] == 1 && [responseObject[@"msg"] isEqualToString:@"token invalid"]) {
                        //token过期了
                        [UserModelTool save:nil];
                        NSLog(@"[Adam][POST] token過期了!!");
                    }else {
                        [KYRemindView showWithStatus:responseObject[@"msg"]];
                    }
                    if (failure) {
                        failure(nil);
                    }
                }else {
                    if (success) {
                        NSLog(@"[Adam][POST]请求 成功");
                        success(responseObject);
                    }
                }
            }else {
                if (failure) {
                    failure(nil);
                }
            }
        } failure:^(NSError * _Nonnull error) {
            if (![self notHideHUDView:urlStr]) {
                [MBProgressHUD hideHUD];
                [KYRemindView dismiss];
            }
            [self showMsgWithError:error];
            if (failure) {
                failure(error);
            }
        }];
        
    } @catch (NSException *exception) {
        
    } @finally {
            
    }
}

/** POST_TALK 请求 */
+ (void)POST_TALK:(NSString *)urlStr withParams:(NSDictionary  * _Nullable)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPMethod = @"POST";  // 指定 HTTP 方法為 POST
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    request.HTTPBody = jsonData;

    // 5️⃣ 使用 NSURLSession 發送請求
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"[Adam] 請求失敗: %@", error.localizedDescription);
            failure(error);
            return;
        }

        // 解析 JSON 回應
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"[Adam] 回應資料: %@", jsonResponse);
        success(jsonResponse);
    }];

    [task resume];
}


/** 单/多图上传 */
+ (void)UploadImage:(NSString *)urlStr withParams:(NSDictionary  * _Nullable)params withImages:(NSArray *)images success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure {
    
    [MSNetwork setRequestTimeoutInterval:60.0f];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,urlStr];
    [MSNetwork closeLog];
    NSLog(@"[Adam][上傳圖片]请求参数:%@", [params mj_JSONString]);
    NSLog(@"[Adam][上傳圖片]请求：%@", url);
    [MSNetwork uploadImageURL:url parameters:params?params:@{} headers:nil images:images name:@"image" fileName:@"fileImage" imageScale:1 imageType:@"png" progress:^(NSProgress * _Nonnull progress) {
        NSLog(@"上传进度:%.2f%%",100.0 * progress.completedUnitCount/progress.totalUnitCount);
    } success:^(id  _Nonnull responseObject) {
        if (![self notHideHUDView:urlStr]) {
            [MBProgressHUD hideHUD];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [KYRemindView dismiss];
            });
        }
        if (responseObject) {
            if ([responseObject[@"code"] integerValue] != 0) {
                if ([responseObject[@"code"] integerValue] == 909011) {
                    [UserModelTool save:nil];
                    LoginViewController *loginVc = [LoginViewController new];
                    GKNavigationController *nav = [[GKNavigationController alloc] initWithRootViewController:loginVc];
                    nav.modalPresentationStyle = 0;
                    nav.navigationBarHidden = YES;
                    [[CommonTools currentViewController] presentViewController:nav animated:YES completion:nil];
                }else if ([responseObject[@"code"] integerValue] == 1 && [responseObject[@"msg"] isEqualToString:@"token invalid"]) {
                    //token过期了
                    [UserModelTool save:nil];
                    NSLog(@"[Adam][上傳圖片] token過期");
                }else {
                    [KYRemindView showWithStatus:responseObject[@"msg"]];
                }
                if (failure) {
                    failure(nil);
                }
            }else {
                if (success) {
                    NSLog(@"[Adam][上傳圖片] 成功");
                    success(responseObject);
                }
            }
        }else {
            if (failure) {
                failure(nil);
            }
        }
    } failure:^(NSError * _Nonnull error) {
        if (![self notHideHUDView:urlStr]) {
            [MBProgressHUD hideHUD];
            [KYRemindView dismiss];
        }
        [self showMsgWithError:error];
        if (failure) {
            failure(error);
        }
    }];
     
}

+ (BOOL)notHideHUDView:(NSString *)url {
    BOOL isContain = NO;
    NSArray *urlArray = @[URL_Detail_Tabs, URL_FetchRoomID, URL_YXRoomID];
    if ([urlArray containsObject:url]) {
        isContain = YES;
    }
    return isContain;
}

+ (void)showMsgWithError:(NSError *)error {
    NSInteger codeint = error.code;
    if (codeint == (-999)) {
        
        [KYRemindView showWithStatus:@"网络请求超时！"];
    }else if (codeint == (-1001)) {
        [KYRemindView showWithStatus:@"网络请求超时！"];
    }else if (codeint == (-1009)) {
        // [KYRemindView showWithStatus:@"请检查您的网络！"];
   }else {
        //判断系统错误
       //[KYRemindView showWithStatus:@"系统繁忙"];
    }
}

+ (void)showMsgWithCode:(NSInteger)code {
    if (code == -2) {
        [KYRemindView showWithStatus:@"数据请求失败！"];
    }else if (code == -1) {
        [KYRemindView showWithStatus:@"参数格式不正确！"];
    }else if (code == 1) {
        [KYRemindView showWithStatus:@"登录失效，请重新登录"];
    }else if (code == 10001) {
        [KYRemindView showWithStatus:@"手机号码不正确"];
    }else if (code == 10002) {
        [KYRemindView showWithStatus:@"验证码为6位数字"];
    }else if (code == 10003) {
        [KYRemindView showWithStatus:@"账号或者密码不正确"];
    }else if (code == 10004) {
        [KYRemindView showWithStatus:@"账号已冻结"];
    }else if (code == 40002) {
        [KYRemindView showWithStatus:@"注册失败"];
    }else if (code == 40003) {
        [KYRemindView showWithStatus:@"账号已注册"];
    }else if (code == 40004) {
        [KYRemindView showWithStatus:@"账号未注册"];
    }else if (code == 40005) {
        [KYRemindView showWithStatus:@"验证码已过期"];
    }else if (code == 40006) {
        [KYRemindView showWithStatus:@"验证码不正确"];
    }else if (code == 40007) {
        [KYRemindView showWithStatus:@"验证码发送失败"];
    }else if (code == 50001) {
        [KYRemindView showWithStatus:@"服务器繁忙"];
    }else if (code == 50002) {
        [KYRemindView showWithStatus:@"非常抱歉，短信平台使用次数已达上限，请隔日使用!"];
    }else if (code == 50003) {
        [KYRemindView showWithStatus:@"当前在线用户过多，请刷新页面重新尝试"];
    }else if (code == 50004) {
        [KYRemindView showWithStatus:@"验证码发送失败"];
    }else if (code == 50005) {
        [KYRemindView showWithStatus:@"登录失败"];
    }else if (code == 50006) {
        [KYRemindView showWithStatus:@"无效的参数值"];
    }else if (code == 403) {
        [KYRemindView showWithStatus:@"拒绝访问"];
    }else if (code == 50009) {
        [KYRemindView showWithStatus:@"您暂无权限"];
    }else {
        [KYRemindView showWithStatus:@"操作失败，请重新操作"];
    }
}

/** GET请求 */
+ (void)GET_Account:(NSString *)urlStr withParams:(id)params success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * _Nullable error))failure {

    @try {
        //路径
        NSString *url = @"";
        url = [NSString stringWithFormat:@"%@%@",BaseUrl,urlStr];
        NSLog(@"[Adam][GET]参数:%@", [(NSMutableDictionary *)params mj_JSONString]);
        NSLog(@"[Adam][GET]请求:%@", url);
        [MSNetwork setRequestTimeoutInterval:60.0f];
        [MSNetwork closeLog];
        [MSNetwork GET:url parameters:(NSMutableDictionary *)params headers:nil cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
            if (![self notHideHUDView:urlStr]) {
                [MBProgressHUD hideHUD];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [KYRemindView dismiss];
                });
            }
            if (responseObject) {
                NSLog(@"[Adam][GET]返回:%@", [responseObject mj_JSONString]);
                if ([responseObject[@"code"] integerValue] != 0) {
                    if ([responseObject[@"code"] integerValue] == 909011) {
                        [UserModelTool save:nil];
                        LoginViewController *loginVc = [LoginViewController new];
                        GKNavigationController *nav = [[GKNavigationController alloc] initWithRootViewController:loginVc];
                        nav.modalPresentationStyle = 0;
                        nav.navigationBarHidden = YES;
                        [[CommonTools currentViewController] presentViewController:nav animated:YES completion:nil];
                    }else if ([responseObject[@"code"] integerValue] == 1 && [responseObject[@"msg"] isEqualToString:@"token invalid"]) {
                        //token过期了
                        [UserModelTool save:nil];
                        NSLog(@"[Adam][GET] token過期了!!");
                    }else {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [KYRemindView showWithStatus:responseObject[@"msg"]];
                        });
                    }
                    if (failure) {
                        failure(nil);
                    }
                }else {
                    if (success) {
                        NSLog(@"[Adam][GET]请求 成功");
                        success(responseObject);
                    }
                }
            }else {
                if (failure) {
                    failure(nil);
                }
            }
        } failure:^(NSError * _Nonnull error) {
            if (![self notHideHUDView:urlStr]) {
                [MBProgressHUD hideHUD];
                [KYRemindView dismiss];
            }
            [self showMsgWithError:error];
            if (failure) {
                failure(error);
            }
        }];

    } @catch (NSException *exception) {

    } @finally {

    }
}

@end
