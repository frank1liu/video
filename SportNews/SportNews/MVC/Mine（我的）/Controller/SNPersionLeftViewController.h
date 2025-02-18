//
//  SNPersionLeftViewController.h
//  SportNews
//
//  Created by kkk on 2021/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNPersionLeftViewController : UIViewController

@property (nonatomic, copy) void(^hideBlock)(void);

//1个人中心  2意见反馈
@property (nonatomic, copy) void(^clickOtherBlock)(NSInteger index);

- (void)reloadView;

@end

NS_ASSUME_NONNULL_END
