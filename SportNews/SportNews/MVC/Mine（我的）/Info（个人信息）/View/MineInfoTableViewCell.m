//
//  MineInfoTableViewCell.m
//  SportNews
//
//  Created by kkk on 2020/12/5.
//

#import "MineInfoTableViewCell.h"

@implementation MineInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     
    self.iconImageView.layer.cornerRadius = self.iconImageView.height/2;
    
}

 

@end
