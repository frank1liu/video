//
//  SuggestionViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/8.
//

#import "PrivateTalkViewController.h"
#import "SNUserWebViewController.h"

extern NSString *talkWebUrl;

@interface PrivateTalkViewController ()
@property (nonatomic, strong) SNUserWebViewController *talkWebVC;
@end

@implementation PrivateTalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"福利专员";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self showTalkBaseView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideTalkBaseView];
}

- (void)showTalkBaseView {
    self.talkWebVC = nil;
    self.talkWebVC = [[SNUserWebViewController alloc]init];
    self.talkWebVC.url = talkWebUrl;
    [self addChildViewController:self.talkWebVC];
    self.talkWebVC.view.frame = CGRectMake(0, NavHeight, kScreenWidth, kScreenHeight -NavHeight);
    [self.view addSubview:self.talkWebVC.view];
    [self.view bringSubviewToFront:self.talkWebVC.view];
    [self.talkWebVC setWebViewSize:self.talkWebVC.view.bounds];
}

- (void)hideTalkBaseView {
    [self.talkWebVC willMoveToParentViewController:nil];
    [self.talkWebVC.view removeFromSuperview];
    [self.talkWebVC removeFromParentViewController];
    self.talkWebVC = nil;
}

@end
