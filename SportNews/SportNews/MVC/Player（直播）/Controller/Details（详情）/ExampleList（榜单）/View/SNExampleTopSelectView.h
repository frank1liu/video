//
//  SNExampleTopSelectView.h
//  SportNews
//
//  Created by kkk on 2021/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNExampleTopSelectView : UIView

@property (nonatomic, copy) void(^clickWithTag)(NSInteger tag);

- (void)reloadDataWithArray:(NSArray *)datasArray;
@property (nonatomic, strong) UIColor                   *contentViewColor;
@property (nonatomic, strong) UIColor                   *textColor;
@property (nonatomic, strong) UIColor                   *selectTextColor;

@property (nonatomic, assign) CGFloat                    marginLeft;
@property (nonatomic, assign) CGFloat                    marginTop;
@property (nonatomic, assign) CGFloat                    buttonWidth;
@property (nonatomic, assign) CGFloat                    buttonHeight;

@property(nonatomic, assign) BOOL notScroll;

@end

NS_ASSUME_NONNULL_END
