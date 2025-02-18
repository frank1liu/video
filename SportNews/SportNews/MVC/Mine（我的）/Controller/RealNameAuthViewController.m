//
//  RealNameAuthViewController.m
//  SportNews
//
//  Created by kkk on 2021/1/29.
//

#import "RealNameAuthViewController.h"

@interface RealNameAuthViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *nameBackView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UIView *idBackView;
@property (weak, nonatomic) IBOutlet UITextField *idNumTF;

@property (weak, nonatomic) IBOutlet UIView *phoneBackView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UIView *codeBackView;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
 
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

//记录倒计时
@property (nonatomic,assign) NSInteger countDownTime;
@property (nonatomic,strong) NSTimer *timer;



@end

@implementation RealNameAuthViewController
 
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
    
}

- (void)setupSubViews {
    
    self.titleString = @"实名认证";
    self.countDownTime = 120;
      
    self.codeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    self.submitBtn.enabled = NO;
    self.submitBtn.layer.cornerRadius = 25;
    
    self.nameBackView.layer.borderWidth = 1;
    self.nameBackView.layer.borderColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.nameBackView.layer.cornerRadius = 25;
    
    self.idBackView.layer.borderWidth = 1;
    self.idBackView.layer.borderColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.idBackView.layer.cornerRadius = 25;
    
    self.phoneBackView.layer.borderWidth = 1;
    self.phoneBackView.layer.borderColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.phoneBackView.layer.cornerRadius = 25;
    
    self.codeBackView.layer.borderWidth = 1;
    self.codeBackView.layer.borderColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.codeBackView.layer.cornerRadius = 25;
     
    self.phoneTF.delegate = self;
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        self.phoneTF.text = loginModel.userinfo.mobile;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.nameTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.idNumTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.phoneTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.codeTF];
       
}

- (void)statusAuth:(BOOL)auth {
    
    //是否在认证
    BOOL isAuth = NO;
    self.nameBackView.hidden = isAuth;
    self.idBackView.hidden = isAuth;
    self.phoneBackView.hidden = isAuth;
    self.codeBackView.hidden = isAuth;
    self.submitBtn.hidden = isAuth;
    self.bottomLabel.hidden = isAuth;
    
    self.iconImageView.hidden = !isAuth;
    self.centerLabel.hidden = !isAuth;
    
}

- (void)textFieldDidChange {
     
    if (![CommonTools isBlankString:self.codeTF.text]&&
        ![CommonTools isBlankString:self.idNumTF.text]&&
        ![CommonTools isBlankString:self.nameTF.text]) {
        self.submitBtn.enabled = YES;
    }else {
        self.submitBtn.enabled = NO;
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
    [self countDown];
    [KYRemindView show];
    NSDictionary *param = @{
        @"type":@(1),
        @"mobile":self.phoneTF.text
    };
    [KYApiHttpTool GET:URL_CodePath withParams:param success:^(NSDictionary * _Nonnull response) {
        
    } failure:^(NSError * _Nonnull error) {
        self.codeLabel.text = @"重新获取";
        self.codeBtn.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.countDownTime = 120;
    }];
}
  

//提交
- (IBAction)submitAction:(id)sender {
     
    [self.view endEditing:YES];
    NSDictionary *param = @{
        @"name":self.nameTF.text,
        @"idNum":self.codeTF.text,
        @"phone":self.phoneTF.text,
        @"code":self.codeTF.text,
        @"source":@(3)
    };
    [KYRemindView show];
    [KYApiHttpTool GET:URL_Register withParams:param success:^(NSDictionary * _Nonnull response) {
        [MBProgressHUD showSuccess:@"注册成功" toView:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}
  
 
 

@end
