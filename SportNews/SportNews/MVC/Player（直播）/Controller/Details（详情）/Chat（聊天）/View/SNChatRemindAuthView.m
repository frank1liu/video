//
//  SNChatRemindAuthView.m
//  SportNews
//
//  Created by kkk on 2021/1/30.
//

#import "SNChatRemindAuthView.h"
#import "RealNameAuthViewController.h"

@interface SNChatRemindAuthView ()

@property (weak, nonatomic) IBOutlet UIView *blackView;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIButton *authBtn;

@end

@implementation SNChatRemindAuthView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.blackView.alpha = 0;
    self.backView.alpha = 0;
    self.backView.layer.cornerRadius = 10;
    self.authBtn.layer.cornerRadius = self.authBtn.height/2;
    
}

+ (void)showView {
    
    UIWindow *window = [CommonTools getCurrentWindow];
    SNChatRemindAuthView *remindView = [[SNChatRemindAuthView alloc] initWithFrame:window.bounds];
    [window addSubview:remindView];
    [UIView animateWithDuration:0.35 animations:^{
        remindView.blackView.alpha = 0.6;
        remindView.backView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }]; 
}

- (void)hideView {
    [UIView animateWithDuration:0.2 animations:^{
        self.blackView.alpha = 0;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)closeAction:(id)sender {
    [self hideView];
}


- (IBAction)authAction:(id)sender {
    [self hideView];
    
    RealNameAuthViewController *VC = [[RealNameAuthViewController alloc] init];
    [[CommonTools currentViewController].navigationController pushViewController:VC animated:YES];
    
}

@end
