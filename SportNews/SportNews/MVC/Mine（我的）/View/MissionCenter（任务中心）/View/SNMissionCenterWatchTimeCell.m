//
//  SNMissionCenterWatchTimeCell.m
//  SportNews
//
//  Created by kkk on 2021/5/12.
//

#import "SNMissionCenterWatchTimeCell.h"

@interface SNMissionCenterWatchTimeCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIButton *getBtn;

@property (weak, nonatomic) IBOutlet UIView *lineBackView;
@property (weak, nonatomic) IBOutlet UIView *processView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *processViewWidth;


@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@property (weak, nonatomic) IBOutlet UIView *backView1;
@property (weak, nonatomic) IBOutlet UIView *backView2;
@property (weak, nonatomic) IBOutlet UIView *backView3;


@property (weak, nonatomic) IBOutlet UILabel *countLabel1;
@property (weak, nonatomic) IBOutlet UILabel *countLabel2;
@property (weak, nonatomic) IBOutlet UILabel *countLabel3;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel3;


@end

@implementation SNMissionCenterWatchTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = SRGB(248);
    self.selectionStyle = 0;
    self.lineBackView.layer.cornerRadius = 5;
    self.lineBackView.clipsToBounds = YES;
    
    [CommonTools setupViewLayer:self.backView]; 
    
    self.backView1.layer.cornerRadius = self.backView1.height/2;
    self.backView2.layer.cornerRadius = self.backView1.height/2;
    self.backView3.layer.cornerRadius = self.backView1.height/2;
    self.processViewWidth.constant = 0;
    [self setupTime:0];
    
}

- (void)setupTime:(NSInteger)time {
    
    self.processViewWidth.constant = 0;
    self.countLabel1.textColor = [UIColor colorWithHexString:@"#999999"];
    self.countLabel2.textColor = [UIColor colorWithHexString:@"#999999"];
    self.countLabel3.textColor = [UIColor colorWithHexString:@"#999999"];
    self.backView1.backgroundColor = [UIColor colorWithHexString:@"#F3F7FA"];
    self.backView2.backgroundColor = [UIColor colorWithHexString:@"#F3F7FA"];
    self.backView3.backgroundColor = [UIColor colorWithHexString:@"#F3F7FA"];
    self.imageView1.image = [UIImage imageNamed:@"编组 11"];
    self.imageView2.image = [UIImage imageNamed:@"编组 11"];
    self.imageView3.image = [UIImage imageNamed:@"编组 11"];
    CGFloat totalW =  kScreenWidth -40 -30;
    if (time > 60) {
        self.processViewWidth.constant = totalW;
        self.countLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
        self.countLabel2.textColor = [UIColor colorWithHexString:@"#333333"];
        self.countLabel3.textColor = [UIColor colorWithHexString:@"#333333"];
        self.backView1.backgroundColor = [UIColor colorWithHexString:@"#FFDA21"];
        self.backView2.backgroundColor = [UIColor colorWithHexString:@"#FFDA21"];
        self.backView3.backgroundColor = [UIColor colorWithHexString:@"#FFDA21"];
        self.imageView1.image = [UIImage imageNamed:@"编组 19"];
        self.imageView2.image = [UIImage imageNamed:@"编组 19"];
        self.imageView3.image = [UIImage imageNamed:@"编组 19"];
    }else if (time > 30) {
        self.processViewWidth.constant = totalW/2;
        self.countLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
        self.countLabel2.textColor = [UIColor colorWithHexString:@"#333333"];
        self.backView1.backgroundColor = [UIColor colorWithHexString:@"#FFDA21"];
        self.backView2.backgroundColor = [UIColor colorWithHexString:@"#FFDA21"];
        self.imageView1.image = [UIImage imageNamed:@"编组 19"];
        self.imageView2.image = [UIImage imageNamed:@"编组 19"];
    }else if (time > 5) {
        self.processViewWidth.constant = 28;
        self.countLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
        self.backView1.backgroundColor = [UIColor colorWithHexString:@"#FFDA21"];
        self.imageView1.image = [UIImage imageNamed:@"编组 19"]; 
    }
}
 
//一键领取
- (IBAction)lingquAllAction:(id)sender {
    
}

//五分钟
- (IBAction)wufenAction:(id)sender {
    
}

//三十分钟
- (IBAction)sanshifenAction:(id)sender {
    
}

//六十分钟
- (IBAction)liushifenAction:(id)sender {
    
}

@end
