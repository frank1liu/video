//
//  LiveMembersViewController.h
//  SportNews
//
//  Created by kkk on 2021/1/16.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveMembersViewController : UIViewController <JXPagerViewListViewDelegate>

@property(nonatomic, strong) LiveListModel *model;

@end

NS_ASSUME_NONNULL_END
