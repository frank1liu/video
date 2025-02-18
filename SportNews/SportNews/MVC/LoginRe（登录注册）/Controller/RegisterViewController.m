//
//  RegisterViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/8.
//

#import "RegisterViewController.h"
#import "LoginCodeView.h"
#import "CommonWebViewController.h"

extern UIImage *gChangedImage;

@interface RegisterViewController ()<UITextFieldDelegate>
  
@property (weak, nonatomic) IBOutlet UIView *phoneBackView;

@property (weak, nonatomic) IBOutlet UIView *codeBackView;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
 
@property (weak, nonatomic) IBOutlet UIView *passBackView;
@property (weak, nonatomic) IBOutlet UIButton *passYanBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIView *passBackView1;
@property (weak, nonatomic) IBOutlet UIButton *passYanBtn1;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF1;

@property (weak, nonatomic) IBOutlet UIView *inviteBackView;
@property (weak, nonatomic) IBOutlet UITextField *inviteTF;

//记录倒计时
@property (nonatomic,assign) NSInteger countDownTime;
@property (nonatomic,strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn; 


@end

@implementation RegisterViewController


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (![self.navigationController.viewControllers containsObject:self]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    self.phoneTF.text = self.registeredNumber;
    self.codeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getCodeAction:)];
    [self.codeLabel addGestureRecognizer:tap];
#if DEBUG
    self.codeTF.text = @"336699";
#endif
}

- (void)setupSubViews {
    self.countDownTime = 60;
    [self.navView removeFromSuperview];
    self.passYanBtn.hidden = YES;
    self.passYanBtn1.hidden = YES;
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF1.secureTextEntry = YES;
    
    self.codeBtn.enabled = NO;
    
    self.registerBtn.enabled = NO; 
    self.registerBtn.layer.cornerRadius = 25;
       
    self.phoneBackView.layer.borderWidth = 1;
    self.phoneBackView.layer.borderColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.phoneBackView.layer.cornerRadius = 25;
    
    self.codeBackView.layer.borderWidth = 1;
    self.codeBackView.layer.borderColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.codeBackView.layer.cornerRadius = 25;
    
    self.passBackView.layer.borderWidth = 1;
    self.passBackView.layer.borderColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.passBackView.layer.cornerRadius = 25;
    
    self.passBackView1.layer.borderWidth = 1;
    self.passBackView1.layer.borderColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.passBackView1.layer.cornerRadius = 25;
    
    self.inviteBackView.layer.borderWidth = 1;
    self.inviteBackView.layer.borderColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.inviteBackView.layer.cornerRadius = 25;
    
    self.phoneTF.delegate = self;
      
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.phoneTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.codeTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.passwordTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.passwordTF1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.inviteTF];
       
}

- (void)textFieldDidChange {
    
//    if ([CommonTools isBlankString:self.phoneTF.text]) {
//        self.codeBtn.enabled = NO;
//        self.codeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
//    }else {
//        self.codeBtn.enabled = YES;
//        self.codeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//    }
    
    
    if (![CommonTools isBlankString:self.phoneTF.text]&&
        ![CommonTools isBlankString:self.codeTF.text]&&
        ![CommonTools isBlankString:self.passwordTF.text]&&
        ![CommonTools isBlankString:self.passwordTF1.text]) {
        self.registerBtn.enabled = YES;
    }else {
        self.registerBtn.enabled = NO;
    }
    
    if ([CommonTools isBlankString:self.passwordTF.text]) {
        self.passYanBtn.hidden = YES;
    }else {
        self.passYanBtn.hidden = NO;
    }

    if ([CommonTools isBlankString:self.passwordTF1.text]) {
        self.passYanBtn1.hidden = YES;
    }else {
        self.passYanBtn1.hidden = NO;
    }
}

//只允许z验证码输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)countDown {
    self.codeBtn.enabled = NO;
    self.codeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.codeLabel.text = @"重新获取 60s";
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownNumbers) userInfo:nil repeats:YES];
}

- (void)countDownNumbers {
    self.countDownTime -= 1;
    self.codeLabel.text = [NSString stringWithFormat:@"重新获取 %lds",(long)self.countDownTime];
    if (self.countDownTime == 0) {
        self.codeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.codeLabel.text = @"获取验证码";
        self.codeBtn.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.countDownTime = 60;
    }
}

//获取验证码
- (IBAction)getCodeAction:(id)sender {
    [self.view endEditing:YES];
    [self countDown];
    [KYRemindView show];
    NSDictionary *param = @{
        @"account":self.phoneTF.text
    };
    [KYApiHttpTool GET_Account:URL_CodePath withParams:param success:^(NSDictionary * _Nonnull response) {

    } failure:^(NSError * _Nonnull error) {
        self.codeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.codeLabel.text = @"获取验证码";
        self.codeBtn.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.countDownTime = 60;
    }];
}
  

//注册
- (IBAction)registerAction:(id)sender {
    
    if (![self.passwordTF.text isEqualToString:self.passwordTF1.text]) {
        [MBProgressHUD showError:@"两次密码不一致" toView:nil];
        return;
    }
    [self.view endEditing:YES];
    NSDictionary *param = @{
        @"account":self.phoneTF.text,
        @"code":self.codeTF.text,
        @"password":self.passwordTF.text,
        @"pid":@4,
        @"apptype":@2
    };
    [KYRemindView show];
    [KYApiHttpTool GET:URL_Register withParams:param success:^(NSDictionary * _Nonnull response) {
        [MBProgressHUD showSuccess:@"注册成功" toView:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            gChangedImage = nil;
            [self loginSuccess:response];
        });
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)loginSuccess:(NSDictionary *)response {
    LoginUserModel *loginModel = [LoginUserModel mj_objectWithKeyValues:response];
    [UserModelTool save:loginModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)passYanAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.passwordTF.secureTextEntry = !sender.isSelected;
}

- (IBAction)passYanAction1:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.passwordTF1.secureTextEntry = !sender.isSelected;
}
 

//使用协议
- (IBAction)useXieyiAction:(id)sender {
    CommonWebViewController *Vc = [[CommonWebViewController alloc] init]; 
    Vc.url = [NSString stringWithFormat:@"%@user-use.html",BaseUrl];
    Vc.titleString = @"使用协议";
    [self.navigationController pushViewController:Vc animated:YES];
}

//隐私政策
- (IBAction)privateAction:(id)sender {
    CommonWebViewController *Vc = [[CommonWebViewController alloc] init];
    Vc.url = [NSString stringWithFormat:@"%@privacy.html",BaseUrl];
    Vc.titleString = @"隐私政策";
    [self.navigationController pushViewController:Vc animated:YES];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
