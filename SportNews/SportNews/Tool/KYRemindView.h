//
//  KYRemindView.h
//  SportNews
//
//  Created by K哥 on 2021/1/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYRemindView : UIView

+ (void)showWithStatus:(NSString *)status;

+ (void)show;

+ (void)showWithView:(UIView * __nullable)view;

+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
