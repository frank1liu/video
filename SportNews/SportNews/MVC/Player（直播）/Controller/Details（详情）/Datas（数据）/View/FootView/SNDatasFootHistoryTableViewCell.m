//
//  SNDatasFootHistoryTableViewCell.m
//  SportNews
//
//  Created by K哥 on 2021/2/1.
//

#import "SNDatasFootHistoryTableViewCell.h"

@interface SNDatasFootHistoryTableViewCell()


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *hTeamLabel;

@property (weak, nonatomic) IBOutlet UILabel *aTeamLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabelBottom;

@property (weak, nonatomic) IBOutlet UILabel *panScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *panCenterLabel;

@property (weak, nonatomic) IBOutlet UILabel *panScoreLabelBottom;

@property (weak, nonatomic) IBOutlet UILabel *qiuScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *qiuCenterLabel;

@property (weak, nonatomic) IBOutlet UILabel *qiuScoreLabelBottom;

@property (weak, nonatomic) IBOutlet UILabel *jiaoqiuLabel;

@end

@implementation SNDatasFootHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backView.layer.cornerRadius = 5;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
}


- (void)setVsModel:(SNDatasFootHistoryRecordModel *)vsModel {
    _vsModel = vsModel;
    
    self.scoreLabel.textColor = red_Color;
    if (vsModel.hIds.integerValue == self.model.hteam_id.integerValue) {
        self.hTeamLabel.text = self.model.hteam_name;
        self.aTeamLabel.text = self.model.ateam_name;
        if (vsModel.hScore.intValue > vsModel.aScore.intValue) {
            self.scoreLabel.textColor = Blue_Color;
        }else if (vsModel.hScore.intValue == vsModel.aScore.intValue) {
            self.scoreLabel.textColor = RGB(90, 139, 169);
        }
    }else {
        self.hTeamLabel.text = self.model.ateam_name;
        self.aTeamLabel.text = self.model.hteam_name;
    }
    
    self.timeLabel.text = vsModel.time;
    self.typeLabel.text = vsModel.gameName;
    self.scoreLabel.text = vsModel.scoreQuan;
    self.scoreLabelBottom.text = vsModel.scoreBan;
    self.panScoreLabel.text = [NSString stringWithFormat:@"%@",vsModel.valuePan];
    self.panScoreLabelBottom.text = vsModel.describePan;
    self.qiuScoreLabel.text = [NSString stringWithFormat:@"%@",vsModel.scoreQiu];
    self.qiuScoreLabelBottom.text = vsModel.describeQiu;
    if (vsModel.jiaoCount.integerValue == -1) {
        self.jiaoqiuLabel.text = @"-";
    }else {
        self.jiaoqiuLabel.text = [NSString stringWithFormat:@"%@",vsModel.jiaoCount];
    }
    
    [self setupLabelParam];
    
}


- (void)setFootModel:(SNDatasFootHistoryRecordModel *)footModel {
    _footModel = footModel;
    
    self.scoreLabel.textColor = red_Color;
    self.hTeamLabel.text = footModel.hName;
    self.aTeamLabel.text = footModel.aName;
    if (footModel.hScore.intValue > footModel.aScore.intValue) {
        self.scoreLabel.textColor = Blue_Color;
    }else if (footModel.hScore.intValue == footModel.aScore.intValue) {
        self.scoreLabel.textColor = RGB(90, 139, 169);
    }
    
    self.timeLabel.text = footModel.time;
    self.typeLabel.text = footModel.gameName;
    self.scoreLabel.text = footModel.scoreQuan;
    self.scoreLabelBottom.text = footModel.scoreBan;
    self.panScoreLabel.text = [NSString stringWithFormat:@"%@",footModel.valuePan];
    self.panScoreLabelBottom.text = footModel.describePan;
    self.qiuScoreLabel.text = [NSString stringWithFormat:@"%@",footModel.scoreQiu];
    self.qiuScoreLabelBottom.text = footModel.describeQiu;
    if (footModel.jiaoCount.integerValue == -1) {
        self.jiaoqiuLabel.text = @"-";
    }else {
        self.jiaoqiuLabel.text = [NSString stringWithFormat:@"%@",footModel.jiaoCount];
    }
    
    [self setupLabelParam];
}

- (void)setupLabelParam {
    if ([CommonTools isBlankString:self.panScoreLabel.text]||[CommonTools isBlankString:self.panScoreLabelBottom.text]) {
        self.panScoreLabel.hidden = YES;
        self.panScoreLabelBottom.hidden = YES;
        self.panCenterLabel.hidden = NO;
    }else {
        self.panScoreLabel.hidden = NO;
        self.panScoreLabelBottom.hidden = NO;
        self.panCenterLabel.hidden = YES;
    }
    
    if ([CommonTools isBlankString:self.qiuScoreLabel.text]||[CommonTools isBlankString:self.qiuScoreLabelBottom.text]) {
        self.qiuScoreLabel.hidden = YES;
        self.qiuCenterLabel.hidden = NO;
        self.qiuScoreLabelBottom.hidden = YES;
    }else {
        self.qiuScoreLabel.hidden = NO;
        self.qiuCenterLabel.hidden = YES;
        self.qiuScoreLabelBottom.hidden = NO;
    }
    
    if ([self.panScoreLabelBottom.text containsString:@"赢"]) {
        self.panScoreLabel.textColor = red_Color;
        self.panScoreLabelBottom.textColor = red_Color;
    }else {
        self.panScoreLabel.textColor = Blue_Color;
        self.panScoreLabelBottom.textColor = Blue_Color;
    }
    
    if ([self.qiuScoreLabelBottom.text containsString:@"大"]) {
        self.qiuScoreLabel.textColor = red_Color;
        self.qiuScoreLabelBottom.textColor = red_Color;
    }else {
        self.qiuScoreLabel.textColor = Blue_Color;
        self.qiuScoreLabelBottom.textColor = Blue_Color;
    }
}


@end
