//
//  SNDatasFootModel.h
//  SportNews
//
//  Created by kkk on 2021/2/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasFootHistoryRecordModel : NSObject

//比赛id
@property(nonatomic, strong) NSNumber *ids;
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

//球队2 id - int"
@property(nonatomic, strong) NSNumber *aIds;
//球队2 名字
@property(nonatomic, copy) NSString *aName;
//球队2 分数
@property(nonatomic, copy) NSString *aScore;


//半场比分数
@property(nonatomic, copy) NSString *scoreBan;
//全场比分数
@property(nonatomic, copy) NSString *scoreQuan;


//盘路数值
@property(nonatomic, strong) NSNumber *valuePan;
//盘路描述
@property(nonatomic, copy) NSString *describePan;

//进球数值
@property(nonatomic, strong) NSNumber *scoreQiu;
//进球描述
@property(nonatomic, copy) NSString *describeQiu;

//角球个数
@property(nonatomic, strong) NSNumber *jiaoCount;

@end




@interface SNDatasFootInjuryModel : NSObject

@property(nonatomic, copy) NSString *reason;
@property(nonatomic, strong) NSNumber *end_time;
@property(nonatomic, strong) NSNumber *missed_matches;
@property(nonatomic, assign) NSInteger ids;
@property(nonatomic, copy) NSString *position;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *logo;

@end
 

@class SNDatasFootGoalDetailModel;
@interface SNDatasFootGoalModel : NSObject

 
@property(nonatomic, strong) SNDatasFootGoalDetailModel *all;
 
@property(nonatomic, strong) SNDatasFootGoalDetailModel *away;

@property(nonatomic, strong) SNDatasFootGoalDetailModel *home;
  

@end

@interface SNDatasFootGoalDetailModel : NSObject

@property(nonatomic, strong) NSArray *conceded;

@property(nonatomic, strong) NSArray *scored;

@property(nonatomic, assign) NSInteger matches;

@end

 

NS_ASSUME_NONNULL_END
