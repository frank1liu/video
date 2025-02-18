//
//  SNExampleBaseModel.h
//  SportNews
//
//  Created by 根哥 on 2021/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNExampleBaseModel : NSObject

@property (nonatomic, copy) NSString            *reuseCellId;
@property (nonatomic, strong) NSIndexPath       *indexPath;
@property (nonatomic, copy) NSString            *reuseHeaderId;
@property (nonatomic, assign) SNBasketRankType          rankType;

// 球队榜 team_name team_logo name name_id win_lose win_rate jinkuang
@property (nonatomic, copy) NSString            *team_name;
@property (nonatomic, copy) NSString            *team_logo;
@property (nonatomic, copy) NSString            *name;
@property (nonatomic, copy) NSString            *name_id;
@property (nonatomic, copy) NSString            *win_lose;
@property (nonatomic, strong) NSNumber          *data; //数据
 
@property (nonatomic, copy) NSString            *win_rate;
@property (nonatomic, copy) NSString            *jinkuang;
 
@property (nonatomic, copy) NSString            *conference;
@property (nonatomic, copy) NSString            *division;
@property (nonatomic, copy) NSString            *win_cha;
 
//球员榜 player_logo zhu player_name data team_name ban fen
@property (nonatomic, copy) NSString            *player_logo;
@property (nonatomic, copy) NSString            *player_name;
@property (nonatomic, strong) NSNumber          *fen; //得分
@property (nonatomic, strong) NSNumber          *ban; //篮板
@property (nonatomic, strong) NSNumber          *zhu; //助攻


//伤停榜 logo status reason type name_zh team_name
@property (nonatomic, copy) NSString            *logo;
@property(nonatomic, assign) NSInteger          status;
@property (nonatomic, copy) NSString            *reason;
@property(nonatomic, assign) NSInteger          type;
@property (nonatomic, copy) NSString            *typeString; //伤病类型
@property (nonatomic, copy) NSString            *statusString; //伤病状态

@property (nonatomic, copy) NSString            *name_zh;


@end

NS_ASSUME_NONNULL_END
