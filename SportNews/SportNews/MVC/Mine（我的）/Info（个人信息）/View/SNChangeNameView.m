//
//  SNChangeNameView.m
//  SportNews
//
//  Created by kkk on 2021/4/7.
//

#import "SNChangeNameView.h"

@implementation SNChangeNameView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.backView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(10, 10)];
    self.tfBackView.layer.cornerRadius = 8;
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

}

- (void)showView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self.nameTF becomeFirstResponder];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.backBtn.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.backBtn.alpha = 0.6;
        self.backViewBottom.constant = height;
        [self layoutIfNeeded];
    }];
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [UIView animateWithDuration:0.25 animations:^{
        self.backViewBottom.constant = 0;
        self.backView.alpha = 0;
        self.backBtn.alpha = 0;
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)hide {
    [self.nameTF resignFirstResponder];
}

- (IBAction)clickBackView:(id)sender {
    [self hide];
}

- (IBAction)cancelAction:(id)sender {
    [self hide];
}

- (IBAction)updateAction:(id)sender {
    if ([CommonTools isBlankString:self.nameTF.text]) {
        [MBProgressHUD showError:@"昵称不能为空！" toView:nil];
        return;
    }
    [self hide];
    if (self.updateNameBlock) {
        self.updateNameBlock(self.nameTF.text);
    }
}

@end
