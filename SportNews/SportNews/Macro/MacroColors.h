//
//  MacroColors.h
//  ScenicNav
//
//  Created by laoK on 2019/1/14.
//  Copyright © 2019 xhkj. All rights reserved.
//

#ifndef MacroColors_h
#define MacroColors_h
 
//蓝绿色
#define Blue_Color RGB(39, 197, 195)
//蓝绿色 -浅色
#define Blue_Light_Color RGBA(125, 220, 219, 0.2)
 
//橙色
#define Origin_Color RGB(249, 117, 34)
//橙色 -浅色
#define Origin_Light_Color RGBA(255, 181, 135, 0.2)


//红色
#define red_Color RGB(251, 75, 75)

//黄色
#define yellow_Color RGB(246, 189, 53)


//按钮不可点击字体颜色
#define btnUnableTitleColor SRGB(255)

//按钮可点击字体颜色
#define btnTitleColor UIColor.whiteColor

//按钮不可点击背景颜色
#define btnUnableBackColor SRGB(237)

//按钮可点击颜色
#define btnBackColor Blue_Color

//title color 标题颜色
#define commonTextColor [UIColor blackColor]

//subtitle color 子标题颜色
#define commonSubTextColor RGB(180, 180, 180)

//控制器背景颜色
#define VCBackgroundColor SRGB(255)
 
//划线颜色
#define lineViewColor SRGB(200)
   
  
#define titleTextColor RGB(51, 51, 51)

#define mainTextColor RGB(150, 150, 150)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#endif /* MacroColors_h */
