//
//  BaseXibTableViewCell.m
//  EpochStore
//
//  Created by K哥 on 2019/7/25.
//  Copyright © 2019 K哥. All rights reserved.
//

#import "BaseXibTableViewCell.h"

@implementation BaseXibTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    NSString *ID = NSStringFromClass([self class]);
    BaseXibTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
    
}

- (CGFloat)evaluteWidth:(UILabel *)label {
    NSDictionary *textAtt = @{NSFontAttributeName : label.font};
    CGSize evaluteLabelSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGFloat evaluteLabelSizeW = evaluteLabelSize.width + 1;
    return evaluteLabelSizeW;
}

@end
