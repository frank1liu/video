//
//  ChangeNameAndSignController.m
//  SportNews
//
//  Created by kkk on 2020/12/5.
//

#import "ChangeNameAndSignController.h"

@interface ChangeNameAndSignController ()

@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *tfXBtn;

//当前显示的文字
@property(nonatomic, strong) NSString *textString;

@end

@implementation ChangeNameAndSignController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupSubViews];
}

- (void)setupSubViews {
    
    self.tfXBtn.hidden = YES;
    
    self.lineView.backgroundColor = SRGB(240);
    self.navView.hiddenLineView = NO;
    self.saveBtn.enabled = NO;
    self.saveBtn.backgroundColor = btnUnableBackColor;
    [self.saveBtn setTitleColor:btnUnableTitleColor forState:UIControlStateNormal];
    self.saveBtn.layer.cornerRadius = 8;
    
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (self.whichOne == 2) {
        self.titleString = @"修改昵称";
        self.textString = loginModel.userinfo.nickname;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请填写昵称" attributes: @{NSForegroundColorAttributeName:SRGB(150), NSFontAttributeName:self.inputTF.font}];
        self.inputTF.attributedPlaceholder = attrString;
    }else {
        self.titleString = @"修改签名";
        self.textString = loginModel.userinfo.sign;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请填写签名" attributes: @{NSForegroundColorAttributeName:SRGB(150), NSFontAttributeName:self.inputTF.font}];
        self.inputTF.attributedPlaceholder = attrString;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.inputTF];
}

- (void)setTextString:(NSString *)textString {
    _textString = textString;
    self.inputTF.text = textString;
    [self textFieldDidChange];
}

- (void)textFieldDidChange {
    
    self.tfXBtn.hidden = [CommonTools isBlankString:self.inputTF.text];
    if ([CommonTools isBlankString:self.inputTF.text]||[self.inputTF.text isEqualToString:self.textString]) {
        self.saveBtn.enabled = NO;
        self.saveBtn.backgroundColor = btnUnableBackColor;
        [self.saveBtn setTitleColor:btnUnableTitleColor forState:UIControlStateNormal];
    }else {
        self.saveBtn.enabled = YES;
        self.saveBtn.backgroundColor = btnBackColor;
        [self.saveBtn setTitleColor:btnTitleColor forState:UIControlStateNormal];
    }
     
}

- (IBAction)tfXBtnAction:(id)sender {
    
    self.inputTF.text = @"";
    self.tfXBtn.hidden = YES;
    [self textFieldDidChange];
    
}

- (IBAction)saveAction:(id)sender {
    
    [self.view endEditing:YES];
    [KYRemindView show];
    
//    [self saveNameSign];
//    return;
    
    LoginUserModel *loginModel = [UserModelTool loginModel];
    NSDictionary *param = @{
        @"uid":loginModel.userinfo.ids,
        @"token":loginModel.token,
        @"name":self.inputTF.text,
    };
    NSString *url = URL_ChangeInfo;
    //修改昵称
    if (self.whichOne == 2) {
        url = URL_ChangeInfo;
        param = @{
            @"uid":loginModel.userinfo.ids,
            @"token":loginModel.token,
            @"value":self.inputTF.text,
            @"edittype":@(self.whichOne),
        };
    }
    WeakSelf;
    [KYApiHttpTool GET:url withParams:param success:^(NSDictionary * _Nonnull response) {
        [MBProgressHUD showSuccess:@"修改成功" toView:nil];
        if (self.whichOne == 2) {
            loginModel.userinfo.nickname = self.inputTF.text;
        }else {
            loginModel.userinfo.sign = self.inputTF.text;
        }
        [UserModelTool save:loginModel];
        if (self.changeSuccess) {
            self.changeSuccess();
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
       
    }];
    
}

- (void)saveNameSign {
    
    LoginUserModel *loginModel = [UserModelTool loginModel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"修改成功" toView:nil];
        if (self.whichOne == 1) {
            loginModel.userinfo.nickname = self.inputTF.text;
        }else {
            loginModel.userinfo.sign = self.inputTF.text;
        }
        [UserModelTool save:loginModel];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.changeSuccess) {
            self.changeSuccess();
        }
    });
    
}
 
@end
