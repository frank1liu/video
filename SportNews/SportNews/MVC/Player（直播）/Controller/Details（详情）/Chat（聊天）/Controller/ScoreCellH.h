//
//  ScoreCell.h
//  Ruby English
//
//  Created by Frank Liu on 2017/11/20.
//  Copyright © 2017年 Frank Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreCellH : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lab1;
@property (nonatomic, weak) IBOutlet UILabel *lab2;
@property (nonatomic, weak) IBOutlet UILabel *lab3;
@property (nonatomic, weak) IBOutlet UILabel *lab4;
@property (nonatomic, weak) IBOutlet UILabel *lab5;
@property (nonatomic, weak) IBOutlet UILabel *lab6;

- (id)init;

@end
