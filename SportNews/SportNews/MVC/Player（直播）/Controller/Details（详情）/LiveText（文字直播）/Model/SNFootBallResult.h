//
//  SNFooterBallResult.h
//  SportNews
//
//  Created by yang on 2021/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNFootBallResult : NSObject
 
@property (nonatomic, strong) NSNumber                     *ID;
@property (nonatomic, strong) NSArray                   *score; //即时比分
@property (nonatomic, strong) NSArray                   *stats; //比赛统计
@property (nonatomic, strong) NSArray                   *tlive; //文字直播
@property (nonatomic, strong) NSArray                   *incidents; //比赛事件

@end


@interface SNFootBallIncidentsModel : NSObject

@property (nonatomic, copy) NSString                   *type; //
//事件发生方，0-中立 1-主队 2-客队 3时间 4哨子  3、4自己添加的
@property (nonatomic, copy) NSString                   *position;
@property (nonatomic, copy) NSString                   *time; //
@property (nonatomic, copy) NSString                   *second; //
 
@property (nonatomic, copy) NSString                   *player_id; //事件相关球员id，可能为空
@property (nonatomic, copy) NSString                   *player_name; //事件相关球员名称，可能为空
@property (nonatomic, copy) NSString                   *assist1_id; //进球时，助攻球员1 id，可能为空
@property (nonatomic, copy) NSString                   *assist1_name; //进球时，助攻球员1 名称，可能为空
@property (nonatomic, copy) NSString                   *assist2_id; //进球时，助攻球员2 id，可能为空
@property (nonatomic, copy) NSString                   *assist2_name; //进球时，助攻球员2 名称，可能为空
@property (nonatomic, copy) NSString                   *in_player_id; //换人时，换上球员id，可能为空
@property (nonatomic, copy) NSString                   *in_player_name; //换人时，换上球员名称，可能为空
@property (nonatomic, copy) NSString                   *out_player_id; //换人时，换下球员id，可能为空
@property (nonatomic, copy) NSString                   *out_player_name; //换人时，换下球员名称，可能为空
@property (nonatomic, copy) NSString                   *home_score; //进球时，主队比分，可能不存在
@property (nonatomic, copy) NSString                   *away_score; //进球时，客队比分，可能不存在
//VAR原因，可能不存在，1-进球判定、2-进球未判定、3-点球判定、4-点球未判定、5-红牌判定、6-两黄变红判定、7-错认身份、0-其他
@property (nonatomic, copy) NSString                   *var_reason;
//VAR结果，可能不存在，1-进球有效、2-进球无效、3-点球有效、4-点球取消、5-红牌有效、6-红牌取消、7-两黄变红、8-两黄变红取消、9-维持原判、10-判罚更改、0-未知
@property (nonatomic, copy) NSString                   *var_result;

@property(nonatomic, assign) CGFloat cellHeight;

@property(nonatomic, strong) NSString *iconImageStr;

@property(nonatomic, strong) NSString *typeStr;

@end


@interface SNFootBallScoreModel : NSObject

@property (nonatomic, copy) NSArray                   *score; //即时比分
@property (nonatomic, copy) NSString                   *stats; //比赛统计

@end


@interface SNFootBallStatsModel : NSObject

/* type = 1:进球  2:角球  3:黄  4:红牌  5:界外球 6:任意球  7:球门球  8:点球  9:换人  10:比赛开始
  11       中场
  12       结束
  13       半场比分
  15       两黄变红
  16       点球未进
  17       乌龙球
  19       伤停补时
  21       射正
  22       射偏
  23       进攻
  24       危险进攻
  25       控球率
  26       加时赛结束
  27       点球大战结束
  28       VAR(视频助理裁判)
*/
@property (nonatomic, assign) NSInteger                  type;
@property (nonatomic, assign) NSInteger                  home; //比赛统计
@property (nonatomic, assign) NSInteger                  away; //文字直播
@property (nonatomic, copy) NSString                     *typeName;


@end


@interface SNFootBallTextLiveModel : NSObject

@property(nonatomic, assign) BOOL isNew;

@property (nonatomic, copy) NSString                   *main; //是否重要事件
@property (nonatomic, copy) NSString                   *data; //描述
@property (nonatomic, copy) NSString                   *position; //事件发生方，0-中立 1-主队 2-客队

@property (nonatomic, copy) NSString                   *type; //
@property (nonatomic, copy) NSString                   *time; //


@property (nonatomic, copy) NSString                     *imageName;

@end

NS_ASSUME_NONNULL_END
