//
//  SNLiveHeaderView.h
//  SportNews
//
//  Created by yang on 2021/1/19.
//

#import <UIKit/UIKit.h>
#import "SNCircleProgress.h"

NS_ASSUME_NONNULL_BEGIN
@class SNFootBallStatsModel;

@interface SNLiveFootBallHeaderView : UIView
@property (nonatomic, copy) void(^checkMore)(void);
@property (nonatomic, strong) UILabel               *teamLabelA;
@property (nonatomic, strong) UILabel               *teamLabelB;

@property (nonatomic, strong) NSArray    <SNFootBallStatsModel *> *dataSource;

@end


/// 原型进度条
@interface SNLiveProgressContentView : UIView

@property (nonatomic, strong) UILabel *centerLabel;

@property (nonatomic, strong) UILabel *leftLabel;
 
@property (nonatomic, strong) UILabel *rightLabel;

- (void)leftProgress:(NSInteger)progressL rightProgress:(NSInteger)progressR;


@end


@interface SNLiveProgressView : UIView

@property(nonatomic, assign) CGFloat progress;

- (instancetype)initWithFrame:(CGRect)frame withType:(ProgressViewType)type;

@end



/// 原型进度条
@interface SNCircleProgressView :UIView

@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) SNFootBallStatsModel                   *statsModel;

@end



@interface SNShootRightMissView :UIView

/// 射正球门
@property (nonatomic, strong) UILabel               *titleLabel;
/// 黄队射正球门 的个数
@property (nonatomic, strong) UILabel               *leftLabel;

@property (nonatomic, strong) UIImageView               *leftImageView1;
@property (nonatomic, strong) UIImageView               *leftImageView2;
@property (nonatomic, strong) UIImageView               *leftImageView3;

@property (nonatomic, strong) UIImageView               *rightImageView1;
@property (nonatomic, strong) UIImageView               *rightImageView2;
@property (nonatomic, strong) UIImageView               *rightImageView3;

/// 绿队射正球门 的个数
@property (nonatomic, strong) UILabel               *rightLabel;
//黄队射正球门 百分比
@property (nonatomic, strong) UIProgressView                   *leftProgressView;
//绿队射正球门 百分比
@property (nonatomic, strong) UIProgressView                   *rightProgressView;

//射偏球门
@property (nonatomic, strong) UILabel               *missTitleLabel;
//黄队旗帜个数
@property (nonatomic, strong) UILabel               *leftLabel1;
//黄队红牌
@property (nonatomic, strong) UILabel               *leftLabel2;
//黄队黄牌
@property (nonatomic, strong) UILabel               *leftLabel3;
//黄队射偏球门 的个数
@property (nonatomic, strong) UILabel               *leftLabel4;

//绿队射偏球门 的个数
@property (nonatomic, strong) UILabel               *rightLabel1;
//绿队黄牌
@property (nonatomic, strong) UILabel               *rightLabel2;
//绿队红牌
@property (nonatomic, strong) UILabel               *rightLabel3;
//绿队旗帜个数
@property (nonatomic, strong) UILabel               *rightLabel4;
//黄队射偏球门 百分比
@property (nonatomic, strong) UIProgressView                   *missLeftProgressView;
//绿队射偏球门 百分比
@property (nonatomic, strong) UIProgressView                   *missRightProgressView;

@end
 
NS_ASSUME_NONNULL_END
