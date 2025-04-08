//
//  AppDelegate.h
//  SportNews
//
//  Created by kkk on 2020/12/2.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) LiveListModel *listModel;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL allowOrentitaionRotation;

@property (nonatomic, strong) NSString *availableDomain;

//先检查云信是否登录
- (void)checkYXIsLogined;

- (void)getJPushAccount:(NSString *)registrationID;

- (void)getChannelName;

//点击通知跳转对应详情
- (void)jumpToDetailVc:(LiveListModel *)model;

- (void)setChannelName;

- (void)setupNIM;

@end

