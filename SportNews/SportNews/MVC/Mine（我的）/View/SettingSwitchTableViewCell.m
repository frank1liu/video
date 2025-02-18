//
//  SettingSwitchTableViewCell.m
//  SportNews
//
//  Created by kkk on 2020/12/7.
//

#import "SettingSwitchTableViewCell.h"

@implementation SettingSwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.subLabel.textColor = commonSubTextColor;
    self.openSwitch.thumbTintColor = UIColor.whiteColor;
    self.openSwitch.onTintColor = Blue_Color;

    self.openSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.lineView.backgroundColor = SRGB(235);
}

- (IBAction)openSwitchAction:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:!sender.isOn forKey:CloseSmallWindow];
}


@end
