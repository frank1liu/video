//
//  LoginCodeView.h
//  SportNews
//
//  Created by kkk on 2020/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VerCodeBlock)(NSString *text);


@interface LoginCodeView : UIView

@property (nonatomic, copy) VerCodeBlock codeBlock;

@property (nonatomic, assign) NSInteger inputType;

- (void)initSubviews;

@end

NS_ASSUME_NONNULL_END
