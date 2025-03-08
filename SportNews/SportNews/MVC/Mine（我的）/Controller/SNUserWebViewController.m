//
//  SNUserWebViewController.m
//  SportNews
//
//  Created by kkk on 2021/5/21.
//

#import "SNUserWebViewController.h"
#import <WebKit/WebKit.h>
#import "KKWebProgressLayer.h"
#import "RegexKitLite.h"
#import "CustomActivity.h"
#import "SNUserShareModel.h"


@interface SNUserWebViewController ()<UIGestureRecognizerDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
 
@property (nonatomic , strong) WKWebView *webView;

@property(nonatomic, strong) UIView *topView;

@end


@implementation SNUserWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWKWebView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"getUserInfo"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"ShareIn"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"LoginOut"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"BackOnclick"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"EnterMission"];
}

- (void)setWebViewSize:(CGRect)frame {
    _webView.frame = frame;
}

- (void)setupWKWebView {
    WKUserContentController *userContentController = WKUserContentController.new;
    // 注册js方法
    [userContentController addScriptMessageHandler:self name:@"getUserInfo"];
    [userContentController addScriptMessageHandler:self name:@"ShareIn"];
    [userContentController addScriptMessageHandler:self name:@"LoginOut"];
    [userContentController addScriptMessageHandler:self name:@"BackOnclick"];
    [userContentController addScriptMessageHandler:self name:@"EnterMission"];
    /// 设置网页请求的cookie
    NSString *cookieSource = [NSString stringWithFormat:@"document.cookie = 'userinfo=%@';", [self getLoginString]];
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContentController;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NavHeight-44)];
    self.topView.hidden = YES;
    [self.view addSubview:self.topView];
    CAGradientLayer* gradinentlayer=[CAGradientLayer layer];
    gradinentlayer.colors=@[(__bridge id)RGB(25, 171, 245).CGColor,(__bridge id)RGB(114, 250, 142).CGColor];
    gradinentlayer.locations = @[@0.0,@1.0];
    gradinentlayer.startPoint = CGPointMake(0, 0.5);
    gradinentlayer.endPoint = CGPointMake(1, 0.5);
    gradinentlayer.frame = CGRectMake(0, 0, kScreenWidth, NavHeight-44);
    [self.topView.layer addSublayer:gradinentlayer];

    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavHeight-44, kScreenWidth, kScreenHeight -NavHeight +44) configuration:config];

    // _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 515) configuration:config];

    [self.view addSubview:_webView];
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    _webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [request setValue:@"sqd_ios" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"sqd_ios" forHTTPHeaderField:@"UserAgent"];
    /// 设置内部请求cookie
    [request setValue:[NSString stringWithFormat:@"userinfo=%@", [self getLoginString]] forHTTPHeaderField:@"Cookie"];
    
    /// 设置user agent
    [self.webView setCustomUserAgent:@"sqd_ios"];
    [self.webView loadRequest:request];
    
    [KYRemindView show];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view bringSubviewToFront:self.navView];
    
}

- (NSString *)getLoginString {
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        NSDictionary *dic = [loginModel mj_keyValues];
        NSString *loginString = [[CommonTools convertToJsonData:dic] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        return loginString;
    }
    return @"";
}

- (NSString *)getLoginStringNoURLEncode {
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        NSDictionary *dic = [loginModel mj_keyValues];
        NSString *loginString = [CommonTools convertToJsonData:dic];
        return loginString;
    }
    return @"";
}

- (void)getUserInfo {
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"ios_getUserInfo('%@')",[self getLoginStringNoURLEncode]] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
}

- (void)ShareIn:(WKScriptMessage *)message {
    SNUserShareModel *body = [SNUserShareModel mj_objectWithKeyValues:message.body];
    // 1、设置分享的内容，并将内容添加到数组中
    NSString *shareText = body.desc;
    UIImage *shareImage = [UIImage imageNamed:@"1024Logo.png"];
    NSString *shareUrlStr = body.share_url;
    NSURL *shareUrl = [NSURL URLWithString:shareUrlStr];
    NSArray *activityItemsArray = @[shareText,shareImage,shareUrl];
    CustomActivity *customActivity = [[CustomActivity alloc]initWithTitle:shareText ActivityImage:[UIImage imageNamed:@"1024Logo.png"] URL:shareUrl ActivityType:@"Custom"];
    NSArray *activityArray = @[customActivity];
    // 2、初始化控制器，添加分享内容至控制器
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:activityArray];
    // 3、设置回调
    // ios8.0 之后用此方法回调
    UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        NSLog(@"activityType == %@",activityType);
        if (completed == YES) {
            NSLog(@"completed");
        }else{
            NSLog(@"cancel");
        }
    };
    activityVC.completionWithItemsHandler = itemsBlock;
    // 4、调用控制器
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)LoginOut {
    [KYRemindView show];
    LoginUserModel *loginModel = [UserModelTool loginModel];
    NSDictionary *param = @{
        @"uid":loginModel.userinfo.ids,
        @"token":loginModel.token
    };
    [KYApiHttpTool GET:URL_LoginOut withParams:param success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] isEqualToString:@"0"]) {
            [UserModelTool save:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showSuccess:@"退出登录失败!" toView:nil];
        }
    } failure:^(NSError * _Nonnull error) {
       
    }];
}

- (void)BackOnclick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"收到web调用:%@", message.name);
    self.topView.hidden = YES;
    if ([message.name isEqualToString:@"getUserInfo"]) {
        [self getUserInfo];
    }else if ([message.name isEqualToString:@"ShareIn"]) {
        [self ShareIn:message];
    }else if ([message.name isEqualToString:@"LoginOut"]) {
        [self LoginOut];
    }else if ([message.name isEqualToString:@"BackOnclick"]) {
        [self BackOnclick];
    }else if ([message.name isEqualToString:@"EnterMission"]) {
        self.topView.hidden = NO;
    }
}
 
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    //读取wkwebview中的cookie 方法1
    for (NSHTTPCookie *cookie in cookies) {
         [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.navView.hidden = YES;
}


// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.navView.hidden = YES;
    [KYRemindView dismiss];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    self.navView.hidden = NO;
    [KYRemindView dismiss];
}
  
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)dealloc {
    
}

@end
