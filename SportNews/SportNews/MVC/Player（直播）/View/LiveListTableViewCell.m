//
//  LiveListTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/1/3.
//

#import "LiveListTableViewCell.h"
#import "SNLiveSourcesView.h"

@interface LiveListTableViewCell ()

@property(nonatomic, strong) SNLiveSourcesView *sourceView;

@end

@implementation LiveListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 13;
    self.backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0,2);
    self.backView.layer.shadowOpacity = 1;
      
    self.backgroundColor = SRGB(250);
    self.titleLabel.textColor = Blue_Color; 
    self.jiaoLabel.hidden = YES;
    self.banchangLabel.hidden = YES;
    
}

- (void)setModel:(LiveListModel *)model {
    _model = model;
    
    [self setupHuoImageView:model];
    
    [self setupScoreLabel:model];
    
    [self setupSourceView:model];
    
    [self setupOtherLabel:model];
    
}

- (void)setupScoreLabel:(LiveListModel *)model {
    if (model.type.intValue == 3) {
        // self.typeImageView.image = [UIImage imageNamed:@"clogoDef"];
        [self.typeImageView sd_setImageWithURL:[NSURL URLWithString:model.clogo] placeholderImage:UIImageMake(@"clogoDef")];
        self.scoreLabel.text = [NSString stringWithFormat:@" %@ ",@"VS"];
        self.aTeamNameLabel.text = model.ateam_name;
        self.hTeamNameLabel.text = model.hteam_name;
        [self.aTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.clogo] placeholderImage:UIImageMake(@"clogoDef")];
        [self.hTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.clogo] placeholderImage:UIImageMake(@"clogoDef")];

        [self.shimmerScoreView stopShimmer];
        self.shimmerScoreView.hidden = YES;
        self.scoreLabel.hidden = NO;
        self.scoreLabel.text = @"VS";
        self.scoreLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        self.scoreWidth.constant = [self evaluteWidth:self.scoreLabel];
    } else {
        NSArray *score = [model.score componentsSeparatedByString:@"-"];
        if (model.type.intValue == 2) {
            self.typeImageView.image = [UIImage imageNamed:@"篮球"];
            self.scoreLabel.text = [NSString stringWithFormat:@"%@ - %@",score.lastObject,score.firstObject];
            self.aTeamNameLabel.text = model.hteam_name;
            self.hTeamNameLabel.text = model.ateam_name;
            if ([model.ateam_logo isEqualToString:@""] && [model.hteam_logo isEqualToString:@""]) {
                [self.aTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.clogo] placeholderImage:UIImageMake(@"clogoDef")];
                [self.hTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.clogo] placeholderImage:UIImageMake(@"clogoDef")];
            } else {
                [self.aTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
                [self.hTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
            }
        }else {
            self.typeImageView.image = [UIImage imageNamed:@"足球"];
            self.scoreLabel.text = [NSString stringWithFormat:@"%@ - %@",score.firstObject,score.lastObject];
            self.aTeamNameLabel.text = model.ateam_name;
            self.hTeamNameLabel.text = model.hteam_name;
            if ([model.ateam_logo isEqualToString:@""] && [model.hteam_logo isEqualToString:@""]) {
                [self.aTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.clogo] placeholderImage:UIImageMake(@"clogoDef")];
                [self.hTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.clogo] placeholderImage:UIImageMake(@"clogoDef")];
            } else {
                [self.aTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
                [self.hTeamImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
            }
        }
        [self.shimmerScoreView stopShimmer];
        if (model.status.integerValue == 1) {
            self.shimmerScoreView.hidden = YES;
            self.scoreLabel.hidden = NO;
            self.scoreLabel.text = @"VS";
            self.scoreLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        }else {
            self.shimmerScoreView.text = self.scoreLabel.text;
            self.shimmerScoreView.hidden = NO;
            self.scoreLabel.hidden = YES;
            self.scoreLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightSemibold];
            //= YES 需要闪烁
            if (model.isNew) {
                [self.shimmerScoreView startShimmer];
            }
            model.isNew = NO;
        }
        self.scoreWidth.constant = [self evaluteWidth:self.scoreLabel];
    }
}

- (void)setupSourceView:(LiveListModel *)model {
    //设置下面的视频源按钮
    if (_sourceView) {
        [_sourceView removeFromSuperview];
        _sourceView = nil;
    }
    self.sourceView.backgroundColor = UIColor.clearColor;
    self.model.contentHeight = self.sourceView.contentHeight;
    if (model.live_cartoon_url.count == 0 && model.live_urls.count == 0) {
        self.stackView.hidden = NO;
        self.sourceView.hidden = YES;
    }else {
        self.stackView.hidden = YES;
        self.sourceView.hidden = NO;
    }
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.statusLabel.text = @"";
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.statusLabel.alpha =0.85;
}

- (void)setupOtherLabel:(LiveListModel *)model {
    
    NSString *title = model.name;
    if ([model.name isEqualToString:@"美国大学男子篮球联赛"]) {
        title = @"NCAA";
    }
    if (model.matchtime.length >= 16) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@  %@",[model.matchtime substringWithRange:NSMakeRange(11, 5)], title];
    }else {
        self.titleLabel.text = title;
    }
    
    // self.statusLabel.text = model.status_up_name;
    self.statusLabel.text = @"";
    if (model.type.intValue == 3 && model.status.intValue == 1) {
        self.statusLabel.text = @"未开赛";
    } else if (model.type.intValue == 3 && model.status.intValue == 2) {
        self.statusLabel.text = @"比赛中";
        self.statusLabel.textColor = UIColor.redColor;
        self.statusLabel.alpha =0.85;
    } else if (model.type.intValue == 3 && model.status.intValue == 3) {
        self.statusLabel.text = @"比赛结束";
    } else if ((model.type.intValue == 1 || model.type.intValue == 2) && model.status.intValue == 0) {
        self.statusLabel.text = @"比赛中";
        self.statusLabel.textColor = UIColor.redColor;
        self.statusLabel.alpha =0.85;
    } else if ((model.type.intValue == 1 || model.type.intValue == 2) && model.status.intValue == 1) {
        self.statusLabel.text = @"未开赛";
    } else if ((model.type.intValue == 1 || model.type.intValue == 2) && model.status.intValue == 2) {
        self.statusLabel.text = @"比赛结束";
    }

    if (model.type.intValue == 1) {     // 足球
        if (model.status_up == 1) {
            self.statusLabel.text = @"未开赛";
        } else if (model.status_up == 2) {
            self.statusLabel.text = @"上半场";
        } else if (model.status_up == 3) {
            self.statusLabel.text = @"中场";
        } else if (model.status_up == 4) {
            self.statusLabel.text = @"下半场";
        } else if (model.status_up == 5) {
            self.statusLabel.text = @"加时赛";
        } else if (model.status_up == 7) {
            self.statusLabel.text = @"点球决战";
        } else if (model.status_up == 8) {
            self.statusLabel.text = @"完场";
        } else if (model.status_up == 9) {
            self.statusLabel.text = @"推迟";
        } else if (model.status_up == 10) {
            self.statusLabel.text = @"中断";
        } else if (model.status_up == 11) {
            self.statusLabel.text = @"腰斩";
        } else if (model.status_up == 12) {
            self.statusLabel.text = @"取消";
        } else if (model.status_up == 13) {
            self.statusLabel.text = @"待定";
        }
    } else if (model.type.intValue == 2) {  // 籃球
        if (model.status_up == 1) {
            self.statusLabel.text = @"未开赛";
        } else if (model.status_up == 2) {
            self.statusLabel.text = @"第一节";
        } else if (model.status_up == 3) {
            self.statusLabel.text = @"第一节完";
        } else if (model.status_up == 4) {
            self.statusLabel.text = @"第二节";
        } else if (model.status_up == 5) {
            self.statusLabel.text = @"第二节完";
        } else if (model.status_up == 6) {
            self.statusLabel.text = @"第三节";
        } else if (model.status_up == 7) {
            self.statusLabel.text = @"第三节完";
        } else if (model.status_up == 8) {
            self.statusLabel.text = @"第四节";
        } else if (model.status_up == 9) {
            self.statusLabel.text = @"加时";
        } else if (model.status_up == 10) {
            self.statusLabel.text = @"完场";
        } else if (model.status_up == 11) {
            self.statusLabel.text = @"中断";
        } else if (model.status_up == 12) {
            self.statusLabel.text = @"取消";
        } else if (model.status_up == 13) {
            self.statusLabel.text = @"延期";
        } else if (model.status_up == 14) {
            self.statusLabel.text = @"腰斩";
        } else if (model.status_up == 15) {
            self.statusLabel.text = @"待定";
        }
    }

    self.statusRight.constant = -10;
    //比赛状态：0 开赛中  1 未开赛  2 比赛结束 3 比赛推迟 4 未确定的 5 已取消的
    NSInteger status = model.status.integerValue;
    [self.typeImageView.layer removeAllAnimations];
    [self.dianLabel.layer removeAllAnimations];
    if (status == 0)  {
        [self.typeImageView.layer addAnimation:[CommonTools rotationAnimation_Animation] forKey:@"rotationAnimation"];
        if (model.type.intValue == 1) {
            self.statusRight.constant = 6;
            self.banchangLabel.hidden = NO;
            self.jiaoLabel.hidden = NO;
            self.banchangLabel.text = [NSString stringWithFormat:@"半:%@",model.banchang];
            self.jiaoLabel.text = [NSString stringWithFormat:@"角:%@",model.jiaoqiu];
            self.timeLabel.hidden = NO;
            self.timeLabel.text = model.time;
            self.dianLabel.hidden = NO;
            [self.dianLabel.layer addAnimation:[CommonTools opacityForever_Animation:0.5] forKey:@"opacityForeverAnimation"];
            self.banchangLabelRight.constant = -12;
            if (model.listType == 1) {
                self.banchangLabelRight.constant = 10;
            }
        }else {
            // self.statusLabel.text = @"";
            self.timeLabel.text = @"";
            self.banchangLabel.hidden = YES;
            self.jiaoLabel.hidden = YES;
            self.dianLabel.hidden = YES;
            // BOOL f = [self validateString:model.status_up_name withPattern:@"^[0-9]+$"];
            // if (f == NO) {
            self.statusLabel.text = [NSString stringWithFormat:@"%@ %@",self.statusLabel.text, model.time];
            // }
            self.statusRight.constant = -10;
        }
    }else {
        self.dianLabel.hidden = YES;
        self.timeLabel.text = @"";
        self.banchangLabel.hidden = YES;
        self.jiaoLabel.hidden = YES;
        self.statusRight.constant = -10;
    }
}

// 判斷是否為數字的字串
- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];

    NSAssert(regex, @"Unable to create regular expression");

    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];

    BOOL didValidate = NO;

    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = YES;

    return didValidate;
}

- (void)setupHuoImageView:(LiveListModel *)model {
    if (model.listType == 1) {
        self.huoImageView.hidden = NO;
        self.huoImageView.image = [UIImage imageNamed:@"热门标记"];
        self.huoImageView.animationImages = [SNGlobalShared initialImageArray];
        //动画重复次数
        self.huoImageView.animationRepeatCount = 0;
        //动画执行时间,多长时间执行完动画
        self.huoImageView.animationDuration = 1;
        //开始动画
        [self.huoImageView startAnimating];
        
    }else {
        self.huoImageView.hidden = YES;
        [self.huoImageView stopAnimating];
    }
}

 
- (CGFloat)evaluteWidth:(UILabel *)scoreLabel {
    NSDictionary *textAtt = @{NSFontAttributeName : scoreLabel.font};
    CGSize evaluteLabelSize = [scoreLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGFloat evaluteLabelSizeW = evaluteLabelSize.width + 1;
    return evaluteLabelSizeW;
}
  
- (SNLiveSourcesView *)sourceView {
    if (!_sourceView) {
        _sourceView = [[SNLiveSourcesView alloc] initWithFrame:CGRectMake(0, 65, kScreenWidth-25, self.frame.size.height) withModel:self.model];
        WeakSelf
        _sourceView.sourceWithTag = ^(NSInteger tag) {
            [weakSelf sourceViewDidClick:tag];
        };
        [self.backView addSubview:_sourceView];
    }
    return _sourceView;
}


- (void)sourceViewDidClick:(NSInteger)tag {
    NSMutableArray *cartoonArray = [NSMutableArray array];
    [cartoonArray addObjectsFromArray:self.model.live_urls];
    [cartoonArray addObjectsFromArray:self.model.live_cartoon_url];
    LiveCartoonModel *cartoonModel = cartoonArray[tag];
    if (self.resolutionBtnClicked) {
        self.resolutionBtnClicked(cartoonModel);
    } 
}




@end
