//
//  SNLiveDetailVSCollectionViewCell.m
//  SportNews
//
//  Created by kkk on 2021/3/26.
//

#import "SNLiveDetailVSCollectionViewCell.h"

@implementation SNLiveDetailVSCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(LiveListModel *)model {
    _model = model;
   
    NSArray *score = [model.score componentsSeparatedByString:@"-"];
    if (model.type.intValue == 2) {
        self.hScoreLabel.text = score.lastObject;
        self.aScoreLabel.text = score.firstObject;
        self.aTeamNameLabel.text = model.hteam_name;
        self.hTeamNameLabel.text = model.ateam_name;
        [self.aTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
        [self.hTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
    }else {
        self.hScoreLabel.text = score.firstObject;
        self.aScoreLabel.text = score.lastObject;
        self.aTeamNameLabel.text = model.ateam_name;
        self.hTeamNameLabel.text = model.hteam_name;
        [self.aTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
        [self.hTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
    }
}
 

 
@end
