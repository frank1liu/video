//
//  SNShowFloatWindowView.m
//  SportNews
//
//  Created by kkk on 2021/3/17.
//

#import "SNShowFloatWindowView.h"

@implementation SNShowFloatWindowView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancelBtn.layer.cornerRadius = self.cancelBtn.height/2;
    
    self.bgBackView.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.bgBackView.alpha = 0.6;
        self.backViewBottom.constant = 0;
        [self layoutIfNeeded];
    }];
}


- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    [[NSUserDefaults standardUserDefaults] setInteger:selectIndex forKey:CloseSmallWindow];
    if (selectIndex == 0) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        self.titleLabel1.textColor = Blue_Color;
        self.backBtn.backgroundColor = UIColor.clearColor;
        self.backBtn1.backgroundColor = Blue_Color;
        self.iconImageView.hidden = YES;
        self.iconImageView1.hidden = NO;
    }else {
        self.titleLabel.textColor = Blue_Color;
        self.titleLabel1.textColor = [UIColor colorWithHexString:@"#666666"];
        self.backBtn.backgroundColor = Blue_Color;
        self.backBtn1.backgroundColor = UIColor.clearColor;
        self.iconImageView.hidden = NO;
        self.iconImageView1.hidden = YES;
    }
}

- (IBAction)selectRefuseAction:(UIButton *)sender {
    self.selectIndex = 1;
    [self hide];
    if (self.clickWithSelect) {
        self.clickWithSelect(1);
    }
    
}
- (IBAction)selectAgressAction:(UIButton *)sender {
    self.selectIndex = 0;
    [self hide];
    if (self.clickWithSelect) {
        self.clickWithSelect(0);
    }
}

- (void)hide {
    [UIView animateWithDuration:0.35 animations:^{
        self.bgBackView.alpha = 0;
        self.backViewBottom.constant = - 390;
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)backBtnAction:(id)sender {
    [self hide];
}

- (IBAction)cancelAction:(id)sender {
    [self hide];
}

- (void)drawRect:(CGRect)rect {
    [self.backView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(13, 13)];
}

@end
