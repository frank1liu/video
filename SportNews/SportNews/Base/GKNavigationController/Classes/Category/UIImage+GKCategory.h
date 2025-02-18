//
//  UIImage+Category.h
//  GKNavigationController
//
//  Created by QuintGao on 2017/6/20.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GKCategory)

// 根据颜色创建UIImage
+ (UIImage *)gk_imageWithColor:(UIColor *)color;

+ (UIImage *)gk_imageWithColor:(UIColor *)color size:(CGSize)size;

@end
