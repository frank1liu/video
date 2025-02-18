//
//  ScoreCell.m
//  Ruby English
//
//  Created by Frank Liu on 2017/11/20.
//  Copyright © 2017年 Frank Liu. All rights reserved.
//

#import "GiftMsgCell.h"
#import "SNMessageCell.h"
#import "FLAnimatedImage.h"
#import "JCHATChatModel.h"
#import "ChatGiftModel.h"
#import <MLLabel/NSString+MLExpression.h>

@interface GiftMsgCell()
@property (nonatomic, strong) MLExpression *expression;
@end

@implementation GiftMsgCell
{
    NSUserDefaults *df;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)init
{
    if(self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"GiftMsgCell" owner:self options:nil] objectAtIndex:0];
        df = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMessage:(JCHATChatModel *)message{
    NSArray *seg = [message.text componentsSeparatedByString:@" "];
    self.labTitle.text = seg[0];

    NSString *name = [NSString stringWithFormat:@"%@：",message.fromName];
    NSString *content = [NSString stringWithFormat:@"%@%@",name ,seg[0]];

    self.expression = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"faceMap_ch" bundleName:@"Expression"];
    NSMutableAttributedString *attribute = [[content expressionAttributedStringWithExpression:self.expression] mutableCopy];
    [attribute setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:self.hexColorFromName]} range:NSMakeRange(0, name.length)];
    @try {
        [attribute setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:self.hexColorBody]} range:NSMakeRange(name.length, content.length-name.length)];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }

    self.labTitle.numberOfLines = 0;
    self.labTitle.font = [UIFont systemFontOfSize:14.0f];
    self.labTitle.attributedText = attribute;

    self.btnLevel = [[UIButton alloc]init];

    if ([name isEqualToString:@"管理员："]) {
        self.btnLevel.frame = CGRectMake(12, 8, 36+8, 18.5);
        self.w.constant = 64;
        [self.btnLevel setTitle:@"管理员" forState:UIControlStateNormal];
        self.btnLevel.contentMode = UIViewContentModeScaleAspectFit;
        self.btnLevel.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.btnLevel setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.btnLevel setBackgroundImage:[SNMessageCell getMessageLevelImage:0] forState:UIControlStateNormal];
    }
    else if (self.level == 0) {
        self.btnLevel.frame = CGRectMake(12, 8, 36, 18.5);
        [self.btnLevel setTitle:@"游客" forState:UIControlStateNormal];
        self.btnLevel.contentMode = UIViewContentModeScaleAspectFit;
        // self.btnLevel.titleLabel.text = @"游客";
        self.btnLevel.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.btnLevel setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.btnLevel setBackgroundImage:[SNMessageCell getMessageLevelImage:self.level] forState:UIControlStateNormal];
    } else {
        self.w.constant = 80;
        self.btnLevel.frame = CGRectMake(12, 8, 60, 21.5);
        // [self.btnLevel setTitle:@"" forState:UIControlStateNormal];
        [self.btnLevel setBackgroundImage:[SNMessageCell getMessageLevelImage:self.level] forState:UIControlStateNormal];
    }
    self.btnLevel.frame = CGRectMake(self.btnLevel.frame.origin.x, self.labTitle.center.y-10, self.btnLevel.frame.size.width, self.btnLevel.frame.size.height);
    [self.contentView addSubview:self.btnLevel];
    ///////////////////////////////////////////////////////////////

    UIImage *gifImg = [df objectForKey:seg[1]];
    if (gifImg != nil) {
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:seg[1]];
        FLAnimatedImage* image = [FLAnimatedImage animatedImageWithGIFData:data];
        self.gifImgView.animatedImage = image;
    } else {
        NSDictionary *dic = [df dictionaryForKey:@"urlImageDic"];
        [self.gifTmpView setHidden:YES];
        if (dic[seg[2]] != nil) {
            [self.gifTmpView setHidden:NO];
            self.gifImgView.backgroundColor = UIColor.clearColor;
            self.gifTmpView.image = [UIImage imageWithData:dic[seg[2]]];
        }
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:seg[1]]];
             FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.gifTmpView setHidden:YES];
                 self.gifImgView.animatedImage = image;
                 [self->df setObject:data forKey:seg[1]];
            });
         });
    }
}

- (NSArray *)unarchiveGiftData {
    NSData *giftsData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Gift"];
    NSArray *gifts = [NSKeyedUnarchiver unarchiveObjectWithData:giftsData];
    return gifts;
}

@end
