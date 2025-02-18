//
//  SNDatasBasketModel.h
//  SportNews
//
//  Created by kkk on 2021/2/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//篮球的历史交锋 和 近期战绩
@interface SNDatasBasketHistoryRecordModel : NSObject

//比赛id
@property(nonatomic, strong) NSNumber *ids;
//比赛节数
@property(nonatomic, strong) NSNumber *count;
//赛事id
@property(nonatomic, strong) NSNumber *cid;
//比赛名字
@property(nonatomic, copy) NSString *gameName;
//比赛状态
@property(nonatomic, strong) NSNumber *status;
//比赛时间
@property(nonatomic, copy) NSString *time;

//当前小节所剩时间 总秒数
@property(nonatomic, strong) NSNumber *LeaveTime;

//球队1 id - int"
@property(nonatomic, strong) NSNumber *hIds;
//球队1 名字
@property(nonatomic, copy) NSString *hName;
//球队1 分数
@property(nonatomic, copy) NSString *hScore;
//球队1 半场分数
@property(nonatomic, copy) NSString *hScoreBan;

//球队2 id - int"
@property(nonatomic, strong) NSNumber *aIds;
//球队2 名字
@property(nonatomic, copy) NSString *aName;
//球队2 分数
@property(nonatomic, copy) NSString *aScore;
//球队2 半场分数
@property(nonatomic, copy) NSString *aScoreBan;


//半场比分数
@property(nonatomic, copy) NSString *scoreBan;
//半场总分数
@property(nonatomic, strong) NSNumber *totalScoreBan;

//全场比分数
@property(nonatomic, copy) NSString *scoreQuan;
//全场总分数
@property(nonatomic, strong) NSNumber *totalScoreQuan;


//让分数值
@property(nonatomic, strong) NSNumber *scoreRang;
//让分描述
@property(nonatomic, copy) NSString *describeRang;

//总分数值
@property(nonatomic, strong) NSNumber *scoreZong;
//总分描述
@property(nonatomic, copy) NSString *describeZong;

//是否是主队
@property(nonatomic, assign) BOOL isHome;

//修正让分结果
- (void)reviseDescribeRang:(NSString *)teamName;

//获取近期战绩的统计文字
+ (NSMutableAttributedString *)getRecentResultsString:(NSArray *)array isHome:(BOOL)isHome homeName:(NSString *)homeName isHistory:(BOOL)isHistory;
 
@end



 

NS_ASSUME_NONNULL_END
