//
//  SNDatasModel.h
//  SportNews
//
//  Created by kkk on 2021/1/30.
//

#import <Foundation/Foundation.h>
#import "SNDatasBasketModel.h"
#import "SNDatasFootModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SNDatasHistoryModel, SNDatasInjuryModel, SNDatasInfoModel, SNDatasTableModel, SNDatasGoalDistributionModel, SNDatasFixtureModel, SNDatasRecentMatch, SNDatasRankModel, SNDatasCompareModel;

@interface SNDatasModel : NSObject

//历史交锋/近期战绩 
@property(nonatomic, strong) SNDatasHistoryModel *history;

//当前比赛的id
@property(nonatomic, copy) NSString *ids;

//伤停情况
@property(nonatomic, strong) SNDatasInjuryModel *injury;

//联赛积分，可能不存在
@property(nonatomic, strong) SNDatasTableModel *table;

//进球分布，可能不存在
@property(nonatomic, strong) SNDatasGoalDistributionModel *goal_distribution;


//篮球的
//历史交锋/近期战绩
@property(nonatomic, strong) SNDatasHistoryModel *result;
 
@property(nonatomic, strong) SNDatasFixtureModel *fixture;

//排名
@property(nonatomic, strong) SNDatasRankModel *away_rank;
@property(nonatomic, strong) SNDatasRankModel *home_rank;


//场均对比
@property(nonatomic, strong) SNDatasCompareModel *away_compare;
@property(nonatomic, strong) SNDatasCompareModel *home_compare;

//足球近期赛程
@property(nonatomic, strong) SNDatasRecentMatch *recent_match;


//共同的 比赛信息字段说明 足球11个  篮球 10个
@property(nonatomic, copy) NSString *info;

@property(nonatomic, strong) NSArray *infoArray;

@end



@interface SNDatasHistoryModel : NSObject

//主队近期战绩（格式同 比赛信息字段），没有数据为空
@property(nonatomic, strong) NSArray *home;

//历史交锋（格式同 比赛信息字段），没有数据为空
@property(nonatomic, strong) NSArray *vs;

//客队近期战绩（格式同 比赛信息字段），没有数据为空
@property(nonatomic, strong) NSArray *away;

//篮球历史交锋
@property(nonatomic, strong) NSArray <SNDatasBasketHistoryRecordModel *>*basketVs;
//足球历史交锋
@property(nonatomic, strong) NSArray <SNDatasFootHistoryRecordModel *>*footVs;

//篮球主队的近期战绩
@property(nonatomic, strong) NSArray <SNDatasBasketHistoryRecordModel *>*basketHome;
//篮球客队的近期战绩
@property(nonatomic, strong) NSArray <SNDatasBasketHistoryRecordModel *>*basketAway;

//足球主队的近期战绩
@property(nonatomic, strong) NSArray <SNDatasFootHistoryRecordModel *>*footHome;
//足球客队的近期战绩
@property(nonatomic, strong) NSArray <SNDatasFootHistoryRecordModel *>*footAway;




@end



@interface SNDatasInjuryModel : NSObject
 
//足球主队受伤情况
@property(nonatomic, strong) NSArray <SNDatasFootInjuryModel *>*home;
//客队
@property(nonatomic, strong) NSArray <SNDatasFootInjuryModel *>*away;

@end



@interface SNDatasInfoModel : NSObject

@property(nonatomic, strong) NSArray *home;
 
@property(nonatomic, strong) NSArray *away;

@end

//联赛积分，可能不存在
@class SNDatasTableDataModel;
@interface SNDatasTableModel : NSObject


@property(nonatomic, copy) NSString *season_id;

@property(nonatomic, copy) NSString *season;

@property(nonatomic, copy) NSString *stage_id;

@property(nonatomic, copy) NSString *event_name;

@property(nonatomic, strong) SNDatasTableDataModel *data;
 

@end


@interface SNDatasTableDataModel : NSObject

@property(nonatomic, strong) NSArray *home;

@property(nonatomic, strong) NSArray *all;

@property(nonatomic, strong) NSArray *away;

@end

//进球分布，可能不存在
@interface SNDatasGoalDistributionModel : NSObject

@property(nonatomic, strong) SNDatasFootGoalModel *home;
 
@property(nonatomic, strong) SNDatasFootGoalModel *away;

@end


@interface SNDatasFixtureModel : NSObject

@property(nonatomic, strong) NSArray *home;
 
@property(nonatomic, strong) NSArray *away;

@property(nonatomic, strong) NSArray *teams;


@end

@interface SNDatasRecentMatch : NSObject

@property(nonatomic, strong) NSArray *home;
 
@property(nonatomic, strong) NSArray *away;

@end


@interface SNDatasRankModel : NSObject

@property(nonatomic, copy) NSString *shenglv;
@property(nonatomic, copy) NSString *kechang_zhanji;
@property(nonatomic, assign) NSInteger paiming;
@property(nonatomic, copy) NSString *zhuchang_zhanji;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *jinqi_zhanji;
@property(nonatomic, copy) NSString *jin10_zhanji;
@property(nonatomic, assign) NSInteger win;
@property(nonatomic, assign) NSInteger lost;

@end

@interface SNDatasCompareModel : NSObject
 
@property(nonatomic, strong) NSNumber *lanban;
@property(nonatomic, strong) NSNumber *gaimao;
@property(nonatomic, strong) NSNumber *defen;
@property(nonatomic, strong) NSNumber *qiangduan;
@property(nonatomic, strong) NSNumber *zhugong;

@property(nonatomic, copy) NSString *sanfen;
@property(nonatomic, copy) NSString *faqiu;
@property(nonatomic, copy) NSString *toulan;

@end

NS_ASSUME_NONNULL_END
