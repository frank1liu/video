//
//  SNLiveFootBallSectionHeaderView.m
//  SportNews
//
//  Created by kkk on 2021/1/20.
//

#import "SNLiveFootBallSectionHeaderView.h"

@implementation SNLiveFootBallSectionHeaderView

 
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self gradineLineView];
    self.lineView.layer.cornerRadius = self.lineView.height/2;
    self.lineView.clipsToBounds = YES;
    self.magin = (kScreenWidth - 140)/3;
    self.btnLeft.constant = self.magin;
    self.btnRight.constant = self.magin;
    self.lineLeft.constant = self.magin+20;
    self.textBtn.selected = YES;
    
}

- (void)gradineLineView {
    CAGradientLayer* gradinentlayer=[CAGradientLayer layer];
    gradinentlayer.colors=@[(__bridge id)[UIColor colorWithHexString:@"#27C5C3"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#68FF87"].CGColor];
    gradinentlayer.locations = @[@0.5];
    gradinentlayer.startPoint = CGPointMake(0, 0);
    gradinentlayer.endPoint = CGPointMake(1.0, 0);
    gradinentlayer.frame = CGRectMake(0, 0, 30, 4);
    [self.lineView.layer addSublayer:gradinentlayer];

}
 
- (void)setFootTag:(NSInteger)footTag {
    _footTag = footTag;
    BOOL select = footTag == 0? YES:NO;
    self.textBtn.selected = select;
    self.importBtn.selected = !select;
    if (select) {
        self.lineLeft.constant = self.magin+20;
    }else {
        self.lineLeft.constant = self.magin*2+70+20;
    }
     
}

- (IBAction)textBtnAction:(UIButton *)sender {
    self.textBtn.selected = YES;
    self.importBtn.selected = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.lineView.x = self.magin+20;
    }];
    if (self.footHeaderClickWithTag) {
        self.footHeaderClickWithTag(0);
    }
}

- (IBAction)importBtnAction:(UIButton *)sender {
    self.textBtn.selected = NO;
    self.importBtn.selected = YES;
    [UIView animateWithDuration:0.35 animations:^{
        self.lineView.x = self.magin*2+70+20;
    }];
    if (self.footHeaderClickWithTag) {
        self.footHeaderClickWithTag(1);
    }
}


@end
