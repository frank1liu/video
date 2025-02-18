//
//  SNMineInviteViewController.m
//  SportNews
//
//  Created by kkk on 2021/5/13.
//

#import "SNMineInviteViewController.h"
#import "CustomActivity.h"
#import "SportNews-Swift.h"

@interface SNMineInviteViewController ()


@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *inviteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@end

@implementation SNMineInviteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupSubViews];
    
}

- (void)setupSubViews {
    self.titleString = @"我的邀请";
    self.contentViewHeight.constant = kScreenWidth*700/375;
    [CommonTools setupViewLayer:self.backView];
}

//前往商城
- (IBAction)shoppingAction:(id)sender {
    SNShoppingVC *vc = [SNShoppingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

//立即邀请
- (IBAction)inviteAction:(id)sender {
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



@end
