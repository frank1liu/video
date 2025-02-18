//
//  MacroCommons.h
//  ScenicNav
//
//  Created by laoK on 2019/1/21.
//  Copyright © 2019 xhkj. All rights reserved.
//

#ifndef MacroCommons_h
#define MacroCommons_h



#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)        RGBA(r, g, b, 1.0f)
#define SRGB(r)        RGBA(r, r, r, 1.0f)

#define randomRGB [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];

#define WSelf(self)         self.view.frame.size.width
#define HSelf(self)         self.view.frame.size.height

#define WeakSelf __weak typeof(self) weakSelf = self;

#define StrongSelf if (!weakSelf) return; \
__strong typeof(weakSelf) strongSelf = weakSelf


#define SCREEN_RATE   ([UIScreen mainScreen].bounds.size.width/375.0)
#define SCREEN_RATEH   ([UIScreen mainScreen].bounds.size.height/667.0)

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
 
#define IPHONE_X [CommonTools isNotchScreen]

 
#ifdef DEBUG
#define KKLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define KKLog(...)
#endif

#define SAFE_SEND_MESSAGE(obj, msg) if ((obj) && [(obj) respondsToSelector:@selector(msg)])

#define App ((AppDelegate*)[[UIApplication sharedApplication] delegate])

/**
 *导航栏高度
 */
#define NavHeight (IPHONE_X ? 88 : 64)

/**
 *顶部高度
 */
#define xTopHeight (IPHONE_X ? 20 : 0)

/**
 *tabbar高度
 */
#define KTabBarHeight (IPHONE_X ? (49 + 34) : 49)
/**
 *x下面高度
 */
#define xBottomHeight (IPHONE_X ? (34) : 0)

/**
*状态栏
*/
#define KStatusBarHeight (IPHONE_X ? 44 : 20)
 

//首页下拉的高度
#define HomeBottomHeight  250 * SCREEN_RATE


#define setObjUserDefaults(obj,key) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];[[NSUserDefaults standardUserDefaults] synchronize];

#define objUserDefaults(key) [[NSUserDefaults standardUserDefaults] objectForKey:key];

#define PostNotificationShare(key,obj) [[NSNotificationCenter defaultCenter] postNotificationName:key object:obj];

#define addObserverNotificationShare(objc,SEL,key) [[NSNotificationCenter defaultCenter] addObserver:objc selector:SEL name:key object:nil];

#define Font(fontSize)      [UIFont systemFontOfSize:fontSize]
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); }

#define rateFont(fontSize)    [UIFont systemFontOfSize:fontSize*SCREEN_RATE]
//比较
#define CFont(a, b) ((kScreenWidth > 320)? Font(a):Font(b))
//1像素的线
#define PointHeight  1/[[UIScreen mainScreen] scale]
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#define CREATE_SHARED_MANAGER(CLASS_NAME) \
+ (instancetype)sharedManager { \
static CLASS_NAME *_instance; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[CLASS_NAME alloc] init]; \
}); \
\
return _instance; \
}
 
#endif /* MacroCommons_h */
