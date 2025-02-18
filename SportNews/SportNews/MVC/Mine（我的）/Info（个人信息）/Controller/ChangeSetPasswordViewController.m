//
//  ChangeSetPasswordViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/7.
//

#import "ChangeSetPasswordViewController.h"
#import "ForgetPasswordViewController.h"

@interface ChangeSetPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITextField *originTF;
@property (weak, nonatomic) IBOutlet UIButton *originXBtn;
@property (weak, nonatomic) IBOutlet UIButton *originYanBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UITextField *xinTF;
@property (weak, nonatomic) IBOutlet UIButton *xinXBtn;
@property (weak, nonatomic) IBOutlet UIButton *xinYanBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xinBackTop;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;


@end

@implementation ChangeSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupSubViews];
    
}

- (void)setupSubViews {
    
    self.titleString = @"修改密码";
    
    self.navView.hiddenLineView = NO;
    self.originXBtn.hidden = YES;
    self.originYanBtn.hidden = YES;
    self.xinXBtn.hidden = YES;
    self.xinYanBtn.hidden = YES;
     
    self.originTF.secureTextEntry = YES;
    self.xinTF.secureTextEntry = YES;
    self.originTF.delegate = self;
    self.xinTF.delegate = self;
     
    self.lineView.backgroundColor = lineViewColor;
    self.lineView1.backgroundColor = lineViewColor;
    
    self.remindLabel.textColor = commonSubTextColor;
    
    self.saveBtn.enabled = NO;
    self.saveBtn.layer.cornerRadius = 25;
    
    [self.forgetBtn setTitleColor:btnUnableTitleColor forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.originTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.xinTF];
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请填写原密码" attributes: @{NSForegroundColorAttributeName:SRGB(150), NSFontAttributeName:self.originTF.font}];
    self.originTF.attributedPlaceholder = attrString;
    
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"请填写新密码" attributes: @{NSForegroundColorAttributeName:SRGB(150), NSFontAttributeName:self.xinTF.font}];
    self.xinTF.attributedPlaceholder = attrString1; 
    
}
 
- (void)textFieldDidChange {
    
    if (![CommonTools isBlankString:self.originTF.text]&&
        ![CommonTools isBlankString:self.xinTF.text]) {
        self.saveBtn.enabled = YES;
    }else {
        self.saveBtn.enabled = NO;
    }
    if ([CommonTools isBlankString:self.originTF.text]) {
        self.originXBtn.hidden = YES;
        self.originYanBtn.hidden = YES;
    }else {
        self.originXBtn.hidden = NO;
        self.originYanBtn.hidden = NO;
    }
    
    if ([CommonTools isBlankString:self.xinTF.text]) {
        self.xinXBtn.hidden = YES;
        self.xinYanBtn.hidden = YES;
    }else {
        self.xinXBtn.hidden = NO;
        self.xinYanBtn.hidden = NO;
    }

}

- (IBAction)saveBtnAction:(id)sender {
    
    if (![self.originTF.text isEqualToString:self.xinTF.text]) {
        [MBProgressHUD showError:@"两次密码不一致" toView:nil];
        return;
    }
    [KYRemindView show];
    LoginUserModel *loginModel = [UserModelTool loginModel];
    NSDictionary *param = @{
        @"uid":loginModel.userinfo.ids,
        @"token":loginModel.token,
        @"oldMobile":self.originTF.text,
        @"mobile":self.xinTF.text,
    };
    [KYApiHttpTool GET:URL_ChangeInfo withParams:param success:^(NSDictionary * _Nonnull response) {
        [MBProgressHUD showSuccess:@"修改成功" toView:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError * _Nonnull error) {
       
    }];
    
}

- (IBAction)forgetAction:(id)sender {
    ForgetPasswordViewController *VC = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)originXBtnAction:(id)sender {
    self.originTF.text = @"";
    self.originXBtn.hidden = YES;
    self.originYanBtn.hidden = YES;
    [self textFieldDidChange];
}

- (IBAction)originYanBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.originTF.secureTextEntry = !sender.isSelected;
}

- (IBAction)xinXBtnAction:(id)sender {
    self.xinTF.text = @"";
    self.xinXBtn.hidden = YES;
    self.xinYanBtn.hidden = YES;
    [self textFieldDidChange];
}

- (IBAction)xinYanBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.xinTF.secureTextEntry = !sender.isSelected;
}

@end
