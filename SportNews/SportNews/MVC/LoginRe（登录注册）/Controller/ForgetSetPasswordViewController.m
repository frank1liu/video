//
//  ForgetSetPasswordViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/4.
//

#import "ForgetSetPasswordViewController.h"
#import "LoginCodeView.h"
#import "NoMessageViewController.h"

extern UIViewController *loginVC;

@interface ForgetSetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *codeBackView;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *passXBtn;
@property (weak, nonatomic) IBOutlet UIButton *xianshiBtn;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *noMsgBtn;

@property(nonatomic, copy) NSString *codeString;

//记录倒计时
@property (nonatomic,assign) NSInteger countDownTime;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation ForgetSetPasswordViewController

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
    [self setupCodeView];
}

- (void)setupCodeView {
    LoginCodeView *verView = [[LoginCodeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-160, 50)];
    verView.inputType = 6;
    [verView initSubviews];
    __weak typeof(self) weakSelf = self;
    verView.codeBlock = ^(NSString *text){
        weakSelf.codeString = text;
        [weakSelf textFieldDidChange];
    };
    [self.codeBackView addSubview:verView];
}

- (void)setupSubViews {
    
    self.titleString = @"忘记密码";
    self.passwordTF.secureTextEntry = YES;
    self.countDownTime = 60;

    self.lineView.backgroundColor = lineViewColor;
    
    self.passXBtn.hidden = YES;
    self.xianshiBtn.hidden = YES;
    
    self.codeLabel.clipsToBounds = YES;
    self.codeLabel.backgroundColor = btnBackColor;
    self.codeLabel.textColor = btnTitleColor;
    self.codeLabel.layer.cornerRadius = 5;
    
    self.sureBtn.enabled = NO;
    self.sureBtn.backgroundColor = btnUnableBackColor;
    [self.sureBtn setTitleColor:btnUnableTitleColor forState:UIControlStateNormal];
    self.sureBtn.layer.cornerRadius = 8;
    
    [self.noMsgBtn setTitleColor:btnUnableTitleColor forState:UIControlStateNormal];
    
    self.phoneLabel.textColor = Blue_Color;
    self.phoneLabel.text = self.phoneNum;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.passwordTF];
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请设置6-20位数字、字母、符合任意组合密码" attributes: @{NSForegroundColorAttributeName:SRGB(150), NSFontAttributeName:Font(12)}];
    self.passwordTF.attributedPlaceholder = attrString;
    self.passwordTF.adjustsFontSizeToFitWidth = YES;
    
}

- (void)textFieldDidChange {
    
    if (![CommonTools isBlankString:self.passwordTF.text]) {
        self.passXBtn.hidden = NO;
        self.xianshiBtn.hidden = NO;
    }else {
        self.passXBtn.hidden = YES;
        self.xianshiBtn.hidden = YES;
    }
    
    if ([CommonTools isBlankString:self.passwordTF.text]||
        self.codeString.length < 4) {
        self.sureBtn.enabled = NO;
        self.sureBtn.backgroundColor = btnUnableBackColor;
        [self.sureBtn setTitleColor:btnUnableTitleColor forState:UIControlStateNormal];
    }else {
        self.sureBtn.enabled = YES;
        self.sureBtn.backgroundColor = btnBackColor;
        [self.sureBtn setTitleColor:btnTitleColor forState:UIControlStateNormal];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)countDown {
    self.codeBtn.enabled = NO;
    self.codeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
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

//验证码
- (IBAction)codeAction:(id)sender {
    [self.view endEditing:YES];
    [self countDown];
    [KYRemindView show];
    NSDictionary *param = @{
        @"account":self.phoneNum
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

- (IBAction)passXAction:(id)sender {
    self.passwordTF.text = @"";
    self.passXBtn.hidden = YES;
    self.xianshiBtn.hidden = YES;
    [self textFieldDidChange];
}

- (IBAction)xianshiAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.passwordTF.secureTextEntry = !sender.isSelected;
}

//确定
- (IBAction)sureAction:(id)sender {
    [self.passwordTF resignFirstResponder];

    NSDictionary *smsParam = @{
        @"appType" : @"2",
        @"account": self.phoneNum,
        @"pid": @"4",
        @"code" : self.codeString,
    };

    NSDictionary *param = @{
        @"appType" : @"2",
        @"account": self.phoneNum,
        @"pid": @"4",
        @"password":self.passwordTF.text
    };
    NSLog(@"[Adam]驗證碼序號: %@", _codeString);
    
    [KYRemindView show];
    [KYApiHttpTool GET_Account:URL_CheckSmsCode withParams:smsParam success:^(NSDictionary * _Nonnull response) {
        [KYApiHttpTool GET_Account:URL_ForgetPassword withParams:param success:^(NSDictionary * _Nonnull response) {
            [MBProgressHUD showSuccess:@"密码修改成功" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:loginVC animated:YES];
            });

        } failure:^(NSError * _Nonnull error) {

        }];
    } failure:^(NSError * _Nullable error) {

    }];
}

//收不到短信
- (IBAction)noMessageAction:(id)sender {
    NoMessageViewController *VC = [[NoMessageViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
