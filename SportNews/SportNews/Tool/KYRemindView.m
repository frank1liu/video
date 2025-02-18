//
//  KYRemindView.m
//  SportNews
//
//  Created by K哥 on 2021/1/10.
//

#import "KYRemindView.h"

@interface KYRemindView()

@property (nonatomic, strong) UILabel *remindLabel;

@property (nonatomic, strong)UIImageView *imageView;

@property (strong, nonatomic) NSBundle *imageBundle;

@property (nonatomic, strong) NSCache *cache;


@end

@implementation KYRemindView

+ (KYRemindView*)sharedView {
    
    static dispatch_once_t once;
    static KYRemindView *sharedView;
#if !defined(SV_APP_EXTENSIONS)
    dispatch_once(&once, ^{
        UIWindow *window=[[UIApplication sharedApplication].delegate window];
        sharedView = [[self alloc] initWithFrame:window.bounds];
    });
#else
    dispatch_once(&once, ^{
        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
#endif
    return sharedView;
}

+ (void)showWithStatus:(NSString *)status {
    
    KYRemindView *remindView = [self sharedView];
    if (remindView.superview) {
        return;
    }
    UIWindow *window=[[UIApplication sharedApplication].delegate window];
    [remindView setUpWithStatus:status SubView:remindView];
    [window addSubview:remindView];
    
}

- (void)setUpWithStatus:(NSString *)status SubView:(KYRemindView *)remindView{
    //添加大背景
    self.remindLabel.hidden = NO;
    self.remindLabel.text = status;
    self.remindLabel.size = [self evaluteSize:self.remindLabel];
    self.remindLabel.centerX = remindView.centerX;
    self.remindLabel.centerY = kScreenHeight;
    [UIView animateWithDuration:0.3 animations:^{
        self.remindLabel.centerY = kScreenHeight - 100;
    }completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self.remindLabel.y = kScreenHeight;
            }completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        });
        
    }];
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        //图片控件添加到视图上面去
        [self addSubview:self.remindLabel];
    });
}

+ (void)show {
    [self showWithView:nil];
}

+ (void)showWithView:(UIView * __nullable)view {
    KYRemindView *remindView = [self sharedView];
    if (remindView.superview) {
        return;
    }
    [remindView setUpSubView:remindView];
    if (view == nil) {
        UIWindow *window=[[UIApplication sharedApplication].delegate window];
        [window addSubview:remindView];
    }else {
        [view addSubview:remindView];
    }
}

+ (void)dismiss {
    if ([self sharedView].superview) {
        [[self sharedView] removeFromSuperview];
        [[self sharedView].imageView stopAnimating];
        [self sharedView].imageView.animationImages = nil;
    }
}

- (void)setUpSubView:(KYRemindView *)refreshView{
    
    //添加大背景
    self.remindLabel.hidden = YES;
    self.imageView.hidden = NO;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.center = self.center;
    // 设置图片的序列帧 图片数组
    self.imageView.animationImages = [self initialImageArray];
    //动画重复次数
    self.imageView.animationRepeatCount = 0;
    //动画执行时间,多长时间执行完动画
    self.imageView.animationDuration = 3;     
    //开始动画
    [self.imageView startAnimating];
}

- (CGSize)evaluteSize:(UILabel *)label {
    NSDictionary *textAtt = @{NSFontAttributeName : label.font};
    CGSize evaluteLabelSize = [label.text boundingRectWithSize:CGSizeMake(kScreenWidth -30 -16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGFloat evaluteLabelSizeW = evaluteLabelSize.width + 16;
    CGFloat evaluteLabelSizeH = evaluteLabelSize.height + 20;
    CGSize size = CGSizeMake(evaluteLabelSizeW, evaluteLabelSizeH);
    return size;
}

- (NSArray *)initialImageArray {
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 89; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_000%d.png", i];
        if (i < 10) {
            imageName = [NSString stringWithFormat:@"loading_0000%d.png", i];
        }
        UIImage *image = [self loadImageWithName:imageName bundle:self.imageBundle];
        [imageArray addObject:image];
    }
    return nil;
}

- (NSBundle *)imageBundle {
    if (_imageBundle) {
        return _imageBundle;
    }
    
    NSString *imageBundlePath = [[NSBundle mainBundle] pathForResource:@"Image" ofType:@"bundle"];
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

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc]init];
        _remindLabel.font = CFont(13, 14);
        _remindLabel.numberOfLines = 0;
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.textColor = [UIColor whiteColor];
        _remindLabel.backgroundColor = SRGB(51);
        _remindLabel.layer.cornerRadius = 10;
        [_remindLabel.layer setMasksToBounds:YES];
    }
    return _remindLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        //图片控件,坐标和大小
        self.imageView =[[UIImageView alloc]init];
        self.imageView.width = 80;
        self.imageView.height = 80;
        //图片控件添加到视图上面去
        // 给图片控件添加图片对象
        [self.imageView setImage:[UIImage imageNamed:@"loading_00000"]];
        [self addSubview:self.imageView];
    }
    return nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

- (NSCache *)cache {
    if (!_cache) {
        _cache = [NSCache new];
    }
    return _cache;
}


@end
