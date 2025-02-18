//
//  SNStatisticalProgressContentView.h
//  SportNews
//
//  Created by kkk on 2021/1/26.
//

#import <UIKit/UIKit.h>
#import "SNStatisticalModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SNStatisticalProgressContentView : UIView

@property (nonatomic, strong) UILabel *centerLabel;

@property (nonatomic, strong) UILabel *leftLabel;
 
@property (nonatomic, strong) UILabel *rightLabel;

- (void)leftProgress:(NSInteger)progressL rightProgress:(NSInteger)progressR;

@end

@interface SNStatisticalProgressView : UIView

@property(nonatomic, assign) CGFloat progress;

- (instancetype)initWithFrame:(CGRect)frame withType:(ProgressViewType)type;

@end

NS_ASSUME_NONNULL_END
