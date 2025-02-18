//
//  SNMissionCenterTableHeaderView.m
//  SportNews
//
//  Created by kkk on 2021/5/12.
//

#import "SNMissionCenterTableHeaderView.h"
#import "SNMissionCenterSignInCellView.h"
#import "SNMineInviteViewController.h"

@interface SNMissionCenterTableHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayGetLabel;

@property (weak, nonatomic) IBOutlet UIView *totalBackView;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBackHeight;

@property(nonatomic, strong) NSArray *cellViewArray;

@end

@implementation SNMissionCenterTableHeaderView
 
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageView.layer.cornerRadius = self.iconImageView.height/2;
    self.totalBackView.layer.cornerRadius = 10;
    
    [CommonTools setupViewLayer:self.bottomBackView]; 
    
    CAGradientLayer* gradinentlayer=[CAGradientLayer layer];
    gradinentlayer.colors=@[(__bridge id)RGB(25, 171, 245).CGColor,(__bridge id)RGB(69, 224, 154).CGColor];
    gradinentlayer.locations = @[@0.0,@1.0];
    gradinentlayer.startPoint = CGPointMake(0, 0.5);
    gradinentlayer.endPoint = CGPointMake(1, 0.5);
    gradinentlayer.frame = CGRectMake(0, 0, kScreenWidth, 200);
    [self.backImageView.layer addSublayer:gradinentlayer];
    
    self.bottomBackHeight.constant = (kScreenWidth - 100)/4*91/69*2 + 68;
    [self setupSignInView];
    
}
  
- (void)setupSignInView {

    NSArray *timeArrray = @[@"第一天",@"第二天",@"第三天",@"第四天",@"第五天",@"第六天",@"第七天"];
    CGFloat w = (kScreenWidth - 100)/4;
    CGFloat h = w*91/69;
    NSMutableArray *viewArray = [NSMutableArray array];
    for (int i = 0; i < timeArrray.count; i++) {
        NSString *time = timeArrray[i];
        SNMissionCenterSignInCellView *cellView = [[SNMissionCenterSignInCellView alloc] initWithFrame:CGRectMake((12+w)*(i%4)+12, (h+12)*(i/4)+44, i == 6?(w*2+12):w, h) withTime:time];
        cellView.style = i;
        [self.bottomBackView addSubview:cellView];
        UIButton *btn = [[UIButton alloc] initWithFrame:cellView.bounds];
        [cellView addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(cellViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [viewArray addObject:cellView];
    }
    self.cellViewArray = viewArray;
}

- (void)cellViewClick:(UIButton *)sender {
    
}

//邀请好友
- (IBAction)yaoqingAction:(id)sender {
    SNMineInviteViewController *VC = [[SNMineInviteViewController alloc] init];
    [[CommonTools currentViewController].navigationController pushViewController:VC animated:YES];
}


@end
