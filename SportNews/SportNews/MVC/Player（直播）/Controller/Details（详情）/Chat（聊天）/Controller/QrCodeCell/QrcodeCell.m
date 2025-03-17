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
    NSLog(@"[Adam] before url:%@", self.labAddressIos.text);
    NSString *url = [self.labAddressIos.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"[Adam] after url:%@", url);
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
}

@end
