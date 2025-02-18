//
//  SNQuestionFloatBall.h
//  SportNews
//
//  Created by 根哥 on 2021/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNQuestionFloatBall : BaseXibView

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

- (void)setupIsLive:(BOOL)isLive;

@end

NS_ASSUME_NONNULL_END
