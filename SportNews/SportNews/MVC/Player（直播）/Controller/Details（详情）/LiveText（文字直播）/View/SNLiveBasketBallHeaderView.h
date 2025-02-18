//
//  SNLiveBasketBallHeaderView.h
//  SportNews
//
//  Created by kkk on 2021/1/20.
//

#import <UIKit/UIKit.h>
#import "SNBasketBallResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNLiveBasketBallHeaderView : BaseXibView

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIView *hLineView;
@property (weak, nonatomic) IBOutlet UIView *gLineView;

//黄队名字
@property (weak, nonatomic) IBOutlet UILabel *hNameLabel;
//第一节得分
@property (weak, nonatomic) IBOutlet UILabel *hScoreLabel1;
//二
@property (weak, nonatomic) IBOutlet UILabel *hScoreLabel2;
//三
@property (weak, nonatomic) IBOutlet UILabel *hScoreLabel3;
//四
@property (weak, nonatomic) IBOutlet UILabel *hScoreLabel4;
@property (weak, nonatomic) IBOutlet UILabel *hScoreLabelOT;
@property (weak, nonatomic) IBOutlet UILabel *hScoreTotalLabel;

//犯规
@property (weak, nonatomic) IBOutlet UILabel *hFanguiLabel;
//暂停
@property (weak, nonatomic) IBOutlet UILabel *hZantingLabel;
//3分得分
@property (weak, nonatomic) IBOutlet UILabel *hThreeScoreLabel;
//2分得分
@property (weak, nonatomic) IBOutlet UILabel *hTwoScoreLabel;
//罚球得分
@property (weak, nonatomic) IBOutlet UILabel *hFaquiLabel;
//罚球命中率
@property (weak, nonatomic) IBOutlet UILabel *hMingZhongLabel;

@property (weak, nonatomic) IBOutlet UIView *hBTProgressView1;
@property (weak, nonatomic) IBOutlet UIView *hBTProgressView2;
@property (weak, nonatomic) IBOutlet UIView *hBTProgressView3;
@property (weak, nonatomic) IBOutlet UIView *hBTProgressView4;
@property (weak, nonatomic) IBOutlet UIView *hTProgressView1;
@property (weak, nonatomic) IBOutlet UIView *hTProgressView2;
@property (weak, nonatomic) IBOutlet UIView *hTProgressView3;
@property (weak, nonatomic) IBOutlet UIView *hTProgressView4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hThreeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hTwoWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hFaWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hMingWidth;


//绿队
@property (weak, nonatomic) IBOutlet UILabel *gNameLabel;
//第一节得分
@property (weak, nonatomic) IBOutlet UILabel *gScoreLabel1;
//二
@property (weak, nonatomic) IBOutlet UILabel *gScoreLabel2;
//三
@property (weak, nonatomic) IBOutlet UILabel *gScoreLabel3;
//四
@property (weak, nonatomic) IBOutlet UILabel *gScoreLabel4;
@property (weak, nonatomic) IBOutlet UILabel *gScoreLabelOT;
@property (weak, nonatomic) IBOutlet UILabel *gScoreTotalLabel;


//犯规
@property (weak, nonatomic) IBOutlet UILabel *gFanguiLabel;
//暂停
@property (weak, nonatomic) IBOutlet UILabel *gZantingLabel;
//3分得分
@property (weak, nonatomic) IBOutlet UILabel *gThreeScoreLabel;
//2分得分
@property (weak, nonatomic) IBOutlet UILabel *gTwoScoreLabel;
//罚球得分
@property (weak, nonatomic) IBOutlet UILabel *gFaquiLabel;
//罚球命中率
@property (weak, nonatomic) IBOutlet UILabel *gMingZhongLabel;

@property (weak, nonatomic) IBOutlet UIView *gBTProgressView1;
@property (weak, nonatomic) IBOutlet UIView *gBTProgressView2;
@property (weak, nonatomic) IBOutlet UIView *gBTProgressView3;
@property (weak, nonatomic) IBOutlet UIView *gBTProgressView4;
@property (weak, nonatomic) IBOutlet UIView *gTProgressView1;
@property (weak, nonatomic) IBOutlet UIView *gTProgressView2;
@property (weak, nonatomic) IBOutlet UIView *gTProgressView3;
@property (weak, nonatomic) IBOutlet UIView *gTProgressView4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gThreeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gTwoWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gFaWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gMingWidth;

//篮球直播
@property(nonatomic, strong) SNBasketBallResult *resultBasketObj;

@end

NS_ASSUME_NONNULL_END
