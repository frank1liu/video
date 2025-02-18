//
//  SuggestionViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/8.
//

#import "VoiceWebViewController.h"
#import "MBProgressHUD.h"
#import "WebKit/WebKit.h"

@interface VoiceWebViewController ()<UITextViewDelegate>

// @property (strong, nonatomic) IBOutlet WKWebView *web;

@end

@implementation VoiceWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"任務";
    // self.navView.hiddenLineView = NO;

    // [MBProgressHUD showLoading];
    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 88, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [web setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:web];

    LoginUserModel *loginModel = [UserModelTool loginModel];
    NSDictionary *dic = [loginModel mj_keyValues];
    NSString *userinfo = [CommonTools dictionaryToJson:dic];

    NSDictionary *cookieProperties1 = @{
            NSHTTPCookieDomain: @"kzbbckjl.com",  // 你的域名
            NSHTTPCookiePath: @"/",
            NSHTTPCookieName: @"userinfo",
            NSHTTPCookieValue: userinfo,
            NSHTTPCookieSecure: @NO,
            NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 7] // 7 天有效
        };

    NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:cookieProperties1];

    NSDictionary *cookieProperties2 = @{
            NSHTTPCookieDomain: @"kzbbckjl.com",  // 你的域名
            NSHTTPCookiePath: @"/",
            NSHTTPCookieName: @"im_account",
            NSHTTPCookieValue: @"13545674567",
            NSHTTPCookieSecure: @NO,
            NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 7] // 7 天有效
        };

    NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:cookieProperties2];

    NSDictionary *cookieProperties3 = @{
            NSHTTPCookieDomain: @"kzbbckjl.com",  // 你的域名
            NSHTTPCookiePath: @"/",
            NSHTTPCookieName: @"im_pwd",
            NSHTTPCookieValue: @"123456",
            NSHTTPCookieSecure: @NO,
            NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 7] // 7 天有效
        };

    NSHTTPCookie *cookie3 = [NSHTTPCookie cookieWithProperties:cookieProperties3];

    // 存入 NSHTTPCookieStorage
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookie:cookie1];
    [cookieStorage setCookie:cookie2];
    [cookieStorage setCookie:cookie3];


    // 确保 UIWebView 能加载 Cookie
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://kzbbckjl.com/user/mission"]];
    [web loadRequest:request];
}

@end
