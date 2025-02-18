//
//  SettingTableViewCell.m
//  SportNews
//
//  Created by kkk on 2020/12/5.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.backgroundColor = SRGB(235);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
