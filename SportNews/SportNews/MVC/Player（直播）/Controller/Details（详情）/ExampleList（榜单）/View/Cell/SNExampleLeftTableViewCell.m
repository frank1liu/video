//
//  SNExampleLeftTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/3/10.
//

#import "SNExampleLeftTableViewCell.h"

@implementation SNExampleLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.layer.cornerRadius = 1.5;
    self.lineView.hidden = YES;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.backView.backgroundColor = UIColor.clearColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.lineView.hidden = NO;
        self.titleLabel.textColor = Blue_Color;
        self.backView.backgroundColor = UIColor.whiteColor;
    }else{
        self.lineView.hidden = YES;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        self.backView.backgroundColor = UIColor.clearColor;
    }
}

@end
