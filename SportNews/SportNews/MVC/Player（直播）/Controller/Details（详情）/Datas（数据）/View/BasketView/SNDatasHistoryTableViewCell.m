//
//  SNDatasHistoryTableViewCell.m
//  SportNews
//
//  Created by K哥 on 2021/1/31.
//

#import "SNDatasHistoryTableViewCell.h"

@interface SNDatasHistoryTableViewCell()


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *hTeamLabel;

@property (weak, nonatomic) IBOutlet UILabel *aTeamLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabelBottom;

@property (weak, nonatomic) IBOutlet UILabel *rangScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *rangScoreLabelBottom;
@property (weak, nonatomic) IBOutlet UILabel *rangCenterLabel;

@property (weak, nonatomic) IBOutlet UILabel *zongScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *zongCenterLabel;

@property (weak, nonatomic) IBOutlet UILabel *zongScoreLabelBottom;

@end

@implementation SNDatasHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backView.layer.cornerRadius = 5;
    self.zongScoreLabel.adjustsFontSizeToFitWidth = YES;
    self.rangScoreLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setVsModel:(SNDatasBasketHistoryRecordModel *)vsModel {
    _vsModel = vsModel;
    
    self.scoreLabel.textColor = red_Color;
    if (vsModel.hIds.integerValue == self.model.hteam_id.integerValue) {
        if (vsModel.hScore.intValue < vsModel.aScore.intValue) {
            self.scoreLabel.textColor = Blue_Color;
        }
        self.scoreLabel.text = [NSString stringWithFormat:@"%@-%@",vsModel.aScore, vsModel.hScore];
        self.scoreLabelBottom.text = [NSString stringWithFormat:@"%@-%@",vsModel.aScoreBan, vsModel.hScoreBan];
    }
    
    if (vsModel.aIds.integerValue == self.model.hteam_id.integerValue) { 
        if (vsModel.aScore.intValue < vsModel.hScore.intValue) {
            self.scoreLabel.textColor = Blue_Color;
        }
        self.scoreLabel.text = [NSString stringWithFormat:@"%@-%@",vsModel.aScore, vsModel.hScore];
        self.scoreLabelBottom.text = [NSString stringWithFormat:@"%@-%@",vsModel.aScoreBan, vsModel.hScoreBan];
    }
    
    self.hTeamLabel.text = vsModel.aName;
    self.aTeamLabel.text = vsModel.hName;
    self.timeLabel.text = vsModel.time;
    self.typeLabel.text = vsModel.gameName;
    self.rangScoreLabel.text = [NSString stringWithFormat:@"%.1f",-(vsModel.scoreRang.floatValue)];
    self.rangScoreLabelBottom.text = vsModel.describeRang;
    self.zongScoreLabel.text = [NSString stringWithFormat:@"%@",vsModel.scoreZong];
    self.zongScoreLabelBottom.text = vsModel.describeZong;
    
    [self setupLabelParam];
    
}

- (void)setBasketModel:(SNDatasBasketHistoryRecordModel *)basketModel {
    _basketModel = basketModel;
    
    self.scoreLabel.textColor = red_Color;
    NSInteger teamId = self.isZhudui? self.model.hteam_id.integerValue:self.model.ateam_id.integerValue;
    if (basketModel.hIds.integerValue == teamId) {
        if (basketModel.hScore.intValue < basketModel.aScore.intValue) {
            self.scoreLabel.textColor = Blue_Color;
        }
        self.scoreLabel.text = [NSString stringWithFormat:@"%@-%@",basketModel.aScore, basketModel.hScore];
        self.scoreLabelBottom.text = [NSString stringWithFormat:@"%@-%@",basketModel.aScoreBan, basketModel.hScoreBan];
    }
    
    if (basketModel.aIds.integerValue == teamId) {
        if (basketModel.aScore.intValue < basketModel.hScore.intValue) {
            self.scoreLabel.textColor = Blue_Color;
        }
        self.scoreLabel.text = [NSString stringWithFormat:@"%@-%@",basketModel.aScore, basketModel.hScore];
        self.scoreLabelBottom.text = [NSString stringWithFormat:@"%@-%@",basketModel.aScoreBan, basketModel.hScoreBan];
    }
    self.hTeamLabel.text = basketModel.aName;
    self.aTeamLabel.text = basketModel.hName;
    self.timeLabel.text = basketModel.time;
    self.typeLabel.text = basketModel.gameName;
    self.rangScoreLabel.text = [NSString stringWithFormat:@"%.1f",-(basketModel.scoreRang.floatValue)];
    self.rangScoreLabelBottom.text = basketModel.describeRang;
    self.zongScoreLabel.text = [NSString stringWithFormat:@"%@",basketModel.scoreZong];
    self.zongScoreLabelBottom.text = basketModel.describeZong;
    
    [self setupLabelParam];
    
}

- (void)setupLabelParam {
    if ([CommonTools isBlankString:self.rangScoreLabel.text]||[CommonTools isBlankString:self.rangScoreLabelBottom.text]) {
        self.rangScoreLabel.hidden = YES;
        self.rangScoreLabelBottom.hidden = YES;
        self.rangCenterLabel.hidden = NO;
    }else {
        self.rangScoreLabel.hidden = NO;
        self.rangScoreLabelBottom.hidden = NO;
        self.rangCenterLabel.hidden = YES;
    }
    
    if ([CommonTools isBlankString:self.zongScoreLabel.text]||[CommonTools isBlankString:self.zongScoreLabelBottom.text]) {
        self.zongScoreLabel.hidden = YES;
        self.zongScoreLabelBottom.hidden = YES;
        self.zongCenterLabel.hidden = NO;
    }else {
        self.zongScoreLabel.hidden = NO;
        self.zongScoreLabelBottom.hidden = NO;
        self.zongCenterLabel.hidden = YES;
    }
    
    if ([self.rangScoreLabelBottom.text containsString:@"赢"]) {
        self.rangScoreLabel.textColor = red_Color;
        self.rangScoreLabelBottom.textColor = red_Color;
    }else {
        self.rangScoreLabel.textColor = Blue_Color;
        self.rangScoreLabelBottom.textColor = Blue_Color;
    }
    
    if ([self.zongScoreLabelBottom.text containsString:@"大"]) {
        self.zongScoreLabel.textColor = red_Color;
        self.zongScoreLabelBottom.textColor = red_Color;
    }else {
        self.zongScoreLabel.textColor = Blue_Color;
        self.zongScoreLabelBottom.textColor = Blue_Color;
    }
}

@end





