//
//  JCHATChatModel.m
//  test project
//
//  Created by guan jingFen on 14-3-10.
//  Copyright (c) 2014年 guan jingFen. All rights reserved.
//

#import "JCHATChatModel.h"
#import "JChatConstants.h"
#define headHeight 46

@implementation JCHATChatModel


- (instancetype)init {
    self = [super init];
    if (self) {
        _isTime = NO;
    }
    return self;
}
 
- (CGSize)getTextSizeWithString:(NSString *)string {
    CGSize maxSize = CGSizeMake(200, 2000);
    UIFont *font =[UIFont systemFontOfSize:18];
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    CGSize realSize = [string boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    CGSize imgSize =realSize;
    imgSize.height=realSize.height+20;
    imgSize.width=realSize.width+2*15;
    _contentSize = imgSize;
    _contentHeight = imgSize.height;
    return imgSize;
}

- (CGSize)getNotificationWithString:(NSString *)string {
    CGSize notiSize= [self stringSizeWithWidthString:string withWidthLimit:280 withFont:[UIFont systemFontOfSize:14]];
    _contentHeight = notiSize.height;
    _contentSize = notiSize;
    return notiSize;
}


- (CGSize)stringSizeWithWidthString:(NSString *)string withWidthLimit:(CGFloat)width withFont:(UIFont *)font {
    CGSize maxSize = CGSizeMake(width, 2000);
    //  UIFont *font =[UIFont systemFontOfSize:18];
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    CGSize realSize = [string boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    return realSize;
}


- (CGFloat)getCellHeight{
    CGFloat height = 30;
    return height;
}

@end
