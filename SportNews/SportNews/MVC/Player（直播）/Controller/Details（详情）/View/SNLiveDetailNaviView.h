//
//  SNLiveDetailNaviView.h
//  SportNews
//
//  Created by K哥 on 2021/2/9.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNFootBallResult.h"
#import "SNBasketBallResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNLiveDetailNaviView : BaseXibView

@property (nonatomic , copy) void(^navBackBlock)(NSInteger tag);

@property (weak, nonatomic) IBOutlet UIView *backView;

@property(nonatomic, strong) LiveListModel *model;

@property (weak, nonatomic) IBOutlet UILabel *centerLabel;

//直播
@property(nonatomic, strong) SNFootBallResult *resultFootObj;

//直播
@property(nonatomic, strong) SNBasketBallResult *resultBasketObj;

@property (nonatomic , copy) NSString *scoreStr;
@property(nonatomic, assign) NSInteger footStatus;
@property(nonatomic, assign) NSInteger basketStatus;

- (void)hideOtherNoNeedView;

@end

NS_ASSUME_NONNULL_END
