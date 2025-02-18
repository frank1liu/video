//
//  SNLiveFootBallTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/1/20.
//

#import "SNLiveFootBallTableViewCell.h" 

 
@implementation SNLiveFootBallTableViewCell


//计算高度 label +33  label最大宽度 width -82
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = UIColor.clearColor;
    self.lineView.layer.cornerRadius = 1.5;
    self.backView.layer.cornerRadius = 13;
    self.backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(1,3);
    self.backView.layer.shadowOpacity = 0.5;
    
}

 
- (void)setTModel:(SNFootBallTextLiveModel *)tModel {
    _tModel = tModel; 
    self.contentLabel.text = tModel.data;
    self.iconImageView.image = [UIImage imageNamed:tModel.imageName];
    self.lineView.hidden = YES;
    if (tModel.position.intValue == 1) {
        self.lineView.hidden = NO;
        self.lineView.backgroundColor = yellow_Color;
    }else if (tModel.position.intValue == 2) {
        self.lineView.hidden = NO;
        self.lineView.backgroundColor = Blue_Color;
    }
    if (tModel.isNew) {
        self.newsImageView.hidden = NO;
        self.contentLabelRight.constant = 55;
    }else {
        self.newsImageView.hidden = YES;
        self.contentLabelRight.constant = 20;
    }
}

@end
