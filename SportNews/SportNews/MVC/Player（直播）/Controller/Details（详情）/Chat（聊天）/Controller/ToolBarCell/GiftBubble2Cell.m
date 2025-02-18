//
//  ScoreCell.m
//  Ruby English
//
//  Created by Frank Liu on 2017/11/20.
//  Copyright © 2017年 Frank Liu. All rights reserved.
//

#import "GiftBubble2Cell.h"
#import "SNMessageCell.h"
#import "JCHATChatModel.h"
#import "ChatGiftModel.h"
#import "SWNinePatchImageFactory.h"
#import <MLLabel/NSString+MLExpression.h>
// #import "FRNinePatchImage.h"
#import "SportNews-Swift.h"

@interface GiftBubble2Cell()
@property (nonatomic, strong) MLExpression *expression;
@end

@implementation GiftBubble2Cell
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
        self = [[[NSBundle mainBundle] loadNibNamed:@"GiftBubble2Cell" owner:self options:nil] objectAtIndex:0];
        df = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMessage:(JCHATChatModel *)message{
//
    NSString *name = [NSString stringWithFormat:@"%@：",message.fromName];
    NSString *content = [NSString stringWithFormat:@"%@",message.text];

    self.expression = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"faceMap_ch" bundleName:@"Expression"];
    NSMutableAttributedString *attribute1 = [[name expressionAttributedStringWithExpression:self.expression] mutableCopy];
    [attribute1 setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:self.hexColorFromName]} range:NSMakeRange(0, name.length)];
    NSMutableAttributedString *attribute2 = [[content expressionAttributedStringWithExpression:self.expression] mutableCopy];
    [attribute2 setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:self.hexColorBody]} range:NSMakeRange(0, content.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    [attribute2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    self.labTitle1.numberOfLines = 0;
    self.labTitle1.font = [UIFont systemFontOfSize:14.0f];
    self.labTitle1.attributedText = attribute1;

    self.labTitle2.numberOfLines = 0;
    self.labTitle2.font = [UIFont systemFontOfSize:14.0f];
    self.labTitle2.attributedText = attribute2;

    self.btnLevel = [[UIButton alloc]init];

    if ([name isEqualToString:@"管理员："]) {
        self.btnLevel.frame = CGRectMake(12, 8, 36+8, 18.5);
        self.w.constant = 64;
        [self.btnLevel setTitle:@"管理员" forState:UIControlStateNormal];
        self.btnLevel.contentMode = UIViewContentModeScaleAspectFit;
        self.btnLevel.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.btnLevel setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.btnLevel setBackgroundImage:[SNMessageCell getMessageLevelImage:0] forState:UIControlStateNormal];
    } else if (self.level == 0) {
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
    //self.w2.constant = [self.labTitle2 calculateSizeForWidth:SCREEN_WIDTH].width + 65;
    // NSInteger width = [self.labTitle2 calculateSizeForWidth:SCREEN_WIDTH].width;
    self.btnLevel.frame = CGRectMake(self.btnLevel.frame.origin.x, self.labTitle1.center.y-10, self.btnLevel.frame.size.width, self.btnLevel.frame.size.height);

    self.w2.constant = [self.labTitle2 calculateSizeForWidth:SCREEN_WIDTH].width + 62;

    if (self.w2.constant > SCREEN_WIDTH - 40) {
        self.w2.constant = SCREEN_WIDTH - 40 + 16;
    } else {
        self.h.constant = 42;
        self.h2.constant = 1;
    }

    [self.contentView addSubview:self.btnLevel];
//    ///////////////////////////////////////////////////////////////
//
    if (message.bubbleAndroidUrl != nil && ![message.bubbleAndroidUrl isEqualToString:@""]) {
        NSData *_9fileData = [df objectForKey:[NSString stringWithFormat:@"%@_%@", message.bubbleAndroidUrl, @"9fileImage"]];
        if (_9fileData != nil) {
            UIImage *image = [UIImage imageWithData:_9fileData];
            // UIImage* resizableImage = [SWNinePatchImageFactory createResizableNinePatchImage:image];
            // FRNinePatchImage *resizableImage = [[FRNinePatchImage alloc]initWithImage:image size:CGSizeMake(self.imgView.frame.size.width, self.imgView.frame.size.height)];
            UIImage* resizableImage = [image ninePatchImage:2];
            self.imgView.image = resizableImage;
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self->df objectForKey:@"9file"]]];
                __block UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image != nil) {
                        // UIImage* resizableImage = [SWNinePatchImageFactory createResizableNinePatchImage:image];
                         // FRNinePatchImage *resizableImage = [[FRNinePatchImage alloc]initWithImage:image size:CGSizeMake(self.imgView.frame.size.height, self.imgView.frame.size.height)];
                        UIImage* resizableImage = [image ninePatchImage:2];
                        self.imgView.image = resizableImage;
                        [self->df setObject:data forKey:[NSString stringWithFormat:@"%@_%@", message.bubbleAndroidUrl, @"9fileImage"]];
                    }
               });
            });
        }
    } else {
        NSData *_9fileData = [df objectForKey:@"9fileImage"];
        if (_9fileData != nil) {
            UIImage *image = [UIImage imageWithData:_9fileData];
            // UIImage* resizableImage = [SWNinePatchImageFactory createResizableNinePatchImage:image];
            // FRNinePatchImage *resizableImage = [[FRNinePatchImage alloc]initWithImage:image size:CGSizeMake(self.imgView.frame.size.width, self.imgView.frame.size.height)];
            UIImage* resizableImage = [image ninePatchImage:2];
            self.imgView.image = resizableImage;
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self->df objectForKey:@"9file"]]];
                __block UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image != nil) {
                        // UIImage* resizableImage = [SWNinePatchImageFactory createResizableNinePatchImage:image];
                        // FRNinePatchImage *resizableImage = [[FRNinePatchImage alloc]initWithImage:image size:CGSizeMake(self.imgView.frame.size.height, self.imgView.frame.size.height)];
                        UIImage* resizableImage = [image ninePatchImage:2];
                        self.imgView.image = resizableImage;
                        [self->df setObject:data forKey:@"9fileImage"];
                    }
               });
            });
        }
    }
}

@end


