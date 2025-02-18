//
//  SNGoalNewsAlert.h
//  SportNews
//
//  Created by 根哥 on 2021/4/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNGoalNewsAlert : UIView

- (id)initWithDataSource:(NSArray *)dataSource;
- (void)show;
@end

NS_ASSUME_NONNULL_END
