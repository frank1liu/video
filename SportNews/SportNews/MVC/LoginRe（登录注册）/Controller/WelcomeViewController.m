//
//  WelcomeViewController.m
//  SportNews
//
//  Created by kkk on 2021/1/12.
//

#import "WelcomeViewController.h"
#import "PlayerViewController.h"
#import "MSNetwork.h"

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

//记录倒计时
@property (nonatomic,assign) NSInteger countDownTime;
@property (nonatomic,strong) NSTimer *timer;

@property(nonatomic, assign) BOOL isSuccess;

@end

@implementation WelcomeViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (![self.navigationController.viewControllers containsObject:self]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backView.hidden = YES;
    [self getDomainName];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
//    self.backView.hidden = NO;
//    self.backView.layer.cornerRadius = self.backView.height/2;
//    self.countDownTime = 3;
//    self.timeLabel.text = @"跳过3s";
//    if (self.timer) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDownNumbers) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
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
