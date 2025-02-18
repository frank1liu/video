//
//  ScoreCell.m
//  Ruby English
//
//  Created by Frank Liu on 2017/11/20.
//  Copyright © 2017年 Frank Liu. All rights reserved.
//

#import "ScoreCellH.h"

@implementation ScoreCellH

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)init
{
    if(self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ScoreCellH" owner:self options:nil] objectAtIndex:0];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
@end
