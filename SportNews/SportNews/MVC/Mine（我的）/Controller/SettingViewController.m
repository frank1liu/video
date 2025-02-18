//
//  SettingViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/4.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "SettingSwitchTableViewCell.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
     
    [self setupSubViews];
      
}

- (void)setupSubViews {
         
    self.titleString = @"设置";
    self.datasArray = @[@"小窗播放",@"隐私协议",@"服务协议"].mutableCopy;
    self.navView.hiddenLineView = NO;
    self.tableView.frame = CGRectMake(0, NavHeight, kScreenWidth, kScreenHeight-NavHeight-100-xBottomHeight);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsZero;

    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        UIButton *outBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, kScreenHeight-15-40-xBottomHeight, kScreenWidth-60, 40)];
        [outBtn addTarget:self action:@selector(outLoginAction) forControlEvents:UIControlEventTouchUpInside];
        [outBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        outBtn.backgroundColor = Blue_Color;
        outBtn.layer.cornerRadius = 8;
        [self.view addSubview:outBtn];
    }
    
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArray.count-2;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SettingSwitchTableViewCell *cell = [SettingSwitchTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = 0;
        cell.qmui_selectedBackgroundColor = SRGB(220);
        NSString *title = self.datasArray[indexPath.row];
        BOOL isOpen = ![[NSUserDefaults standardUserDefaults] boolForKey:CloseSmallWindow];
        cell.openSwitch.on = isOpen;
        cell.titleLabel.text = title;
        cell.subLabel.text = @"退出直播后,切换到小窗继续观看直播";
        
        return cell;
    }else {
        SettingTableViewCell *cell = [SettingTableViewCell cellWithTableView:tableView];
        cell.qmui_selectedBackgroundColor = SRGB(220);
        NSString *title = self.datasArray[indexPath.row];
        cell.titleLabel.text = title;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.datasArray[indexPath.row];
    if ([title isEqualToString:@"隐私协议"]) {
         
    }else if ([title isEqualToString:@"服务协议"]) {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70;
    }
    return 50;
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
        
        [UserModelTool save:nil];
        if (self.loginOutBlock) {
            self.loginOutBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];

//        LoginUserModel *loginModel = [LoginUserModel mj_objectWithKeyValues:response];
//        [UserModelTool save:loginModel];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
//        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError * _Nonnull error) {
       
    }];
}

@end
