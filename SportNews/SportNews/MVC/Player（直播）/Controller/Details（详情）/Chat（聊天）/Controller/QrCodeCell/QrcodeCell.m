//
//  ScoreCell.m
//  Ruby English
//
//  Created by Frank Liu on 2017/11/20.
//  Copyright © 2017年 Frank Liu. All rights reserved.
//

#import "QrcodeCell.h"

@implementation QrcodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)init
{
    if(self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"QrcodeCell" owner:self options:nil] objectAtIndex:0];
        _labAddressIos = [[UILabel alloc]init];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (IBAction)tapQrCodeCellAction:(UITapGestureRecognizer *)sender {
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.labAddressIos.text]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.labAddressIos.text] options:@{} completionHandler:nil];
    }
}

@end
