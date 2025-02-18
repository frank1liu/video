//
//  LiveContentBottomView.m
//  SportNews
//
//  Created by K哥 on 2021/2/22.
//

#import "LiveContentBottomView.h"

@interface LiveContentBottomView()

@property (nonatomic, strong) UIButton          *lastSelectBtn;

@property(nonatomic, strong) NSMutableArray *buttonArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelWidth;


@end
@implementation LiveContentBottomView

- (void)awakeFromNib {
    [super awakeFromNib]; 
    self.scoreLabel.hidden = YES;
    self.shimmerScoreView.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (IBAction)showBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.scoreLabel.hidden = NO;
        self.shimmerScoreView.hidden = YES;
        self.scoreLabel.text = @"VS";
        self.scoreWidth.constant = [self evaluteWidth:self.scoreLabel];
    }else {
        self.scoreLabel.hidden = YES;
        self.shimmerScoreView.hidden = NO;
        self.scoreLabel.text = self.shimmerScoreView.text;
        self.scoreWidth.constant = [self evaluteWidth:self.scoreLabel];
    }
}

- (void)setModel:(LiveListModel *)model {
    _model = model;
    _timeStr = @"";
    NSArray *score = [model.score componentsSeparatedByString:@"-"];
    self.typeImageView.hidden = YES;
    self.showBtn.hidden = YES;
    if ([self.model.name containsString:@"NBA"] || self.model.type.intValue == 1) {
        self.typeImageView.hidden = YES;
        self.showBtn.hidden = YES;
    }
    if (model.type.intValue == 2) {
        BOOL isStart = NO;
        NSString *scoreStr = [NSString stringWithFormat:@"%@ - %@",score.lastObject,score.firstObject];
        if (![self.scoreLabel.text isEqualToString:scoreStr]) {
            isStart = YES;
        }
        self.scoreLabel.text = scoreStr;
        self.scoreWidth.constant = [self evaluteWidth:self.scoreLabel];
        self.shimmerScoreView.text = self.scoreLabel.text;
        if (isStart) {
            [self.shimmerScoreView startShimmer];
        } 
        self.aTeamNameLabel.text = model.hteam_name;
        self.hTeamNameLabel.text = model.ateam_name;
        [self.aTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
        [self.hTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
    } else if(model.type.intValue == 1) {
        BOOL isStart = NO;
        NSString *scoreStr = [NSString stringWithFormat:@"%@ - %@",score.firstObject,score.lastObject];
        if (![self.scoreLabel.text isEqualToString:scoreStr]) {
            isStart = YES;
        }
        self.scoreLabel.text = scoreStr;
        self.scoreWidth.constant = [self evaluteWidth:self.scoreLabel];
        self.shimmerScoreView.text = self.scoreLabel.text;
        if (isStart) {
            [self.shimmerScoreView startShimmer];
        }
         
        self.aTeamNameLabel.text = model.ateam_name;
        self.hTeamNameLabel.text = model.hteam_name;
        [self.aTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
        [self.hTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
    } else {
        BOOL isStart = NO;
        NSString *scoreStr = @"VS";
        if (![self.scoreLabel.text isEqualToString:scoreStr]) {
            isStart = YES;
        }
        self.scoreLabel.text = scoreStr;
        self.scoreWidth.constant = [self evaluteWidth:self.scoreLabel];
        self.shimmerScoreView.text = self.scoreLabel.text;
        if (isStart) {
            [self.shimmerScoreView startShimmer];
        }
        self.aTeamNameLabel.text = model.ateam_name;
        self.hTeamNameLabel.text = model.hteam_name;
    }

    if (model.type.integerValue == 2) {
        self.typeImageView.image = [UIImage imageNamed:@"篮球"];
    }else if(model.type.integerValue == 1) {
        self.typeImageView.image = [UIImage imageNamed:@"足球"];
    }
    self.statusRight.constant = -10;
    _timeStr = model.time;
    if (_timeStr == nil) {
        _timeStr = @"";
    }
    //比赛状态：0 开赛中  1 未开赛  2 比赛结束 3 比赛推迟 4 未确定的 5 已取消的
    NSInteger status = model.status.integerValue;
    [self.typeImageView.layer removeAllAnimations];
    [self.dianLabel.layer removeAllAnimations];
    self.timeLabel.hidden = NO;
    if (status == 0)  {
        [self loadAnimate];
        if (model.type.intValue == 1) {
            self.statusRight.constant = 6;
            self.timeLabel.text = model.time;
            self.dianLabel.hidden = NO;
            self.statusLabel.text = model.status_up_name;
            [self.dianLabel.layer addAnimation:[CommonTools opacityForever_Animation:0.5] forKey:@"opacityForeverAnimation"];
        }else {
            self.timeLabel.text = @"";
            self.dianLabel.hidden = YES;
            self.statusLabel.text = [NSString stringWithFormat:@"%@ %@",model.status_up_name,model.time];
            self.statusRight.constant = -10;
        }
    }else {
        self.dianLabel.hidden = YES;
        self.timeLabel.text = @"";
        self.statusRight.constant = -10;
        self.statusLabel.text = model.status_up_name;
    }
    
    self.backgroundColor = RGB(72, 183, 180);
    if (self.buttonArray.count != model.live_urls.count) {
        for (UIButton *btn in self.buttonArray) {
            [btn removeFromSuperview];
        }
        [self.buttonArray removeAllObjects];
    }
//    if (self.buttonArray.count == 0) {
//        [self setupLiveBtns:model];
//    }
    [self setupDownloadView];
    [self setupLiveBtnsAtScrollView:model];
}

- (void)setupDownloadView {
    self.downloadBaseView.backgroundColor = [UIColor colorWithHexString:@"#FBEBE2"];
    self.downloadBaseView.layer.cornerRadius = 18.0;
    self.downloadBaseView.clipsToBounds = YES;
    self.downloadBaseView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL)];
    tap.numberOfTapsRequired = 1;
    [self.downloadBaseView addGestureRecognizer:tap];
}

- (void)openURL {
    NSString *url = [NSString stringWithFormat:@"https://dl.nongzhiw.cn/?matchType=%ld&matchId=%ld", [self.model.type longValue], [self.model.ID longValue]];
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
}

- (void )setupLiveBtnsAtScrollView:(LiveListModel *)model {
    NSArray *cartoonArray = model.live_urls;
    //创建各个Button
    NSInteger currentRight = 0; // 记录当前Btn的right（右边）
    NSInteger currentBottom = 0; // 记录当前btn的bottom（底部）
    NSMutableArray *btnMaxArray = [NSMutableArray array];
    // NSMutableArray *buttonArray = [NSMutableArray array];
    CGFloat originX = 4; //初始X
    CGFloat totalWidth = self.frame.size.width; //总宽
    CGFloat magin = 12; //按钮之间的间距
    CGFloat imageWidth = 10; //图片宽度
    CGFloat totalSize = 0;
    UIFont *font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    for (UIButton *btn in self.buttonArray) {
        [btn removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    for (int i = 0; i < cartoonArray.count; i++) {
        LiveCartoonModel *cartoonModel = cartoonArray[i];
        // UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *Btn = [[UIButton alloc]init];
        Btn.enabled = cartoonModel.status;
        Btn.tag = i;
        [Btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        // [buttonArray addObject:Btn];
        Btn.frame = CGRectMake(currentRight + originX, currentBottom + 5, 110, 32);
        // 计算字体长度
        CGSize size = [cartoonModel.name boundingRectWithSize:CGSizeMake(totalWidth, 30000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        // 更新btn的右边
        currentRight = currentRight + size.width + imageWidth + magin;
        // 判断是否换行
        if (i < cartoonArray.count - 1) {
            LiveCartoonModel *cartoonModel1 = cartoonArray[i + 1];
            // 计算字体长度
            CGSize size = [cartoonModel1.name boundingRectWithSize:CGSizeMake(totalWidth, 30000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
            if (currentRight + size.width > totalWidth - originX*2 - magin) {
                [btnMaxArray addObject:[NSString stringWithFormat:@"%f",totalWidth - currentRight]];
                currentRight = 0;
                currentBottom = currentBottom + 30;
            }
        }
        //最后一个
        if (i == cartoonArray.count - 1) {
            currentBottom = currentBottom + 30;
            [btnMaxArray addObject:[NSString stringWithFormat:@"%f",totalWidth - currentRight]];
        }
        // 更新每个Btn的frame
        CGRect frame = CGRectMake(Btn.frame.origin.x+4*i, Btn.frame.origin.y, size.width + imageWidth+10, size.height + 5+3);
        Btn.frame = frame;
        // 设置btn的属性
        Btn.titleLabel.font = font;
        if (i == 0) {
            Btn.backgroundColor = Blue_Color;
            [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            Btn.backgroundColor = Blue_Light_Color;
            [Btn setTitleColor:Blue_Color forState:UIControlStateNormal];
        }
        [Btn setTitle:cartoonModel.name forState:UIControlStateNormal];
        Btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        Btn.layer.cornerRadius = Btn.height/2;
//        Btn.layer.borderColor = UIColor.clearColor.CGColor;
//        Btn.layer.borderWidth = 1;
        [self.liveBtnsScrollView addSubview:Btn];
        [self.buttonArray addObject:Btn];
        totalSize += Btn.frame.size.width;
    }
    if (cartoonArray.count > 0) {
        [self.liveBtnsScrollView setContentSize:CGSizeMake(totalSize + 8*cartoonArray.count + 30, 35)];
    }
}

/*
- (void)setupLiveBtns:(LiveListModel *)model {
    NSArray *cartoonArray = model.live_urls;
    //创建各个Button
    NSInteger currentRight = 0; // 记录当前Btn的right（右边）
    NSInteger currentBottom = 0; // 记录当前btn的bottom（底部）
    NSMutableArray *btnMaxArray = [NSMutableArray array];
    NSMutableArray *buttonArray = [NSMutableArray array];
    CGFloat originX = 20; //初始X
    CGFloat totalWidth = self.frame.size.width; //总宽
    CGFloat magin = 10; //按钮之间的间距
    CGFloat imageWidth = 10; //图片宽度
    UIFont *font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    for (int i = 0; i < cartoonArray.count; i++) {
        LiveCartoonModel *cartoonModel = cartoonArray[i];
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn.enabled = cartoonModel.status;
        Btn.tag = i;
        [Btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:Btn];
        Btn.frame = CGRectMake(currentRight + originX, currentBottom + 5, 80, 25);
        // 计算字体长度
        CGSize size = [cartoonModel.name boundingRectWithSize:CGSizeMake(totalWidth, 30000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        // 更新btn的右边
        currentRight = currentRight + size.width + imageWidth + magin;
        // 判断是否换行
        if (i < cartoonArray.count - 1) {
            LiveCartoonModel *cartoonModel1 = cartoonArray[i + 1];
            // 计算字体长度
            CGSize size = [cartoonModel1.name boundingRectWithSize:CGSizeMake(totalWidth, 30000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
            if (currentRight + size.width > totalWidth - originX*2 - magin) {
                [btnMaxArray addObject:[NSString stringWithFormat:@"%f",totalWidth - currentRight]];
                currentRight = 0;
                currentBottom = currentBottom + 30;
            }
        }
        //最后一个
        if (i == cartoonArray.count - 1) {
            currentBottom = currentBottom + 30;
            [btnMaxArray addObject:[NSString stringWithFormat:@"%f",totalWidth - currentRight]];
        }
        // 更新每个Btn的frame
        CGRect frame = CGRectMake(Btn.frame.origin.x, Btn.frame.origin.y, size.width + imageWidth, size.height + 5);
        Btn.frame = frame;
        // 设置btn的属性
        Btn.titleLabel.font = font;
        Btn.backgroundColor = [UIColor clearColor];
        [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [Btn setTitle:cartoonModel.name forState:UIControlStateNormal];
        Btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        Btn.layer.cornerRadius = Btn.height/2;
        Btn.layer.borderColor = UIColor.clearColor.CGColor;
        Btn.layer.borderWidth = 1;
        [self addSubview:Btn];
        [self.buttonArray addObject:Btn];
    }
     
    //使按钮居中
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *btn = buttonArray[i];
        NSInteger y = btn.frame.origin.y/30;
        CGFloat x = ([btnMaxArray[y] floatValue] - 30)/2;
        CGRect frame = btn.frame;
        frame.origin.x = btn.frame.origin.x + x;
        btn.frame = frame;
    }
}
*/

- (void)setCartoonModel:(LiveCartoonModel *)cartoonModel {
    _cartoonModel = cartoonModel;
//    for (UIButton *btn in self.buttonArray) {
//        btn.layer.borderColor = UIColor.clearColor.CGColor;
//    }
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *btn = self.buttonArray[i];
        btn.backgroundColor = Blue_Light_Color;
        [btn setTitleColor:Blue_Color forState:UIControlStateNormal];
    }

    for (int i = 0; i < self.model.live_urls.count; i++) {
        LiveCartoonModel *model = self.model.live_urls[i];
        if ([model.url isEqualToString:cartoonModel.url]) {
            UIButton *selectBtn = self.buttonArray[i];
            // selectBtn.layer.borderColor = UIColor.yellowColor.CGColor;
            selectBtn.backgroundColor = Blue_Color;
            [selectBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            break;
        }
    }
}

- (void)btnClickAction:(UIButton *)sender {
    if (self.fblTap) {
        self.fblTap(self.model.live_urls[sender.tag]);
    }
}

- (void)loadAnimate {
    [self.typeImageView.layer addAnimation:[CommonTools rotationAnimation_Animation] forKey:@"rotationAnimation"];
}

- (CGFloat)evaluteWidth:(UILabel *)scoreLabel {
    NSDictionary *textAtt = @{NSFontAttributeName : scoreLabel.font};
    CGSize evaluteLabelSize = [scoreLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGFloat evaluteLabelSizeW = evaluteLabelSize.width + 1;
    return evaluteLabelSizeW;
}
 

- (void)setScoreStr:(NSString *)scoreStr {
    _scoreStr = scoreStr;
    if (self.showBtn.isSelected) {
        self.scoreLabel.text = @"VS";
        self.scoreWidth.constant = [self evaluteWidth:self.scoreLabel];
        return;
    }
    if ([CommonTools isBlankString:scoreStr]) {
        self.scoreLabel.text = @"0-0";
    }else { 
        BOOL isStart = NO;
        if (![self.scoreLabel.text isEqualToString:scoreStr]) {
            isStart = YES;
        }
        self.scoreLabel.text = scoreStr;
        self.scoreWidth.constant = [self evaluteWidth:self.scoreLabel];
        self.shimmerScoreView.text = self.scoreLabel.text;
        if (isStart) {
            [self.shimmerScoreView startShimmer];
        }
    }
}

/* score[2] 主队 score[3] 客队
 [
 0,//主队比分(常规时间)
 0,//主队半场比分
 0,//主队红牌
 0,//主队黄牌
 -1,//主队角球，-1表示没有角球数据
 0,//主队加时比分(120分钟)，加时赛才有
 0,//主队点球大战比分，点球大战才有
 ]
 */
- (void)setResultFootObj:(SNFootBallResult *)resultFootObj {
    _resultFootObj = resultFootObj;
    if (resultFootObj.score.count == 6) {
        NSNumber *status = resultFootObj.score[1];
        self.statusLabel.text = [CommonTools getFootStatus:status.intValue];
        //主队的
        NSString *hScore = @"";
        NSArray *zhuArray = resultFootObj.score[2];
        if (zhuArray.count == 7) {
            NSNumber *score = zhuArray[0];
            hScore = [NSString stringWithFormat:@"%@",score];
        }
        //客队的
        NSString *aScore = @"";
        NSArray *keArray = resultFootObj.score[3];
        if (keArray.count == 7) {
            NSNumber *score = keArray[0];
            aScore = [NSString stringWithFormat:@"%@",score];
        }
        BOOL isStart = NO;
        NSString *scoreStr = [NSString stringWithFormat:@"%@ - %@",hScore,aScore];
        if (![self.scoreLabel.text isEqualToString:scoreStr]) {
            isStart = YES;
        }
        self.scoreLabel.text = scoreStr;
        self.scoreWidth.constant = [self evaluteWidth:self.scoreLabel];
        self.shimmerScoreView.text = self.scoreLabel.text;
        if (isStart) {
            [self.shimmerScoreView startShimmer];
        }
    }
    if (resultFootObj.tlive.count > 0) {
        SNFootBallTextLiveModel *model = resultFootObj.tlive.lastObject;
        if (![CommonTools isBlankString:model.time]) {
            NSString *time = [model.time stringByReplacingOccurrencesOfString:@"'" withString:@""];
            _timeStr = time;
            self.timeLabel.text = time;
        }
    }
}

- (void)setResultBasketObj:(SNBasketBallResult *)resultBasketObj {
    _resultBasketObj = resultBasketObj;
    self.statusLabel.text = [NSString stringWithFormat:@"%@ %@",resultBasketObj.sectionString, _timeStr];
    if (resultBasketObj.tlive.count > 0) {
        NSArray *lastArray = resultBasketObj.tlive.lastObject;
        SNBasketBallTliveModel *model = lastArray.firstObject;
        if (![CommonTools isBlankString:model.time]) {
            if ([[_timeStr stringByReplacingOccurrencesOfString:@":" withString:@""] intValue] > [[model.time stringByReplacingOccurrencesOfString:@":" withString:@""] intValue]) {
                _timeStr = model.time;
                self.statusLabel.text = [NSString stringWithFormat:@"%@ %@",resultBasketObj.sectionString, model.time];
            }
        }
    }
    
    if (self.showBtn.isSelected) {
        self.scoreLabel.text = @"VS";
        self.scoreWidth.constant = [self evaluteWidth:self.scoreLabel];
        return;
    }
    NSArray *hScoreArray = resultBasketObj.score[3];
    NSInteger hTotal = 0;
    for (NSNumber *num in hScoreArray) {
        hTotal = hTotal + num.integerValue;
    }
    NSArray *gScoreArray = resultBasketObj.score[4];
    NSInteger gTotal = 0;
    for (NSNumber *num in gScoreArray) {
        gTotal = gTotal + num.integerValue;
    }
    
    BOOL isStart = NO;
//    NSString *scoreStr = [NSString stringWithFormat:@"%@ - %@",[NSString stringWithFormat:@"%ld",gTotal],[NSString stringWithFormat:@"%ld",hTotal]];
//    if (![self.scoreLabel.text isEqualToString:scoreStr]) {
//        isStart = YES;
//    }
//    self.scoreLabel.text = scoreStr;
    self.scoreWidth.constant = [self evaluteWidth:self.scoreLabel];
    self.shimmerScoreView.text = self.scoreLabel.text;
    if (isStart) {
        [self.shimmerScoreView startShimmer];
    }
}

- (void)setFootStatus:(NSInteger)footStatus {
    _footStatus = footStatus;
    self.statusLabel.text = [NSString stringWithFormat:@"%@",[CommonTools getFootStatus:footStatus]];
}
- (void)setBasketStatus:(NSInteger)basketStatus {
    _basketStatus = basketStatus;
    self.statusLabel.text = [NSString stringWithFormat:@"%@ %@",[CommonTools getBasketStatus:basketStatus], _timeStr];
}
 
- (void)setTimeStr:(NSString *)timeStr {
    _timeStr = timeStr;
    if (self.model.type.intValue == 1) {
        self.timeLabel.text = timeStr;
    }else {
        self.statusLabel.text = [NSString stringWithFormat:@"%@ %@",[CommonTools getBasketStatus:_basketStatus],timeStr];
    }
}

 

@end
