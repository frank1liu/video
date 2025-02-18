//
//  SNSquadTibuTableViewCell.m
//  SportNews
//
//  Created by K哥 on 2021/2/26.
//

#import "SNSquadTibuTableViewCell.h"

@implementation SNSquadTibuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.hIconImageView.layer.cornerRadius = self.hIconImageView.height/2;
    self.aIconImageView.layer.cornerRadius = self.aIconImageView.height/2;
    
    self.hNumLabel.clipsToBounds = YES;
    self.hNumLabel.layer.cornerRadius = 8;
    self.hNumLabel.layer.borderWidth = 1;
    self.hNumLabel.textColor = UIColor.whiteColor;
    self.hNumLabel.backgroundColor = [UIColor colorWithHexString:@"#313131"];
    self.hNumLabel.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.aNumLabel.clipsToBounds = YES;
    self.aNumLabel.layer.cornerRadius = 8;
    self.aNumLabel.layer.borderWidth = 1;
    self.aNumLabel.backgroundColor = [UIColor clearColor];
    self.aNumLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.aNumLabel.layer.borderColor = [UIColor colorWithHexString:@"#979797"].CGColor;
    
    self.hScoreLabel.clipsToBounds = YES;
    self.hScoreLabel.layer.cornerRadius = 6;
    self.aScoreLabel.clipsToBounds = YES;
    self.aScoreLabel.layer.cornerRadius = 6;
    self.aScoreLabel.backgroundColor = RGB(240, 135, 69);
    
    self.hNameLabel.adjustsFontSizeToFitWidth = YES;
    self.aNameLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setHPersonModel:(SNSquadPersonInfoModel *)hPersonModel {
    _hPersonModel = hPersonModel;
    self.hNameLabel.text = hPersonModel.name;
    [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:hPersonModel.logo] placeholderImage:UIImageMake(@"默认头像")];
    if ([CommonTools isBlankString:hPersonModel.shirt_number]||[hPersonModel.shirt_number isEqualToString:@"0"]) {
        self.hNumLabel.text = @"-";
    }else {
        self.hNumLabel.text = hPersonModel.shirt_number; 
    }
    CGFloat hW = [self evaluteWidth:self.hNumLabel] + 4;
    if (hW < 16) {
        hW = 16;
    }
    self.hNumWidth.constant = hW;
    
    self.hScoreLabel.text = hPersonModel.rating;
    if (hPersonModel.rating.floatValue == 0) {
        self.hScoreLabel.hidden = YES;
    }else {
        self.hScoreLabel.hidden = NO;
    }
    if (hPersonModel.rating.floatValue > 8) {
        self.hScoreLabel.backgroundColor = [UIColor colorWithHexString:@"#E4644D"];
    }else if (hPersonModel.rating.floatValue > 7) {
        self.hScoreLabel.backgroundColor = [UIColor colorWithHexString:@"#F08745"];
    }else {
        self.hScoreLabel.backgroundColor = [UIColor colorWithHexString:@"#9CE560"];
    } 
}

- (void)setAPersonModel:(SNSquadPersonInfoModel *)aPersonModel {
    _aPersonModel = aPersonModel;
    self.aNameLabel.text = aPersonModel.name;
    [self.aIconImageView sd_setImageWithURL:[NSURL URLWithString:aPersonModel.logo] placeholderImage:UIImageMake(@"默认头像")];
    
    if ([CommonTools isBlankString:aPersonModel.shirt_number]||[aPersonModel.shirt_number isEqualToString:@"0"]) {
        self.aNumLabel.text = @"-";
    }else {
        self.aNumLabel.text = aPersonModel.shirt_number;
    }
    CGFloat aW = [self evaluteWidth:self.aNumLabel] + 4;
    if (aW < 16) {
        aW = 16;
    }
    self.aNumWidth.constant = aW;
    
    self.aScoreLabel.text = aPersonModel.rating;
    if (aPersonModel.rating.floatValue == 0) {
        self.aScoreLabel.hidden = YES;
    }else {
        self.aScoreLabel.hidden = NO;
    }
    if (aPersonModel.rating.floatValue > 8) {
        self.aScoreLabel.backgroundColor = [UIColor colorWithHexString:@"#E4644D"];
    }else if (aPersonModel.rating.floatValue > 7) {
        self.aScoreLabel.backgroundColor = [UIColor colorWithHexString:@"#F08745"];
    }else {
        self.aScoreLabel.backgroundColor = [UIColor colorWithHexString:@"#9CE560"];
    }
    
}

- (void)hideHomeSubView:(BOOL)isHide {
    self.hNumLabel.hidden = isHide;
    self.hIconImageView.hidden = isHide;
    self.hNameLabel.hidden = isHide;
    self.hScoreLabel.hidden = isHide;
    
}

- (void)hideAwaySubView:(BOOL)isHide {
    self.aNumLabel.hidden = isHide;
    self.aIconImageView.hidden = isHide;
    self.aNameLabel.hidden = isHide;
    self.aScoreLabel.hidden = isHide;
}

- (void)cellIsLastOne:(BOOL)last {
    if (last) {
        self.backView.backgroundColor = UIColor.clearColor;
    }else {
        self.backView.backgroundColor = UIColor.whiteColor;
    }
}

- (void)drawRect:(CGRect)rect {
    [self.corBackView addRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(13, 13)];
}

@end
