//
//  SNLiveBasketBallTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/1/20.
//

#import "SNLiveBasketBallTableViewCell.h"

@implementation SNLiveBasketBallTableViewCell


//计算高度 label + 60  label最大宽度 width - 82
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.spotView.layer.cornerRadius = self.spotView.height/2;
    self.spotView.backgroundColor = yellow_Color;
    self.contentBackView.layer.cornerRadius = 5;
     
    self.xLineView.backgroundColor = UIColor.clearColor;
}
 
- (void)setTLiveModel:(SNBasketBallTliveModel *)tLiveModel {
    _tLiveModel = tLiveModel;
    self.contentLabel.text = tLiveModel.text;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",tLiveModel.sectionString,tLiveModel.time];
    
    NSArray *scoreArray = [tLiveModel.score componentsSeparatedByString:@"-"];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@-%@",scoreArray.firstObject,scoreArray.lastObject];
    self.spotView.backgroundColor = UIColor.grayColor;
    if (tLiveModel.t_type == 0) {
        self.iconImageView.hidden = YES;
        self.contentLabelLeft.constant = 12.5;
    }else if (tLiveModel.t_type == 1) {
        self.iconImageView.hidden = NO;
        self.contentLabelLeft.constant = 42.5;
        self.spotView.backgroundColor = yellow_Color;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.hteam_logo] placeholderImage:UIImageMake(@"默认头像") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
    }else if (tLiveModel.t_type == 2) {
        self.iconImageView.hidden = NO;
        self.contentLabelLeft.constant = 42.5;
        self.spotView.backgroundColor = Blue_Color;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.ateam_logo] placeholderImage:UIImageMake(@"默认头像") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
    }
    if (tLiveModel.isNew) {
        self.newsImageView.hidden = NO;
    }else {
        self.newsImageView.hidden = YES; 
    }
}

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.xLineView.bounds];
    if (isHorizonal) {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
 
- (void)cellIsfirstOne:(BOOL)isfirst {
    self.xLineViewTop.hidden = !isfirst;
}

- (void)cellIsLastOne:(BOOL)isLast {
    self.xLineViewBottom.hidden = !isLast;
    if (isLast) {
        self.backView.width = kScreenWidth - 25;
        [self.backView addRoundedCorners:UIRectCornerBottomLeft| UIRectCornerBottomRight withRadii:CGSizeMake(13, 13)];
    }else {
        self.backView.layer.mask = nil;
    }
}

- (void)drawRect:(CGRect)rect {
    [self drawLineOfDashByCAShapeLayer:self.xLineView lineLength:1 lineSpacing:1 lineColor:[UIColor colorWithHexString:@"#CDCDCD"] lineDirection:NO];
}


@end
