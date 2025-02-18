//
//  SuggestionViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/8.
//

#import "GiftRegisterView.h"

extern UIImage *gChangedImage;

@interface GiftRegisterView()
//记录倒计时
@property (nonatomic,assign) NSInteger countDownTime;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation GiftRegisterView

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"initWithFrame");
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"initWithCoder");
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"GiftRegisterView" owner:self options:nil];
    [self addSubview:self.view];
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKey) name:@"LoginPhonePasswordDismiss" object:nil];

    self.baseView1.layer.cornerRadius = 14;
    self.baseView1.clipsToBounds = YES;
    self.baseView2.layer.cornerRadius = 14;
    self.baseView2.clipsToBounds = YES;

    self.txtPhone.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.txtVerifyCode.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.txtPassword.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.txtConfirmPassword.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.txtPhone.layer.borderWidth=1.0;
    self.txtVerifyCode.layer.borderWidth=1.0;
    self.txtPassword.layer.borderWidth=1.0;
    self.txtConfirmPassword.layer.borderWidth=1.0;
    self.txtPhone.layer.cornerRadius = 8.0;
    self.txtPhone.clipsToBounds = YES;
    self.txtVerifyCode.layer.cornerRadius = 8.0;
    self.txtVerifyCode.clipsToBounds = YES;
    self.txtPassword.layer.cornerRadius = 8.0;
    self.txtPassword.clipsToBounds = YES;
    self.txtConfirmPassword.layer.cornerRadius = 8.0;
    self.txtConfirmPassword.clipsToBounds = YES;
    self.btnGetCode.layer.cornerRadius = 8.0;
    self.btnGetCode.clipsToBounds = YES;
    self.btnRegister.layer.cornerRadius = 8.0;
    self.btnRegister.clipsToBounds = YES;

    self.countDownTime = 60;
    // self.view.translatesAutoresizingMaskIntoConstraints = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(MoveKeyboardDown:)]) {
        [_delegate MoveKeyboardDown:2];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(MoveKeyboardUp:)]) {
        [_delegate MoveKeyboardUp:2];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)dismissKey {
    [self.timer invalidate];
    self.timer = nil;
    [_txtPhone resignFirstResponder];
    [_txtVerifyCode resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtConfirmPassword resignFirstResponder];
}

- (IBAction)ChangeToLogin:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ChangeToLogin:)]) {
        [_delegate ChangeToLogin:1];
    }
}

- (void)countDown {
    self.btnGetCode.enabled = NO;
    [self.btnGetCode setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.btnGetCode setTitle:@"重新获取 60s" forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownNumbers) userInfo:nil repeats:YES];
}

- (void)countDownNumbers {
    self.countDownTime -= 1;
    [self.btnGetCode setTitle:[NSString stringWithFormat:@"重新获取 %lds",(long)self.countDownTime] forState:UIControlStateNormal];
    if (self.countDownTime == 0) {
        [self.btnGetCode setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.btnGetCode.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.countDownTime = 60;
    }
}

- (IBAction)getCodeAction:(id)sender {
    [self.view endEditing:YES];
    [self countDown];
    [KYRemindView show];
    NSDictionary *param = @{
        @"account":self.txtPhone.text
    };
    [KYApiHttpTool GET_Account:URL_CodePath withParams:param success:^(NSDictionary * _Nonnull response) {

    } failure:^(NSError * _Nonnull error) {
        [self.btnGetCode setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.btnGetCode.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.countDownTime = 60;
    }];
}

//注册
- (IBAction)registerAction:(id)sender {

    if ([self.txtPhone.text isEqualToString:@""] ||
        [self.txtPassword.text isEqualToString:@""] ||
        [self.txtVerifyCode.text isEqualToString:@""] ||
        [self.txtConfirmPassword.text isEqualToString:@""]) {
        [MBProgressHUD showSuccess:@"请完善讯息" toView:nil];
        return;
    }

    if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]) {
        [MBProgressHUD showError:@"两次密码不一致" toView:nil];
        return;
    }

    [self.view endEditing:YES];
    NSDictionary *param = @{
        @"account":self.txtPhone.text,
        @"code":self.txtVerifyCode.text,
        @"password":self.txtPassword.text,
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD showSuccess:@"注册成功" toView:nil];
    });
    LoginUserModel *loginModel = [LoginUserModel mj_objectWithKeyValues:response];
    [UserModelTool save:loginModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    [self dismissKey];
    if (_delegate && [_delegate respondsToSelector:@selector(MoveKeyboardDown:)]) {
        [_delegate MoveKeyboardDown:2];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(RegisterSuccessMoveView)]) {
        [_delegate RegisterSuccessMoveView];
    }
}

@end
