//
//  SNPictureInPictureShare.h
//  SportNews
//
//  Created by kkk on 2021/3/12.
//

#import <Foundation/Foundation.h>
#import "LiveDetailController.h"
#import <AVKit/AVKit.h>
#import "NewPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNPictureInPictureShare : NSObject

@property(nonatomic, strong, nullable) LiveDetailController *playerVc;

@property(nonatomic, strong, nullable) NewPlayerView *systemPlayerView;

@property(nonatomic, strong, nullable) AVPictureInPictureController *picController;

/// 单例
+ (instancetype)sharedInstance;

- (void)setupPictureInPicture;

@end

NS_ASSUME_NONNULL_END
