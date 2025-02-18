//
//  SNMissionCenterSignInCellView.h
//  SportNews
//
//  Created by kkk on 2021/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNMissionCenterSignInCellView : UIView

- (instancetype)initWithFrame:(CGRect)frame withTime:(NSString *)time;

@property(nonatomic, assign) NSInteger style;

@end

NS_ASSUME_NONNULL_END
