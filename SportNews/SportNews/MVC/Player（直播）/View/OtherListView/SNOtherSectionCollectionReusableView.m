//
//  SNOtherSectionCollectionReusableView.m
//  SportNews
//
//  Created by kkk on 2021/5/6.
//

#import "SNOtherSectionCollectionReusableView.h"

@implementation SNOtherSectionCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    CAGradientLayer* gradinentlayer=[CAGradientLayer layer];
    gradinentlayer.colors=@[(__bridge id)SRGB(248).CGColor,(__bridge id)SRGB(255).CGColor];
    gradinentlayer.locations = @[@0.5];
    gradinentlayer.startPoint = CGPointMake(0, 0);
    gradinentlayer.endPoint = CGPointMake(0, 1.0);
    gradinentlayer.frame = CGRectMake(0, 0, kScreenWidth, 50);
    [self.backView.layer addSublayer:gradinentlayer];
}

@end
