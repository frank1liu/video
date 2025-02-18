//
//  CommonWebViewController.m
//  StockExchange
//
//  Created by K哥 on 2020/12/15.
//

#import "CommonWebViewController.h"
#import <WebKit/WebKit.h>
#import "KKWebProgressLayer.h"
#import "RegexKitLite.h"

@interface CommonWebViewController ()<UIGestureRecognizerDelegate,WKNavigationDelegate,WKUIDelegate>
 
@property (nonatomic , strong) WKWebView *webView;
//  进度条
@property (nonatomic, strong) KKWebProgressLayer *webProgressLayer;

@property (nonatomic , strong) UIView *loadBackView;


@end

@implementation CommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWKWebView];
       
}
  
- (void)setupWKWebView {
      
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavHeight, kScreenWidth, kScreenHeight-NavHeight) configuration:config];
    [self.view addSubview:_webView];
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    _webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.loadBackView];
   
    if (self.url.length > 0) {
        if (![self.url hasPrefix:@"http"]) {
            self.url = [NSString stringWithFormat:@"https://%@",self.url];
        }
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [_webView loadRequest:request];
    }
    
    if (self.content.length > 0) {
        NSString *content = self.content;
        NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>";
        NSString *imgRegex = @"<\\s*img\\s+([^>]*)\\s*>";
        NSString *srcRegex = @"src=\"?(.*?)(\"|>|\\s+)";
        NSArray *matchArray = [content componentsMatchedByRegex:imgRegex];
        //首先： 将所有图片取出遍历内容，添加懒加载。 判断图片中是否有w&h，老新闻没有，新新闻按照图片比例展示图片确定坐标。
        for (NSString *p_img in matchArray) {
            NSString *srcStr = [p_img stringByMatching:srcRegex];
            content = [content stringByReplacingOccurrencesOfString:p_img withString:[NSString stringWithFormat:@"<img %@/>", srcStr]];
        }
        [self.webView loadHTMLString:[headerString stringByAppendingString:content] baseURL:nil];
    }
    _webProgressLayer = [[KKWebProgressLayer alloc] init];
    _webProgressLayer.frame = CGRectMake(0, NavHeight-2, kScreenWidth, 2);
    [self.navView.layer addSublayer:_webProgressLayer];
    [self.view bringSubviewToFront:self.navView];
}

 

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [_webProgressLayer startLoad];
}


// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_webProgressLayer finishedLoadWithError:nil];
    [self.loadBackView removeFromSuperview];

}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [_webProgressLayer finishedLoadWithError:nil];
    [self.loadBackView removeFromSuperview];
}
  
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.loadBackView removeFromSuperview];
    
}

// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)dealloc {
    [_webProgressLayer closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}

- (UIView *)loadBackView {
    if (!_loadBackView) {
        _loadBackView = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, kScreenWidth, kScreenHeight-NavHeight)];
        _loadBackView.backgroundColor = VCBackgroundColor;
    }
    return _loadBackView;
}


@end
