//
//  BaseViewController.m
//  V-talk
//
//  Created by K哥 on 2020/4/1.
//  Copyright © 2020 K哥. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated { 
    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupOtherParams];
}

- (void)setupOtherParams {
    
    self.view.backgroundColor = VCBackgroundColor;
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.navView];
    [self.navView leftItemWithImageName:@"icon_返回" leftTitle:nil size:CGSizeMake(25, 25) target:self action:@selector(popViewBack)];
    
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.navView.title = titleString;
}
- (void)setTitleColor:(UIColor *)titleColor {
    self.navView.titleColor = titleColor;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)popViewBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews {
    
    CGSize size = CGSizeMake(kScreenWidth, NavHeight);
    self.navView.size = size;
}
  
- (BaseNavView *)navView {
    if (!_navView) {
        _navView = [[BaseNavView alloc] init];
        _navView.hiddenLineView = YES;
    }
    return _navView;
}

- (void)dealloc {
    NSLog(@"---:%@被销毁了",NSStringFromClass([self class]));
}
 

@end
