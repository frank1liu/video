//
//  SNBasketBallResult.h
//  SportNews
//
//  Created by kkk on 2021/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNBasketBallResult : NSObject

@property (nonatomic, strong) NSNumber      *ID;

@property (nonatomic, strong) NSArray       *players; //球员

@property (nonatomic, strong) NSArray       *score; //即时比分

@property (nonatomic, strong) NSArray       *stats; //数据

@property (nonatomic, strong) NSArray       *tlive; //文字直播 

@property (nonatomic, copy) NSString       *sectionString; //第几节

@property(nonatomic, assign) NSInteger status; //状态

@end

@interface SNBasketBallTliveModel : NSObject

@property(nonatomic, assign) BOOL isNew;

@property (nonatomic, copy) NSString       *section; //第几节
@property (nonatomic, copy) NSString       *sectionString; //第几节
@property (nonatomic, assign) NSInteger     index; //消息排在第几条，用于消息脱氯
@property (nonatomic, copy) NSString       *time; //时间
@property (nonatomic, copy) NSString       *score; //即时比分
@property (nonatomic, assign) NSInteger     t_type; //文案类型 主客队(0中立，1主队，2客队)
@property (nonatomic, copy) NSString       *text; //文字


@end

NS_ASSUME_NONNULL_END
