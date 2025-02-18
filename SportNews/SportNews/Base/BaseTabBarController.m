//
//  BaseTabBarController.m
//  ScenicNav
//
//  Created by laoK on 2018/12/28.
//  Copyright © 2018 xhkj. All rights reserved.
//

#import "BaseTabBarController.h"
#import "LoginViewController.h"
#import "PlayerViewController.h"
 
@interface BaseTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) NSInteger lastIndex;
@end


@implementation BaseTabBarController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTabBar];
    
    [self setupTabbar];
 
}

- (void)viewWillLayoutSubviews {
    [self setupTabbar];
}

- (void)setupTabbar {
    
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = Blue_Color;
    UIImage *backImage = [UIImage createImageWithColor:VCBackgroundColor];
    [self.tabBar setBackgroundImage:backImage];
    [self.tabBar setShadowImage:backImage];
}

//creat subVC
- (void)createTabBar{
     
    self.delegate = self;
    
    GKNavigationController *nav = [self createControllerWithTitle:@"赛况".localized image:@"奖杯"selectedimage:@"奖杯" className:[PlayerViewController class]];
      
     
    self.viewControllers = @[nav];

}

//comment way
- (GKNavigationController *)createControllerWithTitle:(NSString *)title image:(NSString *)image selectedimage:(NSString *)selectedimage  className:(Class)class{
    
    UIViewController *vc = [[class alloc] init];
    vc.hidesBottomBarWhenPushed = NO;
    GKNavigationController *nav = [[GKNavigationController alloc] initWithRootViewController:vc];
    nav.navigationBarHidden = YES;
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:image] tag:0];
//    tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem = tabBarItem;
     
    return nav;
}


@end
