//
//  UIColor+ZXLazy.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright © 2020 Talk2all (HK) Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZXLazy)
 

/**
 *  16进制转uicolor
 *
 *  @param color @"#FFFFFF" ,@"OXFFFFFF" ,@"FFFFFF"
 *
 *  @return uicolor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;
 
+ (UIColor *)generateDynamicColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;


@end
