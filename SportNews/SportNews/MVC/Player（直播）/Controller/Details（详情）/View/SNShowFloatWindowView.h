//
//  SNShowFloatWindowView.h
//  SportNews
//
//  Created by kkk on 2021/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNShowFloatWindowView : BaseXibView

@property (nonatomic, copy) void(^clickWithSelect)(NSInteger selectIndex);
@property (weak, nonatomic) IBOutlet UIView *bgBackView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView1;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn1;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewBottom;

@property(nonatomic, assign) NSInteger selectIndex;

@end

NS_ASSUME_NONNULL_END
