//
//  SNMissionCenterTaskCell.m
//  SportNews
//
//  Created by kkk on 2021/5/12.
//

#import "SNMissionCenterTaskCell.h"

@interface SNMissionCenterTaskCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView1;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *countLabel1;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView2;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;
@property (weak, nonatomic) IBOutlet UILabel *countLabel2;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@end

@implementation SNMissionCenterTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = SRGB(248);
    self.selectionStyle = 0;
    [CommonTools setupViewLayer:self.backView];
    self.topBtn.layer.cornerRadius = 14;
    self.bottomBtn.layer.cornerRadius = 14;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (indexPath.row == 1) {
        self.titleLabel.text = @"新手任务";
        self.contentLabel1.text = @"首次注册成功";
        self.countLabel1.text = @"音浪+200";
        self.iconImageView1.image = [UIImage imageNamed:@"注册"];
        [self.topBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        self.contentLabel2.attributedText = [self contentAttributeString:@"连续登录(0/3)"];
        self.countLabel2.text = @"音浪+10";
        self.iconImageView2.image = [UIImage imageNamed:@"登录"];
        [self.bottomBtn setTitle:@"立即领取" forState:UIControlStateNormal];
    }else {
        self.titleLabel.text = @"日常任务";
        self.contentLabel1.attributedText = [self contentAttributeString:@"分享直播间一次(0/3)"];
        self.countLabel1.text = @"音浪+20";
        self.iconImageView1.image = [UIImage imageNamed:@"分享"];
        [self.topBtn setTitle:@"去分享" forState:UIControlStateNormal];
        self.contentLabel2.attributedText = [self contentAttributeString:@"邀请好友一起看球(0/10)"];
        self.countLabel2.text = @"音浪+10";
        self.iconImageView2.image = [UIImage imageNamed:@"邀请"];
        [self.bottomBtn setTitle:@"去邀请" forState:UIControlStateNormal];
    }
}

- (NSMutableAttributedString *)contentAttributeString:(NSString *)contentStr {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSRange startRange = [contentStr rangeOfString:@"("];
    NSRange endRange = [contentStr rangeOfString:@"/"];
    if (startRange.location != NSNotFound && endRange.location != NSNotFound) {
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *subStr = [contentStr substringWithRange:range];
        //自能是数字
        if (subStr && [self validateNumber:subStr]) {
            NSDictionary * attribute = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#27C5C3"]};
            if (range.location != NSNotFound) {
                [attributeStr addAttributes:attribute range:range];
            }
        }
    }
    return attributeStr;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (IBAction)topButtonAction:(UIButton *)sender {
    
    
}

- (IBAction)bottomButtonAction:(UIButton *)sender {
    
    
}

@end
