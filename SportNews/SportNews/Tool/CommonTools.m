//
//  CommonTools.m
//  ScenicNav
//
//  Created by laoK on 2019/1/10.
//  Copyright © 2019 xhkj. All rights reserved.
//

#import "CommonTools.h"
#import "AFNetworking.h" 
#import <UserNotifications/UserNotifications.h>
#include <sys/sysctl.h>

@implementation CommonTools

+ (NSString *)getScoreResult:(NSString *)score isHome:(BOOL)isHome {
    NSArray *scores = [score componentsSeparatedByString:@"-"];
    NSString *result;
    double first = [scores.firstObject doubleValue];
    double last = [scores.lastObject doubleValue];
    if (isHome) {
        if (first == last) {
            result = @"平";
        } else if (first < last) {
            result = @"输";
        } else {
            result = @"赢";
        }
    } else {
        if (first == last) {
            result = @"平";
        } else if (first < last) {
            result = @"赢";
        } else {
            result = @"输";
        }
    }
    return result;
}


+ (NSString *)getBasketScoreResult:(NSString *)score isHome:(BOOL)isHome {
    NSArray *scores = [score componentsSeparatedByString:@"-"];
    NSString *result;
    double first = [scores.lastObject doubleValue];
    double last = [scores.firstObject doubleValue];
    if (isHome) {
        if (first == last) {
            result = @"平";
        } else if (first < last) {
            result = @"输";
        } else {
            result = @"赢";
        }
    } else {
        if (first == last) {
            result = @"平";
        } else if (first < last) {
            result = @"赢";
        } else {
            result = @"输";
        }
    }
    return result;
}

+ (NSString *)getFootStatus:(NSInteger)status {

    switch (status) {
        case 0: {
            return @"比赛异常";
        }
            break;
        case 1: {
            return @"未开赛";
        }
            break;
        case 2: {
            return @"上半场";
        }
            break;
        case 3: {
            return @"中场";
        }
            break;
        case 4: {
            return @"下半场";
        }
        case 5: { //加时赛(弃用)
            return @"加时赛";
        }
            break;
        case 6: {//加时赛(弃用)
            return @"加时赛";
        }
            break;
        case 7: {
            return @"点球决战";
        }
            break;
        case 8: {
            return @"完场";
        }
        case 9: {
            return @"推迟";
        }
            break;
        case 10: {
            return @"中断";
        }
            break;
        case 11: {
            return @"腰斩";
        }
            break;
        case 12: {
            return @"取消";
        }
            break;
        default:
            return @"待定";
            break;
    }
}

+ (NSString *)getBasketStatus:(NSInteger)status {
    
    switch (status) {
        case 1:
            return @"未开赛";
        break;
        case 2:
            return @"第一节";
        break;
        case 3:
            return @"第一节完";
        break;
            
        case 4:
            return @"第二节";
        break;
            
        case 5:
            return @"第二节完";
        break;
        case 6:
            return @"第三节";
        break;
        case 7:
            return @"第三节完";
        break;
        case 8:
            return @"第四节";
        break;
        case 9:
            return @"加时";
        break;
        case 10:
            return @"完场";
        break;
        case 11:
            return @"中断";
        break;
        case 12:
            return @"取消";
        break;
        case 13:
            return @"延期";
        break;
        case 14:
            return @"腰斩";
        break;
        case 15:
            return @"待定";
        break;
        default:
            return @"未开赛";
            break;
    }
}


+ (UIColor *)getScoreColor:(NSString *)score isHome:(BOOL)isHome {
    NSArray *scores = [score componentsSeparatedByString:@"-"];
    UIColor *result;
    double first = [scores.lastObject doubleValue];
    double last = [scores.firstObject doubleValue];
    if (isHome) {
        if (first < last) {
            result = Blue_Color;
        } else {
            result = red_Color;
        }
    } else {
        if (first < last) {
            result = red_Color;
        } else {
            result = Blue_Color;
        }
    }
    return result;
}
  
+ (NSString *)getRandomStringWithNum:(NSInteger)num {
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

#pragma mark === 永久闪烁的动画 ======
+ (CABasicAnimation *)opacityForever_Animation:(float)time {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
     animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

+ (CABasicAnimation *)rotationAnimation_Animation {
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.repeatCount = HUGE_VALF;
    return rotationAnimation;
}
/**
 *  判断是否连接网络
 */
+ (void)AFNReachability {
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2.监听网络状态的改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                //手机未连接网络
                PostNotificationShare(@"ChangeReachStatus", @"0");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //4G流量
                PostNotificationShare(@"ChangeReachStatus", @"1");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //至Wifi
                PostNotificationShare(@"ChangeReachStatus", @"1");
                break;
            default:
                //手机未连接网络
                PostNotificationShare(@"ChangeReachStatus", @"0");
                break;
        }
    }];
    
    
    //3.开始监听
    [manager startMonitoring];
}

+ (BOOL)isNotchScreen {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return NO;
    }
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger notchValue = size.width / size.height * 100;
    if (216 == notchValue || 46 == notchValue) {
        return YES;
    }

    if ([CommonTools notchHeight] != 0.0) {
        return YES;
    }

    return NO;
}

+ (CGFloat)notchHeight {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        UIEdgeInsets safeAreaInsets = window.safeAreaInsets;
        return safeAreaInsets.top;
    } else {
        return 0.0;
    }
}

+ (NSString *)detectiPhone16Series {
    NSString *model = [self getDeviceModel];
    NSLog(@"Device Model: %@", model);

    if ([model isEqualToString:@"iPhone16,1"] || [model isEqualToString:@"iPhone16,2"]) {
        return @"iPhone 16";
    } else if ([model isEqualToString:@"iPhone16,3"] || [model isEqualToString:@"iPhone16,4"]) {
        return @"iPhone 16 Pro";
    } else {
        return @"其他機型";
    }
}

+ (NSString *)getDeviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithUTF8String:model];
    free(model);
    return deviceModel;
}

//改变detail上的字体颜色
+ (NSMutableAttributedString *)attributeStringWith:(NSString *)mainTitle withsubTitle:(NSString*)subTitle {
    
    NSString *str = [NSString stringWithFormat:@"%@%@",mainTitle,subTitle];
    NSMutableAttributedString *ats = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange mainRang = [str rangeOfString:mainTitle];
    [ats setAttributes:@{NSFontAttributeName : Font(15)} range:mainRang];
    
    NSRange subRang = [str rangeOfString:subTitle];
    [ats setAttributes:@{NSFontAttributeName : Font(13)} range:subRang];
    
    return ats;
}

+ (BOOL)isBlankString:(NSString *)aStr {
    @try {
        if (!aStr) {
            return YES;
        }
        if ([aStr isKindOfClass:[NSNull class]]) {
            return YES;
        }
        if (!aStr.length) {
            return YES;
        }
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
        if (!trimmedStr.length) {
            return YES;
        }
    }
    @catch (NSException *exception) {
       NSLog(@"%@", exception.reason);
        return YES;
    }
    return NO;
}


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)currentViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}


+ (NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        KKLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (![jsonString isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (jsonString == nil) {
        return nil;
    }
    if ([CommonTools isBlankString:jsonString]) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        KKLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//1. 获取缓存文件的大小
+ (float)readCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [ self folderSizeAtPath:cachePath];
}


//由于缓存文件存在沙箱中，我们可以通过NSFileManager API来实现对缓存文件大小的计算。
// 遍历文件夹获得文件夹大小，返回多少 M
+ (float) folderSizeAtPath:(NSString *)folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/( 1024.0 * 1024.0);
    
}

// 计算 单个文件的大小
+ (long long) fileSizeAtPath:(NSString *)filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath: filePath]){
        return [[manager attributesOfItemAtPath:filePath error: nil] fileSize];
    }
    return 0;
}

//2. 清除缓存
+ (void)clearFile {
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    NSArray * files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    for (NSString * p in files) {
        NSError* error = nil ;
        //获取文件全路径
        NSString* fileAbsolutePath = [cachePath stringByAppendingPathComponent:p];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileAbsolutePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:fileAbsolutePath error:&error];
        }
    }
}

+ (NSString *)removeFloatAllZero:(NSString *)numberStr {
   
    NSString * formatterString = numberStr;
    //获取要截取的字符串位置
    NSRange range = [formatterString rangeOfString:@"."];
    if (range.length > 0 ) {
        //去零和. 查看最后一个是否是零或者是.  是就删除 如果最后一个不是0和.那么就退出循环
        NSInteger count = formatterString.length -range.location;
        for (int i = 0; i < count; i++) {
            NSString *result1 = [formatterString substringFromIndex:formatterString.length -1];
            if ([result1 isEqualToString:@"0"] || [result1 isEqualToString:@"."]) {
                formatterString = [formatterString substringToIndex:(formatterString.length - 1)];
            }else{
                break;
            }
        }
    }
    return  formatterString;
}


//跳转到设置
+ (void)jumpToSetting {
    if (UIApplicationOpenSettingsURLString != NULL) {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:URL options:@{} completionHandler:nil];
        }
    }
}
//检查通知是否打开
+ (void)checkNotificationStatus:(void(^)(BOOL isOpen))handler {
    //查看推送是否打开
    UNUserNotificationCenter *center = UNUserNotificationCenter.currentNotificationCenter;
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            handler(YES);
        }else{
            handler(NO);
        }
    }];
}

/// 获取当前window
+ (UIWindow*)getCurrentWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
            return [UIApplication sharedApplication].delegate.window;
        }
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)) {
            return window;
        }
    }
    
    return [UIApplication sharedApplication].delegate.window;
}

/** 直接传入精度丢失有问题的Double类型*/
+ (NSString *)decimalNumberWithDouble:(double)conversionValue {
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}



+ (NSMutableAttributedString *)setupAttributeString:(NSString *)contentStr {
   NSArray *rangeArray = @[
   @[@"场",@"胜"],
   @[@"交锋",@"胜"],
   @[@"交锋",@"单"],
   @[@"胜",@"平"],
   @[@"平",@"负"],
   @[@"胜",@"负"],
   @[@"单",@"双"],
   @[@"负",@"单"],
   @[@"胜率",@"赢率"],
   @[@"赢率",@"大率"],
   @[@"大率"]];
   NSArray *colorArray = @[
       red_Color,
       red_Color,
       red_Color,
       [UIColor colorWithHexString:@"#5C93BA"],
       [UIColor colorWithHexString:@"#73D9D8"],
       [UIColor colorWithHexString:@"#73D9D8"],
       [UIColor colorWithHexString:@"#73D9D8"],
       red_Color,
       red_Color,
       red_Color,
       red_Color];
   NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
   for (int i = 0; i < rangeArray.count; i++) {
       NSArray *titleArray = rangeArray[i];
        
       UIColor *color = colorArray[i];
       if (titleArray.count == 2) {
           NSRange startRange = [contentStr rangeOfString:titleArray.firstObject];
           NSRange endRange = [contentStr rangeOfString:titleArray.lastObject];
           if (startRange.location != NSNotFound && endRange.location != NSNotFound) {
               NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
               NSString *subStr = [contentStr substringWithRange:range];
               //这是给数组赋颜色 中间不能包括中文
               if (subStr && ![self isHasChineseWithStr:subStr]) {
                   NSDictionary * attribute = @{NSForegroundColorAttributeName:color};
                   if (range.location != NSNotFound) {
                       [attributeStr addAttributes:attribute range:range];
                   }
               }
           }
       }else if (titleArray.count == 1) {
           NSRange startRange = [contentStr rangeOfString:titleArray.firstObject];
           if (startRange.location != NSNotFound ) {
               NSRange range = NSMakeRange(startRange.location + startRange.length, contentStr.length - startRange.location - startRange.length);
               NSDictionary * attribute = @{NSForegroundColorAttributeName:color};
               if (range.location != NSNotFound) {
                   [attributeStr addAttributes:attribute range:range];
               }
           }
       }
   }
   return attributeStr;
}

+ (BOOL)isHasChineseWithStr:(NSString *)strFrom {
   for (int i=0; i<strFrom.length; i++) {
       NSRange range =NSMakeRange(i, 1);
       NSString * strFromSubStr=[strFrom substringWithRange:range];
       const char *cStringFromstr = [strFromSubStr UTF8String];
       if (strlen(cStringFromstr)==3) {
           //汉字
           return YES;
       } else if (strlen(cStringFromstr)==1) {
           //字母
       }
   }
   return NO;
}

+ (void)setupViewLayer:(UIView *)view {
    view.layer.cornerRadius = 13;
    view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
    view.layer.shadowOffset = CGSizeMake(2,3);
    view.layer.shadowOpacity = 0.5;
}

//根据包名获取AppKey
+ (NSString *)getJPushAppKey {
    NSString *currentBundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if ([currentBundleId isEqualToString:@"com.Yuwanfif.app"]) {
        return @"6d5a63f5a4548206772a1470";
    }else if ([currentBundleId isEqualToString:@"com.zl.unicode"]) {
        return @"d4596a102590f5b09859ca22";
    }
    return @"6d5a63f5a4548206772a1470";
}


//获取昵称
+ (NSString *)getNickName {
    NSString *nickName = [[NSUserDefaults standardUserDefaults] valueForKey:JPushNickName];
    if (!nickName) {
        //在这里还没获取到 游客昵称的话就随机弄个
        nickName = [NSString stringWithFormat:@"极直播游客%@",[CommonTools getRandomStringWithNum:4]];
        [[NSUserDefaults standardUserDefaults] setValue:nickName forKey:JPushNickName];
    }
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        nickName = loginModel.userinfo.nickname;
    }
    return nickName;
}

//保存观看记录
+ (void)saveSeekTime:(NSString *)time forkey:(NSString *)key {
    NSDictionary *recordDic = [[NSUserDefaults standardUserDefaults] objectForKey:SaveVideoSeekTime];
    if (recordDic) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:recordDic];
        if ([time integerValue] == 0) {
            if ([[dic allKeys] containsObject:key]) {
                [dic removeObjectForKey:key];
                recordDic = dic;
            }
        }else {
            [dic setValue:time forKey:key];
            recordDic = dic;
        }
    }else {
        if ([time integerValue] != 0) {
            return;
        }
        recordDic = [NSDictionary dictionaryWithObject:time forKey:key];
    }
    [[NSUserDefaults standardUserDefaults] setObject:recordDic forKey:SaveVideoSeekTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
