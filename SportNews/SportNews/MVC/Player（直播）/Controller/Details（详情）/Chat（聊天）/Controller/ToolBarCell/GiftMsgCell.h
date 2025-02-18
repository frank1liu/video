//
//  ScoreCell.h
//  Ruby English
//
//  Created by Frank Liu on 2017/11/20.
//  Copyright © 2017年 Frank Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCHATChatModel;

@class FLAnimatedImageView;
@interface GiftMsgCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, strong) JCHATChatModel *message;
@property (nonatomic, strong) IBOutlet UIView *gifBaseView;
@property (nonatomic, strong) IBOutlet UIImageView *gifTmpView;
@property (nonatomic, strong) IBOutlet FLAnimatedImageView *gifImgView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *w;
@property (nonatomic, strong) NSString *hexColorFromName;
@property (nonatomic, strong) NSString *hexColorBody;
@property (nonatomic, strong) UIButton *btnLevel;
@property (nonatomic, assign) NSInteger level;

- (id)init;

@end
