//
//  SNSquadModel.h
//  SportNews
//
//  Created by kkk on 2021/2/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNSquadModel : NSObject

@property (nonatomic, copy) NSString    *ids;
@property (nonatomic, copy) NSString    *confirmed;
 
@property (nonatomic, copy) NSString    *home_manager; //主队教练
@property (nonatomic, copy) NSString    *away_manager;

@property (nonatomic, copy) NSString    *home_formation; //主队阵型描述1-2-3
@property (nonatomic, copy) NSString    *away_formation;

@property (nonatomic, strong) NSArray   *home_zhengxing;//主队阵型
@property (nonatomic, strong) NSArray   *away_zhengxing;

@property (nonatomic, strong) NSArray   *home_huanren;//主队换人
@property (nonatomic, strong) NSArray   *away_huanren;

@property (nonatomic, strong) NSArray   *home_tibu;//主队替补
@property (nonatomic, strong) NSArray   *away_tibu;

@property (nonatomic, strong) NSArray   *home_injury;//主队伤停
@property (nonatomic, strong) NSArray   *away_injury;

@end

 
@interface SNSquadPersonInfoModel : NSObject

@property (nonatomic, assign) NSInteger            ids;
@property (nonatomic, copy) NSString            *logo; //主队阵型
@property (nonatomic, copy) NSString            *name;
@property (nonatomic, copy) NSString            *position;

@property (nonatomic, assign) CGFloat           x;
@property (nonatomic, assign) CGFloat           y;

@property (nonatomic, copy) NSString            *rating; //评分
@property (nonatomic, copy) NSString            *shirt_number;

@property (nonatomic, assign) BOOL            isaway_type; //默认主队

//事件
@property (nonatomic, strong) NSArray   *shijian;

//换人
@property (nonatomic, copy) NSString            *out_name;
@property (nonatomic, copy) NSString            *out_logo;
@property (nonatomic, copy) NSString            *out_id;
@property (nonatomic, copy) NSString            *out_rating;
@property (nonatomic, copy) NSString            *out_shirt_number;
@property (nonatomic, copy) NSString            *in_name;
@property (nonatomic, copy) NSString            *in_logo;
@property (nonatomic, copy) NSString            *in_id;
@property (nonatomic, copy) NSString            *in_rating;
@property (nonatomic, copy) NSString            *in_shirt_number;
@property (nonatomic, copy) NSString            *minute;


//受伤
@property (nonatomic, copy) NSString            *reason;
@property (nonatomic, assign) NSInteger            end_time;
@property (nonatomic, assign) NSInteger            missed_matches;
@property (nonatomic, assign) NSInteger            start_time;
@property (nonatomic, assign) NSInteger            type;

@end

//加了事件字段shijian：type 事件类型 time 事件发生时间  minute 事件发生时比赛分钟数 belong 发生方，0 中立 1 主队 2 客队，
//换人事件发生情况下增加2个字段：in_player_id 换进球员ID in_player_name 换进球员名称
@interface SNSquadShijianModel : NSObject
 
//type = 1进球的时候 才有 两个助攻的人
@property (nonatomic, copy)   NSString *zhugong1_name;
@property (nonatomic, assign) NSInteger zhugong1_id;
@property (nonatomic, copy)   NSString *zhugong2_name;
@property (nonatomic, assign) NSInteger zhugong2_id;

@property (nonatomic, copy)   NSString *in_player_name;
@property (nonatomic, assign) NSInteger in_player_id;

@property (nonatomic, copy)   NSString *out_player_name;
@property (nonatomic, assign) NSInteger out_player_id;

@property (nonatomic, assign) NSInteger player_id;

@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger belong;
@property (nonatomic, copy)   NSString *time;

/*
 type字段说明：
 | 状态码 |   描述
 | ------ | -------
 | 1      | 进球
 | 2      | 角球
 | 3      | 黄牌
 | 4      | 红牌
 | 5      | 界外球
 | 6      | 任意球
 | 7      | 球门球
 | 8      | 点球
 | 9      | 换人
 | 10     | 比赛开始
 | 11     | 中场
 | 12     | 结束
 | 13     | 半场比分
 | 15     | 两黄变红
 | 16     | 点球未进
 | 17     | 乌龙球
 | 19     | 伤停补时
 | 21     | 射正
 | 22     | 射偏
 | 23     | 进攻
 | 24     | 危险进攻
 | 25     | 控球率
 | 26     | 加时赛结束
 | 27     | 点球大战结束
 | 28     | VAR(视频助理裁判)
 | 29     | 点球(点球大战)(type_v2字段返回)
 | 30     | 点球未进(点球大战)(type_v2字段返回)
 | 31     |助攻 自己添加的
 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy)   NSString *typeImage;
@property (nonatomic, assign) BOOL showTime;

@end

 
@interface SNPlayerDetail : NSObject

@property (nonatomic, assign) NSInteger bei_qinfan;
@property (nonatomic, copy)   NSString *chuchang;
@property (nonatomic, copy)   NSString *shemen_shezheng;
@property (nonatomic, assign) NSInteger hongpai;
@property (nonatomic, copy)   NSString *fangui_yuewei;
@property (nonatomic, assign) NSInteger fengdu_shemen;
@property (nonatomic, copy)   NSString *chuanqiu_chenggong;
@property (nonatomic, assign) NSInteger jiewei;
@property (nonatomic, copy)   NSString *shirt_number;
@property (nonatomic, copy)   NSString *jinqiu_dianqiu;
@property (nonatomic, copy)   NSString *team_name;
@property (nonatomic, copy)   NSString *guanyongjiao;
@property (nonatomic, assign) double pingfen;
@property (nonatomic, assign) NSInteger zhugong;
@property (nonatomic, assign) NSInteger weixie_chuanqiu;
@property (nonatomic, copy)   NSString *player_name;
@property (nonatomic, copy)   NSString *guoren_chenggong;
@property (nonatomic, copy)   NSString *win_rate;
@property (nonatomic, assign) NSInteger huangpai;
@property (nonatomic, copy)   NSString *shanchangweizhi;
@property (nonatomic, assign) NSInteger shoufa;
@property (nonatomic, assign) NSInteger duanqiu;
@property (nonatomic, copy) NSString *logo;


@end


NS_ASSUME_NONNULL_END
