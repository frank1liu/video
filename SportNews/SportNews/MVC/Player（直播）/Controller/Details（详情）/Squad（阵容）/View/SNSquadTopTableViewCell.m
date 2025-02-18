//
//  SNSquadTopTableViewCell.m
//  SportNews
//
//  Created by K哥 on 2021/2/26.
//

#import "SNSquadTopTableViewCell.h"

@implementation SNSquadTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)cellIsTiBu:(BOOL)tibu {
    self.lineView.hidden = !tibu;
    self.lineView1.hidden = !tibu;
    self.aIconImageView.hidden = !tibu;
    self.aNameLabel.hidden = !tibu;
    if (tibu) {
        self.hNameLabel.text = self.model.hteam_name;
        [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
        self.aNameLabel.text = self.model.ateam_name;
        [self.aIconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
    }else {
        if (self.isTop) {
            self.hNameLabel.text = self.model.hteam_name;
            [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
        }else {
            self.hNameLabel.text = self.model.ateam_name;
            [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
        }
    }
}

- (void)setIsTop:(BOOL)isTop {
    _isTop = isTop;
    if (isTop) {
        self.backView.backgroundColor = UIColor.clearColor;
    }else {
        self.backView.backgroundColor = UIColor.whiteColor;
    }
}

- (void)drawRect:(CGRect)rect {
    [self.corBackView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(13, 13)];
}

@end
