//
//  KYImageTool.h
//  ScenicNav
//
//  Created by laoK on 2019/1/24.
//  Copyright © 2019 xhkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

//图片本地化存储
@interface KYImageTool : NSObject

//将图片保存到本地
+ (void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key;

//本地是否有相关图片
+ (BOOL)LocalHaveImage:(NSString*)key;

//从本地获取图片
+ (UIImage*)GetImageFromLocal:(NSString*)key;

//将图片从本地删除
+ (void)RemoveImageToLocalKeys:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
