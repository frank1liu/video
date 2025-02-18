//
//  SNPersionLeftViewController.m
//  SportNews
//
//  Created by kkk on 2021/4/6.
//

#import "SNPersionLeftViewController.h"
#import "CustomActivity.h"
#import "SNLeftTuiGuangView.h"
#import "SNMessageCell.h"
#import "LevelViewController.h"

extern UIImage *gChangedImage;

@interface SNPersionLeftViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UIView *levelBaseView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end
   
@implementation SNPersionLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNotification) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangedIconNotification:) name:@"ChangedIconNotification" object:nil];
    self.versionLabel.text = [NSString stringWithFormat:@"版本: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        self.nameLabel2.text = [NSString stringWithFormat:@"%@", loginModel.userinfo.nickname];
    }

    if (gChangedImage != nil) {
        self.iconImageView.image = gChangedImage;
    } else {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:loginModel.userinfo.head] placeholderImage:UIImageMake(@"personDef")];
    }
}

- (void)reloadView {
    [self loginSuccessNotification];
}

- (void)loginSuccessNotification {
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        if (gChangedImage != nil) {
            self.iconImageView.image = gChangedImage;
        } else {
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:loginModel.userinfo.head] placeholderImage:UIImageMake(@"personDef")];
        }
        self.iconImageView.layer.cornerRadius = _iconImageView.frame.size.width / 2;
        self.iconImageView.clipsToBounds = YES;
        self.nameLabel2.text = [NSString stringWithFormat:@"%@", loginModel.userinfo.nickname];
        self.levelImageView.image = [SNMessageCell getMessageLevelImage:loginModel.userinfo.level];
        [self showNickname:YES];
    }else {
        self.iconImageView.image = [UIImage imageNamed:@"personDef"];
        self.nameLabel.text = @"未登录";
        [self showNickname:NO];
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterCenterAction:)];
    [self.iconImageView setUserInteractionEnabled:YES];
    [self.iconImageView addGestureRecognizer:tap];
}

- (void)ChangedIconNotification:(NSNotification *)not {
    NSDictionary *dic = not.object;
    gChangedImage = dic[@"icon"];
    self.iconImageView.image = dic[@"icon"];
    self.iconImageView.layer.cornerRadius = _iconImageView.frame.size.width / 2;
    self.iconImageView.clipsToBounds = YES;
}

- (void)showNickname:(BOOL)enable {
    [self.nameLabel setHidden:enable];
    [self.levelBaseView setHidden:!enable];
}

- (void)setupSubViews {
    self.iconImageView.layer.cornerRadius = self.iconImageView.height/2;
    self.userBtn.layer.cornerRadius = self.userBtn.height/2;
    self.userBtn.layer.borderColor = RGBA(153, 153, 153, 0.5).CGColor;
    self.userBtn.layer.borderWidth = 0.5;
    [self loginSuccessNotification];
}
 
- (IBAction)hide:(id)sender {
    if (self.hideBlock) {
        self.hideBlock();
    }
}

- (IBAction)enterCenterAction:(id)sender {
    if (self.clickOtherBlock) {
        self.clickOtherBlock(1);
    }
}

// 反饋意見
- (IBAction)suggestAction:(id)sender {
    if (self.clickOtherBlock) {
        self.clickOtherBlock(2);
    }
}

// 我的意見
- (IBAction)showMyLevel:(id)sender {
//    LevelViewController *vc = [LevelViewController new];
//    UIViewController *top = [self topMostController];
//    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
//    [top presentViewController:vc animated:YES completion:nil];
    if (self.clickOtherBlock) {
        self.clickOtherBlock(3);
    }
}

// 推廣合作
- (IBAction)tuiGuangAction:(id)sender {
    [SNLeftTuiGuangView showView];
}


- (IBAction)QQAction:(id)sender {
    [self shareMethod];
}

- (IBAction)weixinAction:(id)sender {
    [self shareMethod];
}

- (IBAction)pengyouAction:(id)sender {
    [self shareMethod];
}

- (void)shareMethod {
     
    NSDictionary *param = @{
        @"pid" : @"4"
    };
    [KYRemindView show];
    [KYApiHttpTool GET:URL_ShareText withParams:param success:^(NSDictionary * _Nonnull response) {
        // 1、设置分享的内容，并将内容添加到数组中
        NSString *shareText = response[@"share_txt"];
        UIImage *shareImage = [UIImage imageNamed:@"1024Logo.png"];
        NSString *shareUrlStr = response[@"share_url"];
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
        
    } failure:^(NSError * _Nonnull error) {
    }];
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}

@end
