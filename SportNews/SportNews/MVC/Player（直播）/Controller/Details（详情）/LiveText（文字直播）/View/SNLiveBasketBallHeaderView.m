//
//  SNLiveBasketBallHeaderView.m
//  SportNews
//
//  Created by kkk on 2021/1/20.
//

#import "SNLiveBasketBallHeaderView.h"

@implementation SNLiveBasketBallHeaderView

 
- (void)awakeFromNib {
    [super awakeFromNib];
     
    self.backView.backgroundColor = UIColor.whiteColor;
    self.backView.layer.cornerRadius = 13;
    self.backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0,5);
    self.backView.layer.shadowOpacity = 0.5;
    
    self.hLineView.layer.cornerRadius = self.hLineView.width/2;
    self.hLineView.backgroundColor = Blue_Color;
    self.gLineView.layer.cornerRadius = self.gLineView.width/2;
    self.gLineView.backgroundColor = Origin_Color;
     
    self.hFanguiLabel.textColor = Blue_Color;
    self.hZantingLabel.textColor = Blue_Color;
    self.gFanguiLabel.textColor = Origin_Color;
    self.gZantingLabel.textColor = Origin_Color;
    
    self.hBTProgressView1.backgroundColor = Blue_Light_Color;
    self.hBTProgressView2.backgroundColor = Blue_Light_Color;
    self.hBTProgressView3.backgroundColor = Blue_Light_Color;
    self.hBTProgressView4.backgroundColor = Blue_Light_Color;
    self.hTProgressView1.backgroundColor = Blue_Color;
    self.hTProgressView2.backgroundColor = Blue_Color;
    self.hTProgressView3.backgroundColor = Blue_Color;
    self.hTProgressView4.backgroundColor = Blue_Color;
    
    self.gBTProgressView1.backgroundColor = Origin_Light_Color;
    self.gBTProgressView2.backgroundColor = Origin_Light_Color;
    self.gBTProgressView3.backgroundColor = Origin_Light_Color;
    self.gBTProgressView4.backgroundColor = Origin_Light_Color;
    self.gTProgressView1.backgroundColor = Origin_Color;
    self.gTProgressView2.backgroundColor = Origin_Color;
    self.gTProgressView3.backgroundColor = Origin_Color;
    self.gTProgressView4.backgroundColor = Origin_Color;
    
     
}

//| 状态码  |   描述
//| ------ | -----------
//| 1      | 3分球进球数
//| 2      | 2分球进球数
//| 3      | 罚球进球数
//| 4      | 剩余暂停数
//| 5      | 犯规数
//| 6      | 罚球命中率
//| 7      | 总暂停数

- (void)setResultBasketObj:(SNBasketBallResult *)resultBasketObj {
    _resultBasketObj = resultBasketObj;
    
    if (resultBasketObj.score.count >= 4) {
        NSArray *hScoreArray = resultBasketObj.score[4];
        NSString *score1 = [NSString stringWithFormat:@"%@",hScoreArray[0]];
        self.hScoreLabel1.text = score1;
        NSString *score2 = [NSString stringWithFormat:@"%@",hScoreArray[1]];
        self.hScoreLabel2.text = score2;
        NSString *score3 = [NSString stringWithFormat:@"%@",hScoreArray[2]];
        self.hScoreLabel3.text = score3;
        NSString *score4 = [NSString stringWithFormat:@"%@",hScoreArray[3]];
        self.hScoreLabel4.text = score4;
        NSString *scoreot = [NSString stringWithFormat:@"%@",hScoreArray[4]];
        self.hScoreLabelOT.text = scoreot;
        self.hScoreTotalLabel.text = [NSString stringWithFormat:@"%ld",(score1.integerValue+score2.integerValue+score3.integerValue+score4.integerValue+scoreot.integerValue)];
        
        NSArray *gScoreArray = resultBasketObj.score[3];
        NSString *score1g = [NSString stringWithFormat:@"%@",gScoreArray[0]];
        self.gScoreLabel1.text = score1g;
        NSString *score2g = [NSString stringWithFormat:@"%@",gScoreArray[1]];
        self.gScoreLabel2.text = score2g;
        NSString *score3g = [NSString stringWithFormat:@"%@",gScoreArray[2]];
        self.gScoreLabel3.text = score3g;
        NSString *score4g = [NSString stringWithFormat:@"%@",gScoreArray[3]];
        self.gScoreLabel4.text = score4g;
        NSString *scoreotg = [NSString stringWithFormat:@"%@",gScoreArray[4]];
        self.gScoreLabelOT.text = scoreotg;
        self.gScoreTotalLabel.text = [NSString stringWithFormat:@"%ld",(score1g.integerValue+score2g.integerValue+score3g.integerValue+score4g.integerValue+scoreot.integerValue)];
    }
     
    CGFloat width = 62;
    for (NSArray *statsArray in resultBasketObj.stats) {
        NSInteger index1 = [statsArray[0] integerValue];
        float score1 = 0;
        float score2 = 0;
        
        if (index1 == 6) { //罚球命中
            double index2 = [statsArray[2] doubleValue];
            double index3 = [statsArray[1] doubleValue];
            self.hMingZhongLabel.text = [NSString stringWithFormat:@"%0.1f",index2];
            self.gMingZhongLabel.text = [NSString stringWithFormat:@"%0.1f",index3];
            if (index2 + index3 > 0) {
                score1 = (float)index2/(index2 + index3);
                score2 = (float)index3/(index2 + index3);
            }
            self.hMingWidth.constant = score1*width;
            self.gMingWidth.constant = score2*width;
        }else {
            NSInteger index2 = [statsArray[2] integerValue];
            NSInteger index3 = [statsArray[1] integerValue];
            if (index1 == 1) { //3分
                self.hThreeScoreLabel.text = [NSString stringWithFormat:@"%ld",index2*3];
                self.gThreeScoreLabel.text = [NSString stringWithFormat:@"%ld",index3*3];
                if (index2 + index3 > 0) {
                    score1 = (float)index2/(index2 + index3);
                    score2 = (float)index3/(index2 + index3);
                }
                self.hThreeWidth.constant = score1*width;
                self.gThreeWidth.constant = score2*width;
                
            }else if (index1 == 2) { //2分
                self.hTwoScoreLabel.text = [NSString stringWithFormat:@"%ld",index2*2];
                self.gTwoScoreLabel.text = [NSString stringWithFormat:@"%ld",index3*2];
                if (index2 + index3 > 0) {
                    score1 = (float)index2/(index2 + index3);
                    score2 = (float)index3/(index2 + index3);
                }
                self.hTwoWidth.constant = score1*width;
                self.gTwoWidth.constant = score2*width;
            }else if (index1 == 3) { //罚球
                self.hFaquiLabel.text = [NSString stringWithFormat:@"%ld",index2];
                self.gFaquiLabel.text = [NSString stringWithFormat:@"%ld",index3];
                if (index2 + index3 > 0) {
                    score1 = (float)index2/(index2 + index3);
                    score2 = (float)index3/(index2 + index3);
                }
                self.hFaWidth.constant = score1*width;
                self.gFaWidth.constant = score2*width;
            }else if (index1 == 4) { //剩余暂停数
                self.hZantingLabel.text = [NSString stringWithFormat:@"%ld",index2];
                self.gZantingLabel.text = [NSString stringWithFormat:@"%ld",index3];
            }else if (index1 == 5) { //犯规数
                self.hFanguiLabel.text = [NSString stringWithFormat:@"%ld",index2];
                self.gFanguiLabel.text = [NSString stringWithFormat:@"%ld",index3];
            }
        }
    }
}




@end
