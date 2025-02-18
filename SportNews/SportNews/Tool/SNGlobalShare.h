//
//  SNGlobalShare.h
//  SportNews
//
//  Created by kkk on 2021/3/17.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class NewPlayerView;

@interface SNGlobalShare : NSObject

/// 单例
+ (instancetype)sharedInstance;
  
/// 小窗播放器
@property (nonatomic, weak, nullable) NewPlayerView *zfPlayer;

@property (nonatomic , assign) BOOL isAppOpened;

@property(nonatomic, copy) NSString *baseUrl;

@property(nonatomic, copy) NSString *socketUrl;

@property (nonatomic , assign) NSInteger contentBottomHeight;


- (NSArray *)initialImageArray;

- (void)initVideoTimer;

- (void)invalideVideoTimer;
 

@end

NS_ASSUME_NONNULL_END
