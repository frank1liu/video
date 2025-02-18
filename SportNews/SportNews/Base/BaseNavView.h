//
//  BaseNavView.h
//  ScenicNav
//
//  Created by laoK on 2019/1/12.
//  Copyright © 2019 xhkj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NavStateStyle) {
    NavStateStyleLight,
    NavStateStyleDark,
};

@interface BaseNavView : UIView

@property (nonatomic , strong) UIButton *rightButton;
@property (nonatomic , strong) UIButton *leftButton;

@property (nonatomic , strong) UIImageView *leftImageView;
@property (nonatomic , strong) UIImageView *rightImageView;

@property (nonatomic , strong) UIImageView *backImageView;

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) NSString  *title;
@property (nonatomic , strong) UIColor *titleColor;
@property (nonatomic , assign) BOOL hiddenLineView;
@property (nonatomic , assign) BOOL hiddenBackImage;
@property (nonatomic , assign) BOOL hiddenLeft;

@property (nonatomic , copy) NSString *rightTitle;

//当前状态
@property (nonatomic, assign) NavStateStyle currentStyle;

- (void)leftItemWithImageName:(nullable NSString *)imageName leftTitle:(nullable NSString *)title size:(CGSize )size target:(id)target action:(SEL)action;
- (void)rightItemWithImageName:(nullable NSString *)imageName rightTitle:(nullable NSString *)title size:(CGSize )size target:(id)target action:(SEL)action;


@end

NS_ASSUME_NONNULL_END
