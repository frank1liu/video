//
//  RegisterViewController.h
//  SportNews
//
//  Created by kkk on 2020/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : BaseViewController
@property (strong, nonatomic) NSString *registeredNumber;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@end

NS_ASSUME_NONNULL_END
