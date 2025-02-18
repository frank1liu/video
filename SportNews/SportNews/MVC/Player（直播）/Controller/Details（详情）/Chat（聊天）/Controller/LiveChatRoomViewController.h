//
//  LiveChatRoomViewController.h
//  SportNews
//
//  Created by kkk on 2021/1/16.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "JXPagerView.h" 

NS_ASSUME_NONNULL_BEGIN

@interface LiveChatRoomViewController : UIViewController <JXPagerViewListViewDelegate>
   
@property (nonatomic, copy) BOOL(^canShowDanMu)(void);

@property (nonatomic, copy) void(^checkDanMu)(void);

@property(nonatomic, strong) LiveListModel *model;

@property (strong, nonatomic) UITableView *messageTableView;

@property(nonatomic, strong) NSString *liveUserName;
@property(nonatomic, strong) NSString *matchType;           // type: 1 足球  2 篮球

//房间ID
@property (nonatomic, copy, nullable) NSString  *roomID;
 
//用于切换主播
@property(nonatomic, strong) LiveCartoonModel *cartoonModel;

//是否正在播放动画
@property (nonatomic , assign) PlayingStatus playStatus;
   
//更新tableView的高度
- (void)updateScrollViewHeight:(PlayingStatus)playStatus;
  
//更新在线人数
- (void)updateOnlineCount:(NSString *)count;

//切换分辨率
- (void)selectCartoonModel:(LiveCartoonModel *)cartoonModel;
 
//滚到底部
- (void)scrollToBottom:(BOOL)animated;

//比赛是否开始了
- (void)isGameStart:(BOOL)start gameStatus:(NSInteger)gameStatus;

//检测是否退出登录
- (void)isLoginOut;
 
//释放所有
- (void)deallocChatVc;

@end

NS_ASSUME_NONNULL_END
