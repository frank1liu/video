//
//  SNQuestionFloatBall.m
//  SportNews
//
//  Created by 根哥 on 2021/3/9.
//

#import "SNQuestionFloatBall.h"

@interface SNQuestionFloatBall ()

@property (weak, nonatomic) IBOutlet UIImageView *topImage3;
@property (weak, nonatomic) IBOutlet UILabel *top3;

@property (weak, nonatomic) IBOutlet UIImageView *topImage4;
@property (weak, nonatomic) IBOutlet UILabel *top4;

@property (weak, nonatomic) IBOutlet UIImageView *topImage5;
@property (weak, nonatomic) IBOutlet UILabel *top5;


@property (weak, nonatomic) IBOutlet UIImageView *bottomImage1;
@property (weak, nonatomic) IBOutlet UILabel *bottom1;

@property (weak, nonatomic) IBOutlet UIImageView *bottomImage2;
@property (weak, nonatomic) IBOutlet UILabel *bottom2;

@property (weak, nonatomic) IBOutlet UIImageView *bottomImage3;
@property (weak, nonatomic) IBOutlet UILabel *bottom3;

@property (weak, nonatomic) IBOutlet UIImageView *bottomImage4;
@property (weak, nonatomic) IBOutlet UILabel *bottom4;

@property (weak, nonatomic) IBOutlet UIImageView *bottomImage5;
@property (weak, nonatomic) IBOutlet UILabel *bottom5;

 
@end


@implementation SNQuestionFloatBall


- (void)awakeFromNib {
   [super awakeFromNib];
    
}

- (void)setupIsLive:(BOOL)isLive {
    if (isLive) {
        self.top3.text = @"点球未进";
        self.topImage3.image = [UIImage imageNamed:@"点球未进"];
        self.top4.text = @"乌龙球";
        self.topImage4.image = [UIImage imageNamed:@"乌龙球"];
        self.top5.text = @"助攻";
        self.topImage5.image = [UIImage imageNamed:@"助攻"];
        
        self.bottom1.text = @"角球";
        self.bottomImage1.image = [UIImage imageNamed:@"角球"];
        self.bottom2.text = @"黄牌";
        self.bottomImage2.image = [UIImage imageNamed:@"黄牌"];
        self.bottom3.text = @"红牌";
        self.bottomImage3.image = [UIImage imageNamed:@"红牌"];
        self.bottom4.text = @"换人";
        self.bottomImage4.image = [UIImage imageNamed:@"交换"];
        self.bottom5.text = @"两黄一红";
        self.bottomImage5.image = [UIImage imageNamed:@"两黄一红"];
    }else {
        self.top3.text = @"乌龙球  ";
        self.topImage3.image = [UIImage imageNamed:@"乌龙球"];
        self.top4.text = @"助攻";
        self.topImage4.image = [UIImage imageNamed:@"助攻"];
        self.top5.text = @"队长";
        self.topImage5.image = [UIImage imageNamed:@"队长"];
         
        self.bottom1.text = @"黄牌";
        self.bottomImage1.image = [UIImage imageNamed:@"黄牌"];
        self.bottom2.text = @"红牌";
        self.bottomImage2.image = [UIImage imageNamed:@"红牌"];
        self.bottom3.text = @"两黄一红";
        self.bottomImage3.image = [UIImage imageNamed:@"两黄一红"];
        self.bottom4.text = @"换人";
        self.bottomImage4.image = [UIImage imageNamed:@"交换"];
        self.bottom5.text = @"全场最佳";
        self.bottomImage5.image = [UIImage imageNamed:@"全场最佳"];
    }
}
 

@end
