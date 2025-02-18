//
//  SNLiveListTopView.h
//  SportNews
//
//  Created by kkk on 2021/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNLiveListTopView : UIView

@property (nonatomic, copy) void(^showCalendarBlock)(void);

@property (nonatomic, copy) void(^choiceItem)(NSString *);

@property (nonatomic, copy) void(^reloadTop)(void);

@property(nonatomic, assign) BOOL isHideCount;

- (void)reloadDayNuber:(NSMutableDictionary *)dayData;

- (void)changeChoice:(NSString *)choice;

- (void)changeChoiceNotAnimated:(NSString *)choice;

@end

NS_ASSUME_NONNULL_END
