//
//  LiveContentView.m
//  SportNews
//
//  Created by K哥 on 2021/1/9.
//

#import "LiveContentView.h"

extern NSInteger gCategoryType;

@interface LiveContentView ()

@property (nonatomic,strong) NSTimer *timer;

@property(nonatomic, assign) NSInteger countDown;

@end

@implementation LiveContentView

- (void)awakeFromNib {
    [super awakeFromNib];
     
    self.animateBackView.layer.cornerRadius = 12.5;
    
   self.liveBackView.layer.cornerRadius = 12.5;
    
    self.hTeamImageView.layer.cornerRadius = self.hTeamImageView.height/2; 
    self.aTeamImageView.layer.cornerRadius = self.aTeamImageView.height/2;
     
    self.aTeamNameLabel.text = @"";
    self.hTeamNameLabel.text = @"";
    
    self.liveLabel.textColor = Blue_Color;
    self.animateLabel.textColor = Blue_Color;
  
}
 

- (void)setModel:(LiveListModel *)model {
    
    self.scoreLabel.hidden = model.comeFromNotice;
    self.hScoreLabel.hidden = model.comeFromNotice;
    self.aScoreLabel.hidden = model.comeFromNotice;
    self.aTeamImageView.hidden = model.comeFromNotice;
    self.hTeamImageView.hidden = model.comeFromNotice;
    self.statusLabel.hidden = model.comeFromNotice;
    
    NSArray *score = [model.score componentsSeparatedByString:@"-"];
    if (model.type.intValue == 2) {
        self.hScoreLabel.text =  [NSString stringWithFormat:@"%@",score.lastObject];
        self.aScoreLabel.text =  [NSString stringWithFormat:@"%@",score.firstObject];
        self.aTeamNameLabel.text = model.hteam_name;
        self.hTeamNameLabel.text = model.ateam_name;
        [self.aTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
        [self.hTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
    }else {
        self.hScoreLabel.text =  [NSString stringWithFormat:@"%@",score.firstObject];
        self.aScoreLabel.text =  [NSString stringWithFormat:@"%@",score.lastObject];
        self.aTeamNameLabel.text = model.ateam_name;
        self.hTeamNameLabel.text = model.hteam_name;
        [self.aTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
        [self.hTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
    }
    
    self.animateBackView.hidden = YES;
    if (model.live_cartoon_url.count > 0 && model.status.integerValue == 0) { 
        self.animateBackView.hidden = NO;
    }
    
    self.liveBackView.hidden = YES;
    if (model.live_urls.count > 0) {
        BOOL isHidden = YES;
        for (LiveCartoonModel *cartModel in model.live_urls) {
            if (cartModel.status == 1) {
                isHidden = NO;
                break;
            }
        }
        self.liveBackView.hidden = isHidden;
    }
    
    if (model.video_url.length > 0) {
        self.liveBackView.hidden = NO;
    }
    self.statusLabel.text = model.status_up_name;
    
    if (model.type.integerValue == 1) {
        self.bgImageView.image = [UIImage imageNamed:@"足球bg"];
    }else {
        self.bgImageView.image = [UIImage imageNamed:@"篮球bg"];
    }
    
    if (model.status.intValue == 1) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //需要设置为和字符串相同的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *modelTime = [dateFormatter dateFromString:model.matchtime];
        NSInteger time = [modelTime timeIntervalSince1970];
        NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
        self.countDown = time - nowTime;
        if (model.status.intValue == 1) {
            if (self.countDown > 0) {
                self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
            }
        } else {
            self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
        }
    } else if (model.status.intValue == 2) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.statusLabel.text = @"完场";
    }
}


- (void)timerAction {
    self.countDown -= 1;
    if (self.countDownTime) {
        self.countDownTime(self.countDown);
    }
    NSString *time = [self countDownString:self.countDown];
    self.statusLabel.text = [NSString stringWithFormat:@"开赛倒计时\n%@",time];
}

- (NSString *)countDownString:(NSInteger)count {
    
    NSInteger day = count/(24*3600);
    NSInteger hour = count/3600%24;
    NSInteger min = (count/60)%60;
    NSInteger second = count%60;
    NSString *_dStr = @"";
    NSString *_hStr = @"";
    NSString *_mStr = @"";
    if (day > 0) {
        _dStr = [NSString stringWithFormat:@"%ld天",day];
    }else {
        _dStr = @"00天";
    }
    if (hour > 0) {
        _hStr = [NSString stringWithFormat:@"%ld时",hour];
    }else {
        _hStr = @"00时";
    }
    if (min > 0) {
        _mStr = [NSString stringWithFormat:@"%ld分",min];
    }else {
        _mStr = @"00分";
    }
    return [NSString stringWithFormat:@"%@%@%@%ld秒",_dStr, _hStr, _mStr, second];
}

- (void)setScoreStr:(NSString *)scoreStr {
    _scoreStr = scoreStr;
    if (gCategoryType == 3) {
        return;
    }
    @try {
        if ([scoreStr containsString:@"-"]) {
            NSArray *scoreArray = [scoreStr componentsSeparatedByString:@"-"];
            self.hScoreLabel.text =  [NSString stringWithFormat:@"%@",scoreArray.firstObject];
            self.aScoreLabel.text =  [NSString stringWithFormat:@"%@",scoreArray.lastObject];
        }else {
            self.hScoreLabel.text = @"0";
            self.aScoreLabel.text = @"0";
        }
    }
    @catch (NSException *exception) {
       NSLog(@"%@", exception.reason);
        self.hScoreLabel.text = @"0";
        self.aScoreLabel.text = @"0";
    }
}
/* score[2] 主队 score[3] 客队
[
0,//主队比分(常规时间)
0,//主队半场比分
0,//主队红牌
0,//主队黄牌
-1,//主队角球，-1表示没有角球数据
0,//主队加时比分(120分钟)，加时赛才有
0,//主队点球大战比分，点球大战才有
]
 */
- (void)setResultFootObj:(SNFootBallResult *)resultFootObj {
    _resultFootObj = resultFootObj;
    if (resultFootObj.score.count == 6) {
        NSNumber *status = resultFootObj.score[1];
        self.statusLabel.text = [CommonTools getFootStatus:status.intValue];
        //主队的
        NSArray *zhuArray = resultFootObj.score[2];
        if (zhuArray.count == 7) {
            NSNumber *score = zhuArray[0];
            self.hScoreLabel.text = [NSString stringWithFormat:@"%@",score];
        }
        //客队的
        NSArray *keArray = resultFootObj.score[3];
        if (keArray.count == 7) {
            NSNumber *score = keArray[0];
            self.aScoreLabel.text = [NSString stringWithFormat:@"%@",score];
        }
    }
}

- (void)setResultBasketObj:(SNBasketBallResult *)resultBasketObj {
    _resultBasketObj = resultBasketObj;
    
    self.statusLabel.text = resultBasketObj.sectionString;
    
    NSArray *hScoreArray = resultBasketObj.score[3];
    NSInteger hTotal = 0;
    for (NSNumber *num in hScoreArray) {
        hTotal = hTotal + num.integerValue;
    }
    self.aScoreLabel.text = [NSString stringWithFormat:@"%ld",hTotal];
    NSArray *gScoreArray = resultBasketObj.score[4];
    NSInteger gTotal = 0;
    for (NSNumber *num in gScoreArray) {
        gTotal = gTotal + num.integerValue;
    }
    self.hScoreLabel.text = [NSString stringWithFormat:@"%ld",gTotal];
}

- (void)setFootStatus:(NSInteger)footStatus {
    if (gCategoryType == 3) {
        return;
    }
    self.statusLabel.text = [CommonTools getFootStatus:footStatus];
}
- (void)setBasketStatus:(NSInteger)basketStatus {
    if (gCategoryType == 3) {
        return;
    }
    self.statusLabel.text = [CommonTools getBasketStatus:basketStatus];
}

- (IBAction)popAction:(id)sender {
    [self.qmui_viewController.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareAction:(id)sender {
    
}


- (IBAction)videoAction:(id)sender {
    if (self.selectBlock) {
        self.selectBlock(1);
    }
    
}

- (IBAction)animateAction:(id)sender {
    if (self.selectBlock) {
        self.selectBlock(2);
    }
}
  
- (void)dellocTime {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
