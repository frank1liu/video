//
//  LiveListTheEndTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/3/31.
//

#import "LiveListTheEndTableViewCell.h"

@implementation LiveListTheEndTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 13;
    self.backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0,2);
    self.backView.layer.shadowOpacity = 1;
      
    self.backgroundColor = SRGB(250);
     
}

- (void)setModel:(LiveListModel *)model {
    _model = model;
    NSString *title = model.name;
    if ([model.name isEqualToString:@"美国大学男子篮球联赛"]) {
        title = @"NCAA";
    }
    if (model.matchtime.length >= 16) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@",[model.matchtime substringWithRange:NSMakeRange(11, 5)]];
    }
    self.typeNameLabel.text = title;
    NSArray *score = [model.score componentsSeparatedByString:@"-"];
    if (model.type.intValue == 2) {
        self.hScoreLabel.text = score.lastObject;
        self.aScoreLabel.text = score.firstObject;
        if ([score.lastObject intValue] > [score.firstObject intValue]) {
            self.hSanImageView.hidden = NO;
            self.aSanImageView.hidden = YES;
            self.hScoreLabel.textColor = [UIColor colorWithHexString:@"#555555"];
            self.aScoreLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        }else if ([score.lastObject intValue] < [score.firstObject intValue]) {
            self.hSanImageView.hidden = YES;
            self.aSanImageView.hidden = NO;
            self.aScoreLabel.textColor = [UIColor colorWithHexString:@"#555555"];
            self.hScoreLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        }else {
            self.hSanImageView.hidden = YES;
            self.aSanImageView.hidden = YES;
            self.aScoreLabel.textColor = [UIColor colorWithHexString:@"#555555"];
            self.hScoreLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        }
        self.aNameLabel.text = model.hteam_name;
        self.hNameLabel.text = model.ateam_name;
        if ([model.ateam_logo isEqualToString:@""] && [model.hteam_logo isEqualToString:@""]) {
            [self.aIconImageView sd_setImageWithURL:[NSURL URLWithString:model.clogo] placeholderImage:UIImageMake(@"clogoDef")];
            [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:model.clogo] placeholderImage:UIImageMake(@"clogoDef")];
        } else {
            [self.aIconImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
            [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
        }
    }else {
        self.hScoreLabel.text = score.firstObject;
        self.aScoreLabel.text = score.lastObject;
        if ([score.firstObject intValue] > [score.lastObject intValue]) {
            self.hSanImageView.hidden = NO;
            self.aSanImageView.hidden = YES;
            self.hScoreLabel.textColor = [UIColor colorWithHexString:@"#555555"];
            self.aScoreLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        }else if ([score.firstObject intValue] < [score.lastObject intValue]) {
            self.hSanImageView.hidden = YES;
            self.aSanImageView.hidden = NO;
            self.aScoreLabel.textColor = [UIColor colorWithHexString:@"#555555"];
            self.hScoreLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        }else {
            self.hSanImageView.hidden = YES;
            self.aSanImageView.hidden = YES;
            self.aScoreLabel.textColor = [UIColor colorWithHexString:@"#555555"];
            self.hScoreLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        }
        self.hNameLabel.text = model.hteam_name;
        self.aNameLabel.text = model.ateam_name;
        if ([model.ateam_logo isEqualToString:@""] && [model.hteam_logo isEqualToString:@""]) {
            [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:model.clogo] placeholderImage:UIImageMake(@"clogoDef")];
            [self.aIconImageView sd_setImageWithURL:[NSURL URLWithString:model.clogo] placeholderImage:UIImageMake(@"clogoDef")];
        } else {
            [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
            [self.aIconImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
        }
    }
    
    if (model.video_url.length > 0) {
        self.huifangBtn.enabled = YES;
        [self.huifangBtn setTitle:@" 回放" forState:UIControlStateNormal];
    }else {
        self.huifangBtn.enabled = NO;
        [self.huifangBtn setTitle:@" 暂无" forState:UIControlStateNormal];
    }

     
} 



@end
