//
//  LiveListModel.h
//  SportNews
//
//  Created by pangchong on 2020/12/7.
//

#import <Foundation/Foundation.h>
#import "LiveCartoonModel.h"
#import "MacroOthers.h"


NS_ASSUME_NONNULL_BEGIN

@interface LiveListModel : NSObject

@property(nonatomic, strong) NSString *ateam_logo;
@property(nonatomic, strong) NSString *ateam_name;
@property(nonatomic, strong) NSString *ateam_id;

@property(nonatomic, strong) NSNumber *cid;
@property(nonatomic, strong) NSString *hteam_logo;
@property(nonatomic, strong) NSString *hteam_name;
@property(nonatomic, strong) NSString *hteam_id;

@property(nonatomic, strong) NSString *clogo;

@property(nonatomic, strong) NSNumber *ID;
@property(nonatomic, strong) NSString *matchtime;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *score;
//比赛状态：0 开赛中  1 未开赛  2 比赛结束 3 比赛推迟 4 未确定的 5 已取消的
@property(nonatomic, strong) NSNumber *status;
 
//当前的比赛状态
@property(nonatomic, assign) NSInteger status_up;
//比赛状态中文
@property(nonatomic, copy) NSString *status_up_name;
 
//1 足球 2 篮球
@property(nonatomic, strong) NSNumber *type;

@property(nonatomic, strong) NSArray<LiveCartoonModel *> *live_cartoon_url;

//
@property(nonatomic, strong) NSArray<LiveCartoonModel *> *live_urls;

//当前选择的播放模型
@property(nonatomic, strong, nullable) LiveCartoonModel *selectCartoonModel;

@property(nonatomic, assign) NSInteger online_num;

@property(nonatomic, strong) NSNumber *ishot;
//直播类型：0 动画直播 1 视频直播 2 动画+视频直播
@property(nonatomic, assign) NSInteger live_type;
//1 top    0 没有哪个火 未开赛 notop
@property(nonatomic, assign) NSInteger listType;
//来自通知
@property(nonatomic, assign) BOOL comeFromNotice;
 
  
@property(nonatomic, copy) NSString *time;//时间

@property(nonatomic, copy) NSString *jiaoqiu;//角球

//@"yazhi_jishi" : @"0.775,0.25,1.025"
@property(nonatomic, copy) NSString *yazhi_jishi;//亚指

@property(nonatomic, copy) NSString *banchang;//半场

//@"ouzhi_jishi" : @"1.002,51.0,51.0"
@property(nonatomic, copy) NSString *ouzhi_jishi;//欧指

//@"daxiao_jishi" : @"1.025,5.75,0.775"
@property(nonatomic, copy) NSString *daxiao_jishi;//大小指

//小节分数 1234 加时 {0,0,0,0,0}
@property(nonatomic, strong) NSArray *away_score_xiaojie;
@property(nonatomic, strong) NSArray *home_score_xiaojie;

@property(nonatomic, copy) NSString *video_url;//回放地址

//是否有更新
@property(nonatomic, assign) BOOL isNew;

/// 队伍1比分是否更新
@property(nonatomic, assign) BOOL isT1New;

/// 队伍2比分是否更新
@property(nonatomic, assign) BOOL isT2New;

//其他比赛的
@property(nonatomic, assign) NSInteger sports_type;

@property(nonatomic, copy) NSString *otherTitle;
@property(nonatomic, copy) NSString *cname;

@property(nonatomic, assign) CGFloat contentHeight;

// Adam
@property(nonatomic, assign) NSInteger is_zd;
@property(nonatomic, strong) NSString  *zd_level;

@end

NS_ASSUME_NONNULL_END
