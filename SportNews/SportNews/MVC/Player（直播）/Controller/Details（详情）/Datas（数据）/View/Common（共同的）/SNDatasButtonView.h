//
//  SNDatasButtonView.h
//  SportNews
//
//  Created by kkk on 2021/2/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasButtonView : UIView

@property(nonatomic, copy) void (^selectBlock)(BOOL isSelect);

- (void)setupCoverBtn:(BOOL)select;

- (void)leftText:(NSString *)leftStr rightText:(NSString *)rightStr;

@end

NS_ASSUME_NONNULL_END
