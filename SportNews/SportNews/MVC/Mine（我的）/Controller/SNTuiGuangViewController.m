//
//  SNTuiGuangViewController.m
//  SportNews
//
//  Created by kkk on 2021/5/13.
//

#import "SNTuiGuangViewController.h"

@interface SNTuiGuangViewController ()

@end

@implementation SNTuiGuangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    self.titleString = @"合作推广";
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, kScreenWidth, kScreenHeight - NavHeight)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenWidth*2004/1125);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*2004/1125)];
    imageView.image = [UIImage imageNamed:@"组 1"];
    imageView.contentMode = 1;
    [scrollView addSubview:imageView];
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction)];
    [imageView addGestureRecognizer:longTap];
    imageView.userInteractionEnabled = YES;
    
}

- (void)longPressAction {
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = @"1748270946";
    [MBProgressHUD showSuccess:@"QQ复制成功" toView:nil];
}

@end
