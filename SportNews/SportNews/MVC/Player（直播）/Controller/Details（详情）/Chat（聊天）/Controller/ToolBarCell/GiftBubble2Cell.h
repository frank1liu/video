//
//  ScoreCell.h
//  Ruby English
//
//  Created by Frank Liu on 2017/11/20.
//  Copyright © 2017年 Frank Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCHATChatModel;

@interface GiftBubble2Cell : UITableViewCell
@property (nonatomic, strong) JCHATChatModel *message;
@property (nonatomic, weak) IBOutlet UILabel *labTitle1;
@property (nonatomic, weak) IBOutlet UILabel *labTitle2;
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *w;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *w2;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *h;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *h2;
@property (nonatomic, strong) NSString *hexColorFromName;
@property (nonatomic, strong) NSString *hexColorBody;
@property (nonatomic, strong) UIButton *btnLevel;
@property (nonatomic, assign) NSInteger level;

- (id)init;

@end
