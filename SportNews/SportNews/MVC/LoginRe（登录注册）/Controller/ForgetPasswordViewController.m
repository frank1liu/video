//
//  ForgetPasswordViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/4.
//

#import "ForgetPasswordViewController.h"
#import "ForgetSetPasswordViewController.h"

@interface ForgetPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *phoneXBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}

- (void)setupSubViews {
    
    self.titleString = @"忘记密码";
     
    self.phoneXBtn.hidden = YES;
    self.phoneTF.delegate = self;
    self.lineView.backgroundColor = lineViewColor;
    self.countryBtn.layer.borderColor = lineViewColor.CGColor;
    self.countryBtn.layer.borderWidth = 1;
    self.countryBtn.layer.cornerRadius = 5;
    
    
    self.nextBtn.enabled = NO;
    self.nextBtn.backgroundColor = btnUnableBackColor;
    [self.nextBtn setTitleColor:btnUnableTitleColor forState:UIControlStateNormal];
    self.nextBtn.layer.cornerRadius = 8;
  
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请填写完整手机号" attributes: @{NSForegroundColorAttributeName:SRGB(150), NSFontAttributeName:self.phoneTF.font}];
    self.phoneTF.attributedPlaceholder = attrString;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.phoneTF];
}

- (void)textFieldDidChange {
    
    if ([CommonTools isBlankString:self.phoneTF.text]) {
        self.phoneXBtn.hidden = YES;
        self.nextBtn.enabled = NO;
        self.nextBtn.backgroundColor = btnUnableBackColor;
        [self.nextBtn setTitleColor:btnUnableTitleColor forState:UIControlStateNormal];
    }else {
        self.phoneXBtn.hidden = NO;
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = btnBackColor;
        [self.nextBtn setTitleColor:btnTitleColor forState:UIControlStateNormal];
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

- (IBAction)phoneXAction:(id)sender {
    self.phoneTF.text = @"";
    self.phoneXBtn.hidden = YES;
    [self textFieldDidChange];
}

- (IBAction)nextAction:(id)sender {
    [self.view endEditing:YES];
    
    ForgetSetPasswordViewController *VC = [[ForgetSetPasswordViewController alloc] init];
    VC.phoneNum = self.phoneTF.text;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)countryAction:(id)sender {
    
    
}


@end
