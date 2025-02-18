//
//  SNGlobalShare.m
//  SportNews
//
//  Created by kkk on 2021/3/17.
//

#import "SNGlobalShare.h"
#import "NewPlayerView.h"

@interface SNGlobalShare ()

@property (strong, nonatomic) NSBundle *imageBundle;

@property (nonatomic, strong) NSCache *cache;

//观看视频时长
@property (nonatomic , assign) NSInteger videoTime;

@property (nonatomic,strong) NSTimer *videoTimer;

@end

@implementation SNGlobalShare


+ (instancetype)sharedInstance {
    static SNGlobalShare *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SNGlobalShare alloc] init];
    });
    return instance;
}

- (NSArray *)initialImageArray {
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 1; i < 6; i++) {
        NSString *imageName = [NSString stringWithFormat:@"火苗雪碧图1_0%d.png", i];
        UIImage *image = [self loadImageWithName:imageName bundle:self.imageBundle];
        [imageArray addObject:image];
    }
    return imageArray;
}

- (NSBundle *)imageBundle {
    if (_imageBundle) {
        return _imageBundle;
    }
    NSString *imageBundlePath = [[NSBundle mainBundle] pathForResource:@"huoImages" ofType:@"bundle"];
    _imageBundle = [NSBundle bundleWithPath:imageBundlePath];
    return _imageBundle;
}

- (UIImage *)loadImageWithName:(NSString *)name bundle:(NSBundle *)bundle {
    NSString *imageKey = [NSString stringWithFormat:@"%@-%@", name, bundle.bundleIdentifier];
    UIImage *image = [self.cache objectForKey:imageKey];
    if (!image) {
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@", bundle.bundlePath, name];
        image = [UIImage imageWithContentsOfFile:imagePath];
        if (!image) {
            NSAssert(image, @"不能为空");
        }
        [self.cache setObject:image forKey:imageKey];
    }
    return image;
}

//登录了才有观看时长
- (void)initVideoTimer {
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        if (self.videoTimer) {
            return;
        }
        self.videoTime = [[NSUserDefaults standardUserDefaults] integerForKey:SaveTodayVideoViewTime];
        self.videoTimer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(videoTimerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.videoTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void)invalideVideoTimer {
    if (self.videoTimer) {
        [self.videoTimer invalidate];
        self.videoTimer = nil;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:self.videoTime forKey:SaveTodayVideoViewTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.zfPlayer) {
        [self saveSeekTime];
    }
}

- (void)saveSeekTime {
    // 新的SDK不支援舊寫法
    NSString *current = self.zfPlayer.controlView.portraitControlView.self.currentTimeLabel.text;
    NSString *total = self.zfPlayer.controlView.portraitControlView.self.totalTimeLabel.text;
    if ([current integerValue] == [total integerValue]) {
        current = @"0";
    }
    [CommonTools saveSeekTime:current forkey:[NSString stringWithFormat:@"%@",self.zfPlayer.model.ID]];
    self.zfPlayer = nil;
}

- (void)videoTimerAction {
    self.videoTime += 60;
    [self uploadTime];
}

- (void)uploadTime {
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        NSInteger min = self.videoTime/60;
        if (min > 5) {
            NSDictionary *dic = @{
                @"token":loginModel.token,
                @"uid":loginModel.uid,
                @"time":@(min)
            };
            [KYApiHttpTool GETNoHud:URL_WatchTime withParams:dic success:^(NSDictionary * _Nonnull response) {
                
            } failure:^(NSError * _Nullable error) {
                
            }];
            self.videoTime = 0;
        }
    }
}
 

@end
