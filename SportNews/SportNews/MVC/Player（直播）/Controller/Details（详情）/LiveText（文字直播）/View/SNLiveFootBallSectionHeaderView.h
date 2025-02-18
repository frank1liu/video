//
//  SNLiveFootBallSectionHeaderView.h
//  SportNews
//
//  Created by kkk on 2021/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNLiveFootBallSectionHeaderView : BaseXibView

@property (weak, nonatomic) IBOutlet UIButton *textBtn;

@property (weak, nonatomic) IBOutlet UIButton *importBtn;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeft;

@property(nonatomic, assign) CGFloat magin;

@property(nonatomic, assign) NSInteger footTag;

@property (nonatomic, copy) void(^footHeaderClickWithTag)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
