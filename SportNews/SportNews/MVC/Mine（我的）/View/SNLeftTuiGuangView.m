//
//  SNLeftTuiGuangView.m
//  SportNews
//
//  Created by kkk on 2021/4/28.
//

#import "SNLeftTuiGuangView.h"


@implementation SNLeftTuiGuangView

 
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 10;
    self.knowBtn.layer.cornerRadius = self.knowBtn.height/2;
}

+ (void)showView {
    [KYRemindView show];
    [KYApiHttpTool GET:URL_GetQQNumber withParams:nil success:^(NSDictionary * _Nonnull response) {
//        UIWindow *window = [CommonTools getCurrentWindow];
//        SNLeftTuiGuangView *tuiguangView = [[SNLeftTuiGuangView alloc] initWithFrame:window.bounds];
//        [window addSubview:tuiguangView];
//        tuiguangView.backgroundColor = UIColor.redColor;
//        tuiguangView.contentLabel.text = [NSString stringWithFormat:@"详情请联系我们的商务合作QQ：\n%@",response[@"qq"]];
//        tuiguangView.converView.alpha = 0;
//        tuiguangView.backView.alpha = 0;
//        [UIView animateWithDuration:0.35 animations:^{
//            tuiguangView.converView.alpha = 0.6;
//            tuiguangView.backView.alpha = 1;
//        } completion:^(BOOL finished) {
//            
//        }];
        // [MBProgressHUD showSuccess:[NSString stringWithFormat:@"详情请联系我们的商务合作QQ：\n%@",response[@"qq"]] toView:nil];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"推广合作"
                                       message:[NSString stringWithFormat:@"详情请联系我们的商务合作QQ：\n%@",response[@"qq"]]
                                       preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {}];

        [alert addAction:defaultAction];
        [[SNLeftTuiGuangView topMostController] presentViewController:alert animated:YES completion:nil];
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}

- (void)hideView {
    [UIView animateWithDuration:0.2 animations:^{
        self.converView.alpha = 0;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)closeAction:(id)sender {
    [self hideView];
}


@end
