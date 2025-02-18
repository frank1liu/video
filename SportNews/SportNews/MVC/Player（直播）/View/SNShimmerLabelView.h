//
//  SNShimmerLabelView.h
//  SportNews
//
//  Created by kkk on 2021/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
 
@interface SNShimmerLabelView : UIView


// UILabel 常用属性
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) NSAttributedString *attributedText;
@property (assign, nonatomic) NSInteger numberOfLines;

// CKShimmerLabel 属性 
@property (assign, nonatomic) BOOL repeat;                      // 循环播放，默认是
@property (assign, nonatomic) CGFloat shimmerWidth;             // 闪烁宽度，默认20
@property (assign, nonatomic) CGFloat shimmerRadius;            // 闪烁半径，默认20
@property (strong, nonatomic) UIColor *shimmerColor;            // 闪烁颜色，默认#555555
@property (assign, nonatomic) NSTimeInterval durationTime;      // 持续时间，默认2秒

- (void)startShimmer;   // 开始闪烁，闪烁期间更改上面属性立即生效
- (void)stopShimmer;    // 停止闪烁

@end

NS_ASSUME_NONNULL_END
