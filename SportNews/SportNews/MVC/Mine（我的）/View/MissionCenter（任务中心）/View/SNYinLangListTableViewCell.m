//
//  SNYinLangListTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/5/13.
//

#import "SNYinLangListTableViewCell.h"

@interface SNYinLangListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end


@implementation SNYinLangListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     
    [self setCountLabelColor:YES];
    [CommonTools setupViewLayer:self.backView];
    
}

- (void)setCountLabelColor:(BOOL)isAdd {
    self.countLabel.textColor = isAdd? [UIColor colorWithHexString:@"#F85F75"]:[UIColor colorWithHexString:@"#26C3C1"];
}

@end
