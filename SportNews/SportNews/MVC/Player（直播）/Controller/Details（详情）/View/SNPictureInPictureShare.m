//
//  SNPictureInPictureShare.m
//  SportNews
//
//  Created by kkk on 2021/3/12.
//

#import "SNPictureInPictureShare.h"

@interface SNPictureInPictureShare ()<AVPictureInPictureControllerDelegate>


@end

@implementation SNPictureInPictureShare

+ (instancetype)sharedInstance {
    static SNPictureInPictureShare *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SNPictureInPictureShare alloc] init];
    });
    return instance;
}


- (void)setupPictureInPicture {
    if (self.picController.isPictureInPicturePossible) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.picController startPictureInPicture];
        });
    }else {
        NSLog(@"picture is not possible");
    }
}

@end
