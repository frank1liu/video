//
//  SNGoalNewsAlert.m
//  SportNews
//
//  Created by 根哥 on 2021/4/4.
//

#import "SNGoalNewsAlert.h"

#define btnWidth            (kScreenWidth - 30)
#define kAnimationDuration   1.8f   //单次动画时间

@interface SNGoalNewsAlert()
@property (nonatomic, strong) NSMutableArray                   *dataSource;
@property (nonatomic, strong) NSMutableArray <UIView*>         *subViewsArray;
@property (nonatomic, strong) CABasicAnimation                 *lastAnimation;
@property (nonatomic, strong) CABasicAnimation                 *firstAnimation;

@end

@implementation SNGoalNewsAlert

- (id)initWithDataSource:(NSArray *)dataSource {
    self = [self init];
    if (self) {
        _dataSource = [dataSource mutableCopy];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    WeakSelf;
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth, 200, btnWidth, 50)];
        view.backgroundColor = UIColor.redColor;
        [weakSelf addSubview:view];
        [weakSelf.subViewsArray addObject:view];
    }];
    
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    [self testGroupAnimation];
//    CFTimeInterval currentTime = CACurrentMediaTime();
//
//    CAKeyframeAnimation *anima1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH+btnWidth, 200)];
//
//    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2, 200)];
//    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2, 200+50)];
//    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH+btnWidth, 200+50)];
//    anima1.values = [NSArray arrayWithObjects:value0,value1,value2,value3, nil];
//    anima1.beginTime = currentTime;
//    anima1.duration = 5.0f;
//    anima1.fillMode = kCAFillModeForwards;
//    anima1.removedOnCompletion = NO;
//
//    [self.subViewsArray enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj.layer addAnimation:anima1 forKey:@"groupAnimation"];
//
//    }];
    
}

- (void)testGroupAnimation{
    
    __block CFTimeInterval currentTime = CACurrentMediaTime();
    WeakSelf;
    [self.subViewsArray enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray *tempArray = [weakSelf createAnimationArray:idx+1];
        for (CABasicAnimation *animation in tempArray) {
            NSString *keyAnimation = [NSString stringWithFormat:@"animation_%ld_%@",idx,animation];
            [obj.layer addAnimation:animation forKey:keyAnimation];
        }
//        currentTime += idx*1.2;
//        if (idx == 0) {
//            //位移动画
//            CGFloat centerY = kScreenHeight - 40; //y轴中心点
//            CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"position"];
//            anima1.fromValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH+btnWidth, centerY)];
//            anima1.toValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2, centerY)];
//            anima1.beginTime = currentTime;
//            anima1.duration = kAnimationDuration;
//            anima1.fillMode = kCAFillModeForwards;
//            anima1.removedOnCompletion = NO;
//
//            [obj.layer addAnimation:anima1 forKey:@"groupAnimation1"];
//
//            CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"position"];
//            anima2.fromValue = anima1.toValue;
//            anima2.toValue = anima1.fromValue;
//            anima2.beginTime = currentTime+4;
//            anima2.duration = kAnimationDuration;
//            anima2.fillMode = kCAFillModeForwards;
//            anima2.removedOnCompletion = NO;
//            [obj.layer addAnimation:anima2 forKey:@"groupAnimation2"];
//        }else{
//            //位移动画
//            CGFloat centerY = kScreenHeight - 40 - idx*60; //y轴中心点
//            CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"position"];
//            anima1.fromValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH+btnWidth, centerY)];
//            anima1.toValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2, centerY)];
//            anima1.beginTime = currentTime;
//            anima1.duration = kAnimationDuration;
//            anima1.fillMode = kCAFillModeForwards;
//            anima1.removedOnCompletion = NO;
//
//            [obj.layer addAnimation:anima1 forKey:@"groupAnimation1"];
//
//            //位移动画
//            CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"position"];
//            anima2.fromValue = anima1.toValue;
//            anima2.toValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2, centerY+60*idx)];
//            anima2.beginTime = anima1.beginTime+2+kAnimationDuration;
//            anima2.duration = kAnimationDuration;
//            anima2.fillMode = kCAFillModeForwards;
//            anima2.removedOnCompletion = NO;
//            [obj.layer addAnimation:anima2 forKey:@"groupAnimation2"];
//
//            //位移动画
//            CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"position"];
//            anima3.fromValue = anima2.toValue;
//            anima3.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH+btnWidth, centerY+60*idx)];
//            anima3.beginTime = anima2.beginTime+2 + kAnimationDuration;
//            anima3.duration = kAnimationDuration;
//            anima3.fillMode = kCAFillModeForwards;
//            anima3.removedOnCompletion = NO;
//
//            [obj.layer addAnimation:anima3 forKey:@"groupAnimation3"];
//
//        }
        
    }];
}

- (NSArray *)createAnimationArray:(NSInteger)aIndex{
    
    CFTimeInterval currentTime = CACurrentMediaTime();
    currentTime += (aIndex-1) *1.2;

    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:aIndex+1];

    for (NSInteger index = 0; index<aIndex+1; index++) {
        
        CGFloat centerY = kScreenHeight - 40; //y轴中心点

        if (aIndex >= 2) {
            centerY = kScreenHeight - 40 - 60*(aIndex - 1) + index*60;
        }
        //位移动画
        CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"position"];
        anima1.fromValue = !self.lastAnimation?[NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH+btnWidth/2, centerY)]:self.lastAnimation.toValue;
        anima1.toValue = index==aIndex?[NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH+btnWidth/2, kScreenHeight - 40)]:[NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2, centerY)];
        
        CGFloat time = index == aIndex?kAnimationDuration*0.8:kAnimationDuration;
        
        anima1.beginTime = self.lastAnimation?self.lastAnimation.beginTime+kAnimationDuration+time:currentTime;
        anima1.duration = kAnimationDuration;
        anima1.fillMode = kCAFillModeForwards;
        anima1.removedOnCompletion = NO;
        self.lastAnimation = anima1;
        if (index == 0) {
            self.firstAnimation = anima1;
        }
        [tempArray addObject:anima1];
        
    }
    self.lastAnimation = nil;
    self.firstAnimation = nil;
    return tempArray;
}

- (NSMutableArray<UIView *> *)subViewsArray{
    if (!_subViewsArray) {
        _subViewsArray = [NSMutableArray array];
    }
    return _subViewsArray;
}


@end
