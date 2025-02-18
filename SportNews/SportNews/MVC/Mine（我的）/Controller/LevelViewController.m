//
//  SuggestionViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/8.
//

#import "LevelViewController.h"
#import "MBProgressHUD.h"
#import "WebKit/WebKit.h"

@interface LevelViewController ()<UITextViewDelegate>

// @property (strong, nonatomic) IBOutlet WKWebView *web;

@end

@implementation LevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"等级";
    // self.navView.hiddenLineView = NO;

    // [MBProgressHUD showLoading];
    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 88, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [web setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:web];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://kzbb11nw.com/user/level"]];
    [web loadRequest:request];
}

@end
