//
//  SuggestionViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/8.
//

#import "GiftLoginView.h"
#import "MBProgressHUD.h"

@implementation GiftLoginView

- (id)initWithFrame:(CGRect)frame {
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
    [[NSBundle mainBundle] loadNibNamed:@"GiftLoginView" owner:self options:nil];
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
    self.txtPassword.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.txtPhone.layer.borderWidth=1.0;
    self.txtPassword.layer.borderWidth=1.0;
    self.txtPhone.layer.cornerRadius = 8.0;
    self.txtPhone.clipsToBounds = YES;
    self.txtPassword.layer.cornerRadius = 8.0;
    self.txtPassword.clipsToBounds = YES;
    self.btnLogin.layer.cornerRadius = 8.0;
    self.btnLogin.clipsToBounds = YES;

    //// 普通帳號
//    #if DEBUG
//        self.txtPhone.text = @"13545674567";
//        self.txtPassword.text = @"123456";
//    #endif

    //// 高級帳號
    #if DEBUG
        self.txtPhone.text = @"13437538802";
        self.txtPassword.text = @"151508wei";
    #endif

    // self.view.translatesAutoresizingMaskIntoConstraints = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(MoveKeyboardDown:)]) {
        [_delegate MoveKeyboardDown:1];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(MoveKeyboardUp:)]) {
        [_delegate MoveKeyboardUp:1];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)dismissKey {
    [_txtPhone resignFirstResponder];
    [_txtPassword resignFirstResponder];
}

- (IBAction)loginAction:(id)sender {
    if ([self.txtPhone.text isEqualToString:@""] ||
        [self.txtPassword.text isEqualToString:@""]) {
        [MBProgressHUD showSuccess:@"请完善讯息" toView:nil];
        return;
    }

    NSDictionary *param = @{
        @"type":@2,
        @"mobile":self.txtPhone.text,
        @"code":self.txtPassword.text,
        @"apptype":@3,
        @"account":self.txtPhone.text,
        @"password":self.txtPassword.text,
        @"pid":@"4",
        @"langtype":@"zh"
    };
    [KYRemindView show];
    [KYApiHttpTool GET:URL_LoginMobile withParams:param success:^(NSDictionary * _Nonnull response) {
        NSLog(@"%@", response);
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"9file"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"9fileBg"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"9fileImage"];
        [self loginSuccess:response];
    } failure:^(NSError * _Nullable error) {
        [MBProgressHUD showSuccess:@"登入失败" toView:nil];
    }];
}

- (void)loginSuccess:(NSDictionary *)response {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD showSuccess:@"登入成功" toView:nil];
    });
    LoginUserModel *loginModel = [LoginUserModel mj_objectWithKeyValues:response];
    [UserModelTool save:loginModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    [self dismissKey];
    if (_delegate && [_delegate respondsToSelector:@selector(MoveKeyboardDown:)]) {
        [_delegate MoveKeyboardDown:1];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(LoginSuccessMoveView)]) {
        [_delegate LoginSuccessMoveView];
    }
}

- (IBAction)ChangeToRegister:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ChangeToRegister:)]) {
        [_delegate ChangeToRegister:2];
    }
}

@end
