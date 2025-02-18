//
//  SuggestionViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/8.
//

#import "SuggestionViewController.h"

@interface SuggestionViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolder;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
     
    [self setupSubViews];
      
}

- (void)setupSubViews {
         
    self.titleString = @"反馈意见";
    self.navView.hiddenLineView = NO;
    
    self.saveBtn.enabled = NO;
    self.saveBtn.layer.cornerRadius = 8;
    
    self.textView.delegate = self;

    self.backView.layer.cornerRadius = 8; 
    
    self.countLabel.text = @"0/500";
    self.countLabel.textColor = commonSubTextColor;
    self.placeHolder.text = @"请输入您宝贵的反馈意见";
    self.placeHolder.textColor = commonSubTextColor;
    
}

//正在改变
- (void)textViewDidChange:(UITextView *)textView {
    
    if ([CommonTools isBlankString:textView.text]) {
        self.placeHolder.hidden = NO;
        self.saveBtn.enabled = NO;
    }else {
        self.placeHolder.hidden = YES;
        self.saveBtn.enabled = YES;
    }
    
    //实时显示字数
    self.countLabel.text = [NSString stringWithFormat:@"%lu/300", (unsigned long)textView.text.length];
    //字数限制操作
    if (textView.text.length >= 300) {
        textView.text = [textView.text substringToIndex:300];
        self.countLabel.text = @"300/300";
    }
}

- (IBAction)saveBtnAction:(id)sender {
    
    [self.view endEditing:YES];
    [KYRemindView show];
    LoginUserModel *loginModel = [UserModelTool loginModel];
    NSDictionary *param = @{
        @"uid":loginModel.userinfo.ids,
        @"token":loginModel.token,
        @"content":self.textView.text,
    };
    
    [KYApiHttpTool GET:URL_Comment withParams:param success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"谢谢您的宝贵意见" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MBProgressHUD showSuccess:@"提交意见失败!" toView:nil];

        }
       
    } failure:^(NSError * _Nonnull error) {
         
    }];
}

@end
