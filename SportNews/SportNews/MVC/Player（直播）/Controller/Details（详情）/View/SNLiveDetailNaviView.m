//
//  SNLiveDetailNaviView.m
//  SportNews
//
//  Created by K哥 on 2021/2/9.
//

#import "SNLiveDetailNaviView.h"

@interface SNLiveDetailNaviView()

@property (weak, nonatomic) IBOutlet UIImageView *hIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *hScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIView *statusBackView;
@property (weak, nonatomic) IBOutlet UILabel *aScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aIconImageView;

@property (weak, nonatomic) IBOutlet QMUIButton *backBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *shareBtn;

@end

@implementation SNLiveDetailNaviView
 
- (void)hideOtherNoNeedView {
    self.hIconImageView.hidden = YES;
    self.hScoreLabel.hidden = YES;
    self.statusLabel.hidden = YES;
    self.statusBackView.hidden = YES;
    self.aScoreLabel.hidden = YES;
    self.aIconImageView.hidden = YES;
    self.centerLabel.hidden = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.statusBackView.layer.cornerRadius = 5;
    self.backView.alpha = 0;
}

- (void)setModel:(LiveListModel *)model {
          
    NSString *title = model.name;
    if ([model.name isEqualToString:@"美国大学男子篮球联赛"]) {
        title = @"NCAA";
    }
    NSString *time = model.matchtime;
    if (time.length >= 16) {
        time = [time substringWithRange:NSMakeRange(5, 11)];
    }
    if (time) {
        self.centerLabel.text = [NSString stringWithFormat:@"%@   %@",title,time];
    }else {
        self.centerLabel.text = [NSString stringWithFormat:@"%@",title];
    }
     
    NSArray *score = [model.score componentsSeparatedByString:@"-"];
    if (model.type.intValue == 2) {
        self.hScoreLabel.text =  [NSString stringWithFormat:@"%@",score.lastObject];
        self.aScoreLabel.text =  [NSString stringWithFormat:@"%@",score.firstObject];
        [self.aIconImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
        [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
    }else {
        self.hScoreLabel.text =  [NSString stringWithFormat:@"%@",score.firstObject];
        self.aScoreLabel.text =  [NSString stringWithFormat:@"%@",score.lastObject];
        [self.aIconImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
        [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
    } 
    self.statusLabel.text = model.status_up_name;
}


- (void)setScoreStr:(NSString *)scoreStr {
    _scoreStr = scoreStr;
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
    self.statusLabel.text = [CommonTools getFootStatus:footStatus];
}
- (void)setBasketStatus:(NSInteger)basketStatus {
    self.statusLabel.text = [CommonTools getBasketStatus:basketStatus];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (result == self.shareBtn || result == self.backBtn) {
        return result;
    }
    return nil;
}

- (IBAction)backAction:(id)sender {
    if (self.navBackBlock) {
        self.navBackBlock(1);
    }
}

- (IBAction)shareAction:(id)sender {
    if (self.navBackBlock) {
        self.navBackBlock(2);
    }
}


@end
