//
//  MacroOthers.h
//  ScenicNav
//
//  Created by laoK on 2019/1/15.
//  Copyright © 2019 xhkj. All rights reserved.
//

#ifndef MacroOthers_h
#define MacroOthers_h

//分页加载个数
#define pageRows 20
 
 
typedef NS_ENUM(NSInteger,PlayingStatus) {
    PlayingStatusNone,  //没有播放
    PlayingStatusLive,     //视频播放
    PlayingStatusAnimate,    //动画播放
};
 
typedef NS_ENUM(NSInteger,ProgressViewType) {
    ProgressViewTypeLeft,
    ProgressViewTypeRight
};

typedef NS_ENUM(NSInteger, SNBasketRankType) {
    SNBasketRankTypeTeam = 1,  //球队
    SNBasketRankTypePlayer,     //球员榜
    SNBasketRankTypeInjuries , //伤病榜
    SNBasketRankTypeDay,    //日榜
    SNBasketRankTypeUnknow,  //未知
};

// 画中画单例
#define SNPictureInPictureShared [SNPictureInPictureShare sharedInstance]
// 小窗单例
#define ZFPlayerWindowShared [SNZFPlayerWindow sharedInstance]

#define pictureSupport [AVPictureInPictureController isPictureInPictureSupported]

#define SNGlobalShared [SNGlobalShare sharedInstance]

//播放界面的顶部view的高
#define kContentHeight (kScreenWidth*9.0f/16.0f+StatusBarHeight)

//播放器下面的显示高度
#define kBottomHeight SNGlobalShared.contentBottomHeight

#define LoginY 150

//一个月进入的天数
#define EnterTimes 0

#endif /* MacroOthers_h */
