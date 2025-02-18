//
//  SNSquadShangtingTableViewCell.m
//  SportNews
//
//  Created by K哥 on 2021/2/26.
//

#import "SNSquadShangtingTableViewCell.h"

@implementation SNSquadShangtingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageView.layer.cornerRadius = self.iconImageView.height/2;
    
    self.numLabel.clipsToBounds = YES;
    self.numLabel.layer.cornerRadius = 8;
    self.numLabel.layer.borderWidth = 1;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    
}

- (void)setPersonModel:(SNSquadPersonInfoModel *)personModel {
    _personModel = personModel;
    self.nameLabel.text = personModel.name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:personModel.logo] placeholderImage:UIImageMake(@"默认头像")];
    if ([CommonTools isBlankString:personModel.shirt_number]) {
        self.numLabel.text = @"-";
    }else {
        self.numLabel.text = personModel.shirt_number;
    }
    CGFloat W = [self evaluteWidth:self.numLabel] + 4;
    if (W < 16) {
        W = 16;
    }
    self.numWidth.constant = W;
    
    self.reasonLabel.text = personModel.reason;
    if ([personModel.position isEqualToString:@"F"]) {
        self.positionLabel.text = @"前锋";
    }else if ([personModel.position isEqualToString:@"M"]) {
        self.positionLabel.text = @"中场";
    }else if ([personModel.position isEqualToString:@"D"]) {
        self.positionLabel.text = @"后卫";
    }else if ([personModel.position isEqualToString:@"G"]) {
        self.positionLabel.text = @"守门员";
    }else {
        self.positionLabel.text = @"未知";
    }
}

- (void)cellIsHomeTeam:(BOOL)home {
    if (home) {
        self.numLabel.textColor = UIColor.whiteColor;
        self.numLabel.backgroundColor = [UIColor colorWithHexString:@"#313131"];
        self.numLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }else {
        self.numLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.numLabel.backgroundColor = [UIColor clearColor];
        self.numLabel.layer.borderColor = [UIColor colorWithHexString:@"#979797"].CGColor;
    }
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
