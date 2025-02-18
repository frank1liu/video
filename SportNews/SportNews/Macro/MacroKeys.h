//
//  MacroKeys.h
//  ScenicNav
//
//  Created by laoK on 2019/1/14.
//  Copyright © 2019 xhkj. All rights reserved.
//

#ifndef MacroKeys_h
#define MacroKeys_h


//是否关闭小窗口播放
#define CloseSmallWindow @"CloseSmallWindow"
 
//友盟
// #define K_UMENG_APPKEY @"5ffa199af1eb4f3f9b57a14e"
#define K_UMENG_APPKEY @"603b48166ee47d382b69196d"

//极光
#define JPushUserName   @"JPushUserName"
#define JPushNickName   @"JPushNickName"
#define JPushPassword   @"JPushPassword"
#define JPushRegistrationID   @"JPushRegistrationID"

#define JPushAppKey [CommonTools getJPushAppKey]
#define JPushChannel @"www.baidu.com"


#define K_TouristsNickName   @"TouristsNickNameKey"

//网易
// #define K_WANGYI_APPKEY @"c5333ccb8841d4c935bd9943b9724e86"
// #define K_WANGYI_APPKEY    @"8d7906038c54717bc094f70943ba8878"
#define K_WANGYI_APPKEY    @"c653ab72468ed55c68a1a64ddd9bf57a"
#define K_WANGYI_SECRET    @"b5b9c0d9784b"
#define K_WANGYI_ACCID     @"KWANGYIACCID" //账号
#define K_WANGYI_TOKEN     @"KWANGYITOKEN" //token

// 阿里雲崩潰報告
#define ALI_CRASH_APPKEY    @"335370115"
#define ALI_CRASH_SECRET    @"967ab84a48f645c8b1d23ee6799ea0cf"
#define ALI_CRASH_CHANNEL   @"QuickWatchApp"
#define ALI_CRASH_NICK      @"QuickWatch"


/***********所有的key 包括通知、偏好设置等*************/
//我的头像存储地址
#define headImageFilePath @"headImageFilePath.png"

//头像修改成功
#define changeHeaderImageSuccessPath @"changeHeaderImageSuccess"
//昵称修改成功
#define changeNickNameSuccessPath @"changeNickNameSuccess"

//倒计时
#define KCountDownNotification @"KCountDownNotification"

//是否关闭小窗口播放
#define CloseSmallWindow @"CloseSmallWindow"

//首页ws接收到了完成的比赛数据
#define RecieveFinishListData @"RecieveFinishListData"

//api 域名
#define Local_BaseUrl @"Local_BaseUrl"
//socket 域名
#define Local_SocketUrl @"Local_SocketUrl"

/// 通知，LiveListViewController收到该通知，就需要切换当前列表是以比分表现还是以指数表现。
#define ChangeShowType @"ChangeShowType"

#define ListRefreshBtnAction @"ListRefreshBtnAction"

#define ListRefreshComplete @"ListRefreshComplete"
  

//保存上次进入App的时间
#define SaveLastEnterAppTime @"SaveLastEnterAppTime"

//保存今日观看视频的时长
#define SaveTodayVideoViewTime @"SaveTodayVideoViewTime"

//保存比赛观看的时长
#define SaveVideoSeekTime @"SaveVideoSeekTime"

#endif /* MacroKeys_h */
 
