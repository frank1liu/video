//
//  SNYinLangHeaderView.m
//  SportNews
//
//  Created by kkk on 2021/5/13.
//

#import "SNYinLangHeaderView.h"
#import "SportNews-Swift.h"

@interface SNYinLangHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *yinlangCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *duihuanBtn;

@end

@implementation SNYinLangHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
      
    [CommonTools setupViewLayer:self.topBackView];
    self.duihuanBtn.layer.cornerRadius = 14; 
    
}

//兑换商城
- (IBAction)duihuanAction:(id)sender {
    SNShoppingVC *vc = [SNShoppingVC new];
    [[CommonTools currentViewController].navigationController pushViewController:vc animated:YES];
}

@end
