//
//  SNLiveListCollectionViewCell.m
//  SportNews
//
//  Created by kkk on 2021/3/30.
//

#import "SNLiveListCollectionViewCell.h"

@implementation SNLiveListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.countLabel.backgroundColor = Blue_Color;
    self.countLabel.layer.cornerRadius = 7;
    self.countLabel.clipsToBounds = YES;
}

- (void)setupCount {
    CGFloat width = [self evaluteWidth:self.countLabel];
    if (width < 14) {
        width = 14;
    }
    self.countWidth.constant = width;
}


- (CGFloat)evaluteWidth:(UILabel *)countLabel {
    NSDictionary *textAtt = @{NSFontAttributeName : countLabel.font};
    CGSize evaluteLabelSize = [countLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGFloat evaluteLabelSizeW = evaluteLabelSize.width + 4;
    return evaluteLabelSizeW;
}
@end
