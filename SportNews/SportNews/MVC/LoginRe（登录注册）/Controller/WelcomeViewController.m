//
//  WelcomeViewController.m
//  SportNews
//
//  Created by kkk on 2021/1/12.
//

#import "WelcomeViewController.h"
#import "PlayerViewController.h"
#import "MSNetwork.h"
#import "SportNews-Swift.h"

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

//记录倒计时
@property (nonatomic,assign) NSInteger countDownTime;
@property (nonatomic,strong) NSTimer *timer;

@property(nonatomic, assign) BOOL isSuccess;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) DNSManager *dnsManager;
@property (nonatomic,strong) AppDelegate *app;
@property (nonatomic) BOOL isReqSucDynUrl;
@property (nonatomic, assign) BOOL hasFoundValidUrl;
@property (nonatomic, assign) BOOL hasSetDomain;

@end

@implementation WelcomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChannelName) name:@"NetworkAvailable" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (![self.navigationController.viewControllers containsObject:self]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.dnsManager = [DNSManager shared];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config];
    self.isReqSucDynUrl = NO;
    self.hasFoundValidUrl = NO;
    self.hasSetDomain = NO;
    self.backView.hidden = YES;
    
    [self setAvailableDomain];
    // 無用到
    // [self getDomainName];
}

- (void)networkAvailable {
    if (self.hasSetDomain == NO) {
        [self setAvailableDomain];
    }
}

- (void) setAvailableDomain {
    NSArray<NSString *> *urls = self.dnsManager.domains;

    self.isReqSucDynUrl = YES;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *url in urls) {
            if (self.hasFoundValidUrl) break;

            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

            [self.dnsManager getIPForDomain:url completion:^(NSString *resolvedIP, NSError *error) {
                if (resolvedIP) {
                    @try {
                        NSString *path = [NSString stringWithFormat:@"https://%@/prod-api/", url];
                        NSURL *urlss = [NSURL URLWithString:path];
                        NSData *data = [[NSData alloc] initWithContentsOfURL:urlss];
                        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                        if ([d[@"msg"] isEqualToString:@"ok"]) {
                            if (!self.hasFoundValidUrl) {
                                self.hasFoundValidUrl = YES;
                                self.isReqSucDynUrl = NO;
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                [defaults setObject:url forKey:@"app_net_root_url"];
                                [defaults synchronize];
                                NSLog(@"%@", url);
                                self.app.availableDomain = url;
                                [self.app setChannelName];
                                [self.app getChannelName];
                                //极光
                                // [self setupJPush:application didFinishLaunchingWithOptions:launchOptions];
                                // 云信
                                [self.app setupNIM];
                                self.hasSetDomain = YES;
                            }
                        }
                        dispatch_semaphore_signal(semaphore);
                    } @catch (NSException *exception) {
                        NSLog(@"%@", exception.reason);
                        dispatch_semaphore_signal(semaphore);
                    }
                } else {
                    dispatch_semaphore_signal(semaphore);
                }
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        if (!self.hasFoundValidUrl){
            self.hasSetDomain = YES;
            self.app.availableDomain = urls[0];
            [self.app setChannelName];
            [self.app getChannelName];
            //极光
            // [self setupJPush:application didFinishLaunchingWithOptions:launchOptions];
            // 云信
            [self.app setupNIM];
        }
    });
    [self endTimer:1.2];
}

- (void)getDomainName {
    
    [KYApiHttpTool GETNoHud:URL_GetBaseUrlFirst withParams:nil success:^(NSDictionary * _Nonnull response) {
        SNGlobalShared.baseUrl = response[@"api_url"];
        SNGlobalShared.socketUrl = response[@"ws_api_url"];
        [[NSUserDefaults standardUserDefaults] setValue:SNGlobalShared.baseUrl forKey:Local_BaseUrl];
        [[NSUserDefaults standardUserDefaults] setValue:SNGlobalShared.socketUrl forKey:Local_SocketUrl];
        self.isSuccess = YES;
        [self getJPushAccount];

    } failure:^(NSError * _Nonnull error) {
        
        [KYApiHttpTool GETNoHud:URL_GetBaseUrlSecond withParams:nil success:^(NSDictionary * _Nonnull response) {
            SNGlobalShared.baseUrl = response[@"api_url"];
            SNGlobalShared.socketUrl = response[@"ws_api_url"];
            [[NSUserDefaults standardUserDefaults] setValue:SNGlobalShared.baseUrl forKey:Local_BaseUrl];
            [[NSUserDefaults standardUserDefaults] setValue:SNGlobalShared.socketUrl forKey:Local_SocketUrl];
            self.isSuccess = YES;
            [self getJPushAccount];

        } failure:^(NSError * _Nonnull error) {
             
        }]; 
    }];
    [self endTimer:0.8];
}

- (void) endTimer:(CGFloat)deadline {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(deadline * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self countDown];
    });
}

- (void)getJPushAccount {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *regid = [[NSUserDefaults standardUserDefaults] objectForKey:JPushRegistrationID];
    if (regid) {
        [appDelegate getJPushAccount:regid];
    }
    [appDelegate getChannelName];
    [appDelegate checkYXIsLogined];
}

- (void)countDown {
    [self timeOver];  
}

- (void)countDownNumbers {
    self.countDownTime -= 1;
    self.timeLabel.text = [NSString stringWithFormat:@"跳过%lds",(long)self.countDownTime];
    if (self.countDownTime == 0) {
        [self timeOver];
    }
}

- (void)timeOver {
    [self.timer invalidate];
    self.timer = nil;
    [self.navigationController pushViewController:[[PlayerViewController alloc] init] animated:NO];
    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    self.navigationController.viewControllers = @[vc];
}


- (IBAction)clipAction:(UIButton *)sender {
    [self timeOver];
}




@end
