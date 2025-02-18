//
//  SNUserViewController.m
//  SportNews
//
//  Created by kkk on 2021/5/10.
//

#import "SNUserViewController.h"
#import "CustomActivity.h"
#import "MineInfoViewController.h"
#import "SuggestionViewController.h" 
#import "SNMissionCenterViewController.h"
#import "SportNews-Swift.h"
#import "SNTuiGuangViewController.h"
#import "SNMineInviteViewController.h"

@interface SNUserViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *qiandaoBtn;

@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *yinlangCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *duihuanBtn;

@property (weak, nonatomic) IBOutlet UIView *litterBackView;
@property (weak, nonatomic) IBOutlet UIView *litterBackView1;


@end

@implementation SNUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setupSubView {
    self.titleString = @"个人中心";
    self.view.backgroundColor = SRGB(251);
    self.duihuanBtn.layer.cornerRadius = 14; 
    [CommonTools setupViewLayer:self.topBackView];
    [CommonTools setupViewLayer:self.litterBackView];
    [CommonTools setupViewLayer:self.litterBackView1];
}
  
- (void)jumpShopping {
    SNShoppingVC *vc = [SNShoppingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)enterCenterAction:(id)sender {
    //个人中心
    MineInfoViewController *VC = [[MineInfoViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

//签到
- (IBAction)qiandaoAction:(id)sender {
    
}

//兑换商城
- (IBAction)duihuanAction:(id)sender {
    SNShoppingVC *vc = [SNShoppingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

//任务中心
- (IBAction)renwuZhongxinAction:(id)sender {
    SNMissionCenterViewController *VC = [[SNMissionCenterViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

//邀请
- (IBAction)yaoqingAction:(id)sender {
    SNMineInviteViewController *VC = [[SNMineInviteViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)suggestAction:(id)sender {
    SuggestionViewController *VC = [[SuggestionViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)tuiGuangAction:(id)sender {
    SNTuiGuangViewController *VC = [[SNTuiGuangViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
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

- (IBAction)loginOutAction:(id)sender {
    [self outLoginAction];
}

- (void)outLoginAction {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertT = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loginOutAction];
    }];
    UIAlertAction *alertF = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheet addAction:alertT];
    [actionSheet addAction:alertF];
    [[actionSheet popoverPresentationController] setSourceView:self.view];
    [[actionSheet popoverPresentationController] setSourceRect:CGRectMake(0,0,1,1)];
    [[actionSheet popoverPresentationController] setPermittedArrowDirections:UIPopoverArrowDirectionUp];
    [self presentViewController:actionSheet animated:YES completion:nil];
 
}

- (void)loginOutAction {
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





@end
