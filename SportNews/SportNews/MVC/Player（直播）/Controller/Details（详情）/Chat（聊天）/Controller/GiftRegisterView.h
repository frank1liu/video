//
//  SuggestionViewController.h
//  SportNews
//
//  Created by kkk on 2020/12/8.
//

#import <UIKit/UIKit.h>

@protocol GiftRegisterViewDelegate <NSObject>
@optional

- (void)ChangeToLogin:(NSInteger)index;
- (void)MoveKeyboardUp:(NSInteger)type;
- (void)MoveKeyboardDown:(NSInteger)type;
- (void)RegisterSuccessMoveView;

@end

@interface GiftRegisterView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UIView *baseView1;
@property (nonatomic, strong) IBOutlet UIView *baseView2;
@property (nonatomic, strong) IBOutlet UITextField *txtPhone;
@property (nonatomic, strong) IBOutlet UITextField *txtVerifyCode;
@property (nonatomic, strong) IBOutlet UITextField *txtPassword;
@property (nonatomic, strong) IBOutlet UITextField *txtConfirmPassword;
@property (nonatomic, strong) IBOutlet UIButton *btnGetCode;
@property (nonatomic, strong) IBOutlet UIButton *btnRegister;
@property(nonatomic,weak)id<GiftRegisterViewDelegate>delegate;

@end

