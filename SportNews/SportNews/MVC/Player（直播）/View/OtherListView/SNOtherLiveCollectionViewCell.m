//
//  SNOtherLiveCollectionViewCell.m
//  SportNews
//
//  Created by kkk on 2021/5/6.
//

#import "SNOtherLiveCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>

@implementation SNOtherLiveCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.typeLabel.layer.cornerRadius = 5;
    self.typeLabel.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = 10;
    self.liveBackView.layer.cornerRadius = 3;
     
}

- (void)setModel:(SNOtherLiveModel *)model {
    _model = model;
    
    for (id Model in self.categoryListModelArray) {
        if ([Model isKindOfClass:[LiveListCategoryModel class]]) {
            LiveListCategoryModel *categoryModel = (LiveListCategoryModel *)Model;
            if (categoryModel.type.integerValue == model.sports_type) {
                self.typeLabel.text = [NSString stringWithFormat:@" %@ ",categoryModel.name];
            }
        }
    }
    [self layoutIfNeeded];
    CGFloat w = self.typeLabel.width;
    NSInteger count = (w / 3)-1;
    NSString *string = @"";
    if (self.isAll) {
        self.typeLabel.hidden = NO;
        for (int i = 0; i < count; i++) {
            string = [string stringByAppendingString:@" "];
        }
    } 
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@【%@】", string, model.cname] attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:model.title attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}]];
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.titleLabel.attributedText = attr;
    
    if (model.islive) {
        self.liveBackView.hidden = NO;
        NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"living" ofType:@"gif"]];
        self.gifImageView.image = [UIImage sd_imageWithGIFData:localData];
    }else {
        self.liveBackView.hidden = YES;
    }
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.coverurl] placeholderImage:UIImageMake(@"默认大图")]; 
}

@end
