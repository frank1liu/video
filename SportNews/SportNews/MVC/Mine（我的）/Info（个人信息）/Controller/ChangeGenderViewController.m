//
//  ChangeGenderViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/5.
//

#import "ChangeGenderViewController.h"

@interface ChangeGenderViewController ()

@property (weak, nonatomic) IBOutlet UILabel *maleLabel;
@property (weak, nonatomic) IBOutlet UILabel *femaleLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

//1男  2女
@property(nonatomic, assign) NSInteger sex;

@end

@implementation ChangeGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self setupSubViews];
    
    self.sex = 0;
    
}

- (void)setupSubViews {
    
    self.titleString = @"修改性别";
    self.navView.hiddenLineView = NO;
    self.lineView.backgroundColor = SRGB(240);
    self.saveBtn.backgroundColor = btnBackColor;
    [self.saveBtn setTitleColor:btnTitleColor forState:UIControlStateNormal];
    self.saveBtn.layer.cornerRadius = 8;
    

}

- (IBAction)saveAction:(id)sender {
    
    [self.view endEditing:YES];
    [KYRemindView show];
    [self setSexJiade]; 
    
//    LoginUserModel *loginModel = [UserModelTool loginModel];
//    NSDictionary *param = @{
//        @"uid":loginModel.userinfo.ids,
//        @"token":loginModel.token,
//        @"sex":@(self.sex),
//    };
//    [KYApiHttpTool GET:URL_ChangeInfo withParams:param success:^(NSDictionary * _Nonnull response) {
//        [MBProgressHUD showSuccess:@"修改成功" toView:nil];
//        [UserModelTool save:loginModel];
//        if (self.changeSuccess) {
//            self.changeSuccess();
//        }
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
    
}

- (IBAction)maleAction:(id)sender {
    self.sex = 0;
}


- (IBAction)femaleAction:(id)sender {
    self.sex = 1;
}

- (void)setSex:(NSInteger)sex {
    _sex = sex;
    if (sex == 0) {
        self.maleLabel.textColor = Blue_Color;
        self.femaleLabel.textColor = UIColor.blackColor;
    }else {
        self.maleLabel.textColor = UIColor.blackColor;
        self.femaleLabel.textColor = RGB(230, 168, 219);
    }
}

- (void)setSexJiade {
    
    LoginUserModel *loginModel = [UserModelTool loginModel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"修改成功" toView:nil];
        loginModel.userinfo.sex = self.sex;
        [UserModelTool save:loginModel];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.changeSuccess) {
            self.changeSuccess();
        }
        
    });
    
}


@end
