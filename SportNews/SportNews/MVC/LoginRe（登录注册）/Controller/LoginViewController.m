//
//  LoginViewController.m
//  StockExchange
//
//  Created by kkk on 2020/11/18.
//

#import "LoginViewController.h"
#import "NoMessageViewController.h"
#import "ForgetPasswordViewController.h"
#import "RegisterViewController.h"
#import "CommonWebViewController.h"
#import "SportNews-Swift.h"
#import "SNCountryModel.h"

UIViewController *loginVC;

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *phoneBackView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UIView *passBackView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *xianshiBtn;

@property (weak, nonatomic) IBOutlet UIView *codeBackView;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;


@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userBottom;

//no 手机短信登录 yes密码登录
@property (nonatomic , assign) BOOL loginWayIsPass;
 
//记录倒计时
@property (nonatomic,assign) NSInteger countDownTime;
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic , strong) NSArray *coutryArray;

@property (nonatomic , strong) SNCountryModel *currentModel;

@property(nonatomic, assign) NSInteger index;

@end

@implementation LoginViewController
 
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
  
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }

//// 普通帳號
#if DEBUG
    self.phoneTF.text = @"13545674567";
    self.passwordTF.text = @"123456";
    self.phoneTF.text = @"13545674567";
    self.codeTF.text = @"123456";
#endif

//// 高級帳號
//#if DEBUG
//    self.phoneTF.text = @"13437538802";
//    self.passwordTF.text = @"151508wei";
//    self.phoneTF.text = @"13437538802";
//    self.codeTF.text = @"151508wei";
//#endif

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
    
    [self setupSubViews];
    loginVC = self;
}
 
- (void)setupSubViews {
      
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countryCode" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    NSArray *jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    self.coutryArray = [SNCountryModel mj_objectArrayWithKeyValuesArray:jsonObj];
    SNCountryModel *currentModel = [[SNCountryModel alloc] init];
    currentModel.code = @"+86";
    currentModel.en = @"China";
    currentModel.cn = @"中国";
    self.currentModel = currentModel;
    
    self.userBottom.constant = xBottomHeight+25;
    self.countDownTime = 120;
    [self.navView removeFromSuperview];
    self.xianshiBtn.hidden = YES;
    self.passwordTF.secureTextEntry = YES;
     
    self.codeBtn.enabled = NO;
    self.codeLabel.clipsToBounds = YES;
    
    self.loginBtn.enabled = NO;
    self.loginBtn.layer.cornerRadius = self.loginBtn.height/2;
     
    self.phoneBackView.layer.borderWidth = 1;
    self.phoneBackView.layer.borderColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.phoneBackView.layer.cornerRadius = 25;
    
    self.passBackView.layer.borderWidth = 1;
    self.passBackView.layer.borderColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.passBackView.layer.cornerRadius = 25;
    
    self.codeBackView.layer.borderWidth = 1;
    self.codeBackView.layer.borderColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.codeBackView.layer.cornerRadius = 25;
      
    self.phoneTF.delegate = self;
    self.codeTF.delegate = self; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.phoneTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.codeTF];
    
}

- (void)textFieldDidChange {
     
    if (self.loginWayIsPass) {
        if (![CommonTools isBlankString:self.phoneTF.text]&&
            ![CommonTools isBlankString:self.passwordTF.text]) {
            self.loginBtn.enabled = YES;
        }else {
            self.loginBtn.enabled = NO;
        }
        if (![CommonTools isBlankString:self.passwordTF.text]) {
            self.xianshiBtn.hidden = NO;
        }else {
            self.xianshiBtn.hidden = YES;
        }
    }else {
        self.xianshiBtn.hidden = YES;
        if (![CommonTools isBlankString:self.phoneTF.text]&&
            ![CommonTools isBlankString:self.codeTF.text]) {
            self.loginBtn.enabled = YES;
        }else {
            self.loginBtn.enabled = NO; 
        }
        
        if ([CommonTools isBlankString:self.phoneTF.text]) {
            if (self.countDownTime == 120) {
                self.codeBtn.enabled = NO;
            }
            self.codeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        }else {
            self.codeBtn.enabled = YES;
            self.codeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        } 
    }

}

//只允许z验证码输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
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
    self.codeLabel.text = @"(120s)重新获取";
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDownNumbers) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}

- (void)countDownNumbers {
    
    self.countDownTime -= 1;
    self.codeLabel.text = [NSString stringWithFormat:@"(%lds)重新获取",(long)self.countDownTime];
    if (self.countDownTime == 0) {
        self.codeLabel.text = @"重新获取";
        self.codeBtn.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.countDownTime = 120;
    }
    
}

//获取验证码
- (IBAction)getCodeAction:(id)sender {
    [self.view endEditing:YES];
    if (self.countDownTime < 120) {
        return;
    }
    [self countDown];
    [KYRemindView show];
    NSDictionary *param = @{
        @"type":@(2),
        @"mobile":self.phoneTF.text,
        @"countrycode":self.currentModel.code,
    };
    [KYApiHttpTool GET:URL_CodePath withParams:param success:^(NSDictionary * _Nonnull response) {
        [self.codeTF becomeFirstResponder];
    } failure:^(NSError * _Nonnull error) {
        self.codeLabel.text = @"重新获取";
        self.codeBtn.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.countDownTime = 120;
    }]; 
}

//返回
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//注册
- (IBAction)registerAction:(id)sender {
    RegisterViewController *VC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

//选择国家
- (IBAction)selectCountryAction:(id)sender {
    [self.view endEditing:YES];
    WeakSelf
    [[ChoiceContentView shared] showWithContent:self.coutryArray current:self.currentModel choice:^(NSInteger index) {
        weakSelf.currentModel = self.coutryArray[index];
        weakSelf.countryLabel.text = weakSelf.currentModel.code;
    }];
}


//登录方式的选择
- (IBAction)loginWayChangeAction:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.isSelected;
    self.loginWayIsPass = sender.isSelected;
    self.codeBackView.hidden = sender.isSelected;
    self.passwordTF.hidden = !sender.isSelected;
    [self textFieldDidChange];
    self.titleLabel.text = sender.isSelected?@"密码登录":@"手机短信登录";
    
}

//忘记密码
- (IBAction)forgetOrMessageAction:(id)sender {
    ForgetPasswordViewController *VC = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

//登录
- (IBAction)loginAction:(id)sender {
    
    [self.view endEditing:YES];
    if (self.loginWayIsPass) {
        //账号密码登录
        NSDictionary *param = @{
            @"account":self.phoneTF.text,
            @"password":self.passwordTF.text
        };   
        [KYRemindView show];
        [KYApiHttpTool GET:URL_LoginAccount withParams:param success:^(NSDictionary * _Nonnull response) {
            [self loginSuccess:response];
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }else {
        //验证码登录
        NSDictionary *param = @{
            @"type":@2,
            @"mobile":self.phoneTF.text,
            @"code":self.codeTF.text,
            @"countrycode":self.currentModel.code,
            @"apptype":@3,
            @"account":self.phoneTF.text,
            @"password":self.codeTF.text
        };
        [KYRemindView show];
        [KYApiHttpTool GET_Account:URL_Account withParams:@{@"account": self.phoneTF.text, @"langtype" : @"zh"} success:^(NSDictionary * _Nonnull response) {
            NSLog(@"%@", response);
            if ([response[@"msg"] isEqualToString:@"ok"] && [response[@"isReg"] longValue] == 0) {
                [self isToRegister:self.phoneTF.text];
            }
            else {     // 此號碼已被註冊
                [KYApiHttpTool GET:URL_LoginMobile withParams:param success:^(NSDictionary * _Nonnull response) {
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"9file"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"9fileBg"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"9fileImage"];
                    [self loginSuccess:response];
                } failure:^(NSError * _Nonnull error) {

                }];
            }

        } failure:^(NSError * _Nullable error) {

        }];
    }
}

- (void)isToRegister:(NSString *)phoneNumber {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"注册号码" message:@"此号码尚未被注册使用，是否注册？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *alertConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RegisterViewController *VC = [[RegisterViewController alloc] init];
        VC.registeredNumber = phoneNumber;
        [self.navigationController pushViewController:VC animated:YES];
    }];
    [actionSheet addAction:alertCancel];
    [actionSheet addAction:alertConfirm];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)loginSuccess:(NSDictionary *)response { 
    LoginUserModel *loginModel = [LoginUserModel mj_objectWithKeyValues:response];
    [UserModelTool save:loginModel]; 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)xianshiAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.passwordTF.secureTextEntry = !sender.isSelected;
}

//使用协议
- (IBAction)useXieyiAction:(id)sender {
    CommonWebViewController *Vc = [[CommonWebViewController alloc] init]; 
    Vc.url = [NSString stringWithFormat:@"%@user-use.html",BaseUrl];
    Vc.titleString = @"使用协议";
    [self.navigationController pushViewController:Vc animated:YES];
    self.index += 1;
    if (self.index >= 3) {
        NSString *regid = [[NSUserDefaults standardUserDefaults] objectForKey:JPushRegistrationID];
        UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = regid;
    }
}

//隐私政策
- (IBAction)privateAction:(id)sender {
    CommonWebViewController *Vc = [[CommonWebViewController alloc] init];
    Vc.url = [NSString stringWithFormat:@"%@privacy.html",BaseUrl];
    Vc.titleString = @"隐私政策";
    [self.navigationController pushViewController:Vc animated:YES];
}

 
@end
