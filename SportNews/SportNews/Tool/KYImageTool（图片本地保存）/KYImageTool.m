//
//  KYImageTool.m
//  ScenicNav
//
//  Created by laoK on 2019/1/24.
//  Copyright © 2019 xhkj. All rights reserved.
//

#import "KYImageTool.h"

@implementation KYImageTool


//将图片保存到本地
+ (void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key {
    
    //首先,需要获取沙盒路径
    NSString *picPath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),key];
    BOOL isHaveImage = [self LocalHaveImage:key];
    if (isHaveImage) {
        [self RemoveImageToLocalKeys:key];
    }
    
    NSData *imgData = UIImageJPEGRepresentation(image,0.5);
    [imgData writeToFile:picPath atomically:YES];
    
}


//从本地获取图片
+ (UIImage*)GetImageFromLocal:(NSString*)key {
    
    if (!key) {
        return nil;
    }
    //读取本地图片非resource
    NSString *picPath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),key];
    UIImage *img=[[UIImage alloc]initWithContentsOfFile:picPath];
    return img;
}

//本地是否有图片
+ (BOOL)LocalHaveImage:(NSString*)key {
    if (!key) {
        return NO;
    }
    //读取本地图片非resource
    NSString *picPath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),key];
    UIImage *img=[[UIImage alloc]initWithContentsOfFile:picPath];
    if (img) {
        return YES;
    }
    return NO;
}


//将图片从本地删除
+ (void)RemoveImageToLocalKeys:(NSString*)key {
    NSString *picPath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),key];
    [[NSFileManager defaultManager] removeItemAtPath:picPath error:nil];
}


@end
