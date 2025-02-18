//
//  SuggestionViewController.h
//  SportNews
//
//  Created by kkk on 2020/12/8.
//

#import <UIKit/UIKit.h>

@protocol GiftLoginViewDelegate <NSObject>
@optional

- (void)ChangeToRegister:(NSInteger)index;
- (void)MoveKeyboardUp:(NSInteger)type;
- (void)MoveKeyboardDown:(NSInteger)type;
- (void)LoginSuccessMoveView;
@end

@interface GiftLoginView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UIView *baseView1;
@property (nonatomic, strong) IBOutlet UIView *baseView2;
@property (nonatomic, strong) IBOutlet UITextField *txtPhone;
@property (nonatomic, strong) IBOutlet UITextField *txtPassword;
@property (nonatomic, strong) IBOutlet UIButton *btnLogin;

@property(nonatomic,weak)id<GiftLoginViewDelegate>delegate;

@end

