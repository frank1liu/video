//
//  ScoreCell.h
//  Ruby English
//
//  Created by Frank Liu on 2017/11/20.
//  Copyright © 2017年 Frank Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QrcodeCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labContent;
@property (nonatomic, weak) IBOutlet UIImageView *qrImageView;
@property (nonatomic, strong) UILabel *labAddressIos;

- (id)init;

@end
