//
//  SNStatisticalModel.h
//  SportNews
//
//  Created by kkk on 2021/1/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SNStatisticalHeaderMemberModel, SNStatisticalHeaderTeamModel;

@interface SNStatisticalModel : NSObject

@property(nonatomic, strong) SNStatisticalHeaderTeamModel *awayrank;

@property(nonatomic, strong) SNStatisticalHeaderTeamModel *homerank;
 
@property(nonatomic, strong) NSArray *players;


@property(nonatomic, strong) NSArray *homePlayers;

@property(nonatomic, strong) NSArray *awayPlayers;

@property(nonatomic, assign) NSInteger mid;

//最下面的总数据
@property(nonatomic, strong) NSArray *allDatas;

@end

//最下面的总数据
@interface SNStatisticalPlayerDataModel : NSObject

@property(nonatomic, copy) NSString *name;//名字

@property(nonatomic, copy) NSString *time;//在场持续时间
@property(nonatomic, copy) NSString *count;//命中次数-投篮次数
@property(nonatomic, copy) NSString *threeCount;//三分球投篮命中次数-三分投篮次数
@property(nonatomic, copy) NSString *faCount;//罚球命中次数-罚球投篮次数

@property(nonatomic, copy) NSString *jGLanban;//进攻篮板
@property(nonatomic, copy) NSString *fSLanban;//防守篮板
@property(nonatomic, copy) NSString *zongLanban;//总的篮板
@property(nonatomic, copy) NSString *zhugong;//助攻数

@property(nonatomic, copy) NSString *qiangduan;//抢断数
@property(nonatomic, copy) NSString *gaimao;//盖帽数
@property(nonatomic, copy) NSString *shiwu;//失误次数
@property(nonatomic, copy) NSString *fangui;//个人犯规次数

@property(nonatomic, copy) NSString *defen;//得分
@property(nonatomic, assign) NSInteger isChuChang;//是否出场(1-出场，0-没出场)
@property(nonatomic, assign) NSInteger isPlaying;//是否在场上（0-在场上，1-没在场上）（用于赛中)
@property(nonatomic, assign) NSInteger isTiBu;//是否是替补（1-替补，0-首发） 


@end


//最下面的总数据
@interface SNStatisticalPlayerBottomModel : NSObject

@property(nonatomic, assign) NSInteger defen;
@property(nonatomic, assign) NSInteger lanban;
@property(nonatomic, assign) NSInteger zhugong;

@property(nonatomic, assign) NSInteger gaimao;
@property(nonatomic, assign) NSInteger qiangduan;
@property(nonatomic, assign) NSInteger shiwu;


@end


@interface SNStatisticalHeaderTeamModel : NSObject

@property(nonatomic, strong) SNStatisticalHeaderMemberModel *zhugong;

@property(nonatomic, strong) SNStatisticalHeaderMemberModel *lanban;

@property(nonatomic, strong) SNStatisticalHeaderMemberModel *defen;

@end




@interface SNStatisticalHeaderMemberModel : NSObject

@property(nonatomic, assign) NSInteger lanban;
@property(nonatomic, assign) NSInteger defen;
@property(nonatomic, assign) NSInteger zhugong;
@property(nonatomic, assign) NSInteger playerid;

@property(nonatomic, copy) NSString *name_e;
@property(nonatomic, copy) NSString *name_zht;
@property(nonatomic, copy) NSString *name_zh;
@property(nonatomic, copy) NSString *qiuyi;
@property(nonatomic, copy) NSString *logo;

//1 得分  2篮板  3助攻
@property(nonatomic, assign) NSInteger currentType;

@end


//篮球统计的
@interface SNStatisticalPlayerModel : NSObject

@property(nonatomic, assign) NSInteger changci;

@property(nonatomic, strong) NSArray *player;

@end


NS_ASSUME_NONNULL_END
