//
//  CustomAlertView.h
//  CustomAlertView
//
//  Created by lanshang on 21/4/15.
//  Copyright © 2021年 kiss. All rights reserved.
//

#import <UIKit/UIKit.h>

  
@interface CustomAlertView : UIView

@property (nonatomic, copy) void(^otherBtnBlock)(NSInteger tag);
 
//是否强制更新
@property (nonatomic,assign)BOOL isQiangzhi;

//是否详情label是否靠左显示
@property (nonatomic,assign)BOOL isLeft;
  
- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title Detail:(NSString *)detail CancelTitle:(NSString *)cancelTitel OtherTitle:(NSString *)otherTitle IsOneBtn:(BOOL)isOneBtn;

@end

