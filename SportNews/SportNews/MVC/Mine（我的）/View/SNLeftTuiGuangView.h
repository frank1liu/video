//
//  SNLeftTuiGuangView.h
//  SportNews
//
//  Created by kkk on 2021/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNLeftTuiGuangView : BaseXibView

@property (weak, nonatomic) IBOutlet UIView *converView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *knowBtn;

+ (void)showView;

@end

NS_ASSUME_NONNULL_END
