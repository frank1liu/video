//
//  UIImage+Category.m
//  GKNavigationController
//
//  Created by QuintGao on 2017/6/20.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "UIImage+GKCategory.h"

@implementation UIImage (GKCategory)

// 根据颜色创建UIImage
+ (UIImage *)gk_imageWithColor:(UIColor *)color {
    return [self gk_imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)gk_imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
