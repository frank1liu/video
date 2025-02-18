//
//  SNChangeNameView.h
//  SportNews
//
//  Created by kkk on 2021/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNChangeNameView : BaseXibView

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIView *tfBackView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewBottom;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

- (void)showView;

@property (nonatomic, copy) void(^updateNameBlock)(NSString *text);

@end

NS_ASSUME_NONNULL_END
