//
//  SNLiveBasketBallSectionHeaderView.m
//  SportNews
//
//  Created by kkk on 2021/1/20.
//

#import "SNLiveBasketBallSectionHeaderView.h"

@interface SNLiveBasketBallSectionHeaderView ()

@property(nonatomic, strong) NSMutableArray *buttonArray;

@property(nonatomic, strong) NSMutableArray *datasArray;

@property(nonatomic, strong) UIScrollView *contentView;

@property(nonatomic, strong) UIButton *lastButton;

//篮球直播
@property(nonatomic, strong) SNBasketBallResult *resultBasketObj;

@end

@implementation SNLiveBasketBallSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame datasArray:(NSArray *)datasArray{
    self = [super initWithFrame:frame];
    if (self) {
        _datasArray = [datasArray mutableCopy];
        [self setupSubviews];
    }
    return self;
}

- (NSMutableArray *)datasArray {
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)setupSubviews {
    
    UIView *bgBackView = [[UIView alloc] initWithFrame:CGRectMake(12.5, 0, kScreenWidth - 25, 86)];
    bgBackView.backgroundColor = UIColor.whiteColor;
    [bgBackView addRoundedCorners:UIRectCornerTopLeft| UIRectCornerTopRight withRadii:CGSizeMake(13, 13)];
    [self addSubview:bgBackView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textColor = RGB(51, 51, 51);
    titleLabel.text = @"文字直播";
    [bgBackView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgBackView);
        make.top.mas_equalTo(15);
    }];
    
    self.contentView = [[UIScrollView alloc] init];
    self.contentView.clipsToBounds = YES;
    self.contentView.showsHorizontalScrollIndicator = NO;
    [bgBackView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgBackView);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(bgBackView).offset(12.5);
        make.height.mas_equalTo(35);
    }];
    self.contentView.layer.cornerRadius = 35/2;
    self.contentView.contentSize = CGSizeMake(kScreenWidth, 0);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"矩形备份"]];
    [bgBackView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self setupButtons:self.datasArray.count];
}


- (void)reloadDataWithModel:(SNBasketBallResult *)resultBasketObj {
    self.resultBasketObj = resultBasketObj;
    [self setupButtons:resultBasketObj.tlive.count];
}

- (void)setupButtons:(NSInteger)count {
    if (self.buttonArray.count > 0) {
        for (UIButton *button in self.buttonArray) {
            [button removeFromSuperview];
        }
        [self.buttonArray removeAllObjects];
    }
    if (count == 0) {
        return;
    }
    NSArray *first = self.resultBasketObj.tlive.firstObject;
    if (first.count == 0) {
        return;
    }
    NSArray *titleArray = @[@"第一节",@"第二节",@"第三节",@"第四节",@"加时一",@"加时二",@"加时三",@"加时四",@"加时五"];
    CGFloat buttonW = (kScreenWidth -50)/count;
    buttonW = buttonW < 80? 80:buttonW;
    self.contentView.contentSize = CGSizeMake(buttonW*count, 0);
    for (int i = 0; i < count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonW*i, 0, buttonW, 35)];
        button.tag = i;
        button.layer.cornerRadius = button.height/2;
        button.backgroundColor = UIColor.clearColor;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%@",titleArray[i]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        [self.buttonArray addObject:button];
        if (i == 0) {
            button.backgroundColor = RGBA(39, 197, 195,0.1);
            button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
            [button setTitleColor:Blue_Color forState:UIControlStateNormal];
            self.lastButton = button;
        }
        if (i == count - 1) {
            if (self.resultBasketObj.status == 10 && count > 4) {
                [button setTitle:@"完结" forState:UIControlStateNormal];
            }
            [self buttonClicked:button];
        }
    }
}

- (void)buttonClicked:(UIButton *)sender {
    if (sender.tag == self.lastButton.tag) {
        return;
    }
    self.lastButton.backgroundColor = UIColor.clearColor;
    self.lastButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.lastButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    sender.backgroundColor = RGBA(39, 197, 195,0.1);
    sender.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    [sender setTitleColor:Blue_Color forState:UIControlStateNormal];
    
    self.lastButton = sender;
    if (self.buttonClickWithTag) {
        self.buttonClickWithTag(sender.tag);
    }
    [self moveButtonToCenter:sender];
    
}

- (void)moveButtonToCenter:(UIButton *)sender {
    CGPoint point = sender.center;
    CGFloat absoultX = self.contentView.bounds.size.width/2.0;
    if (self.contentView.contentSize.width <= self.contentView.bounds.size.width) return;
    if (point.x > absoultX&&self.contentView.contentSize.width-point.x > absoultX) {
        //判断点击的按钮的中心点X和scroview的内容宽度减去按钮中心X坐标的长度都大于scroview的一般宽度的时候，才开始向中心移动
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.contentOffset = CGPointMake(point.x-absoultX, 0);
        }];
    }
    if (point.x < absoultX) {
        //判断点击按钮的中心X小于scroview一般宽度的时候,设置scoview的偏移量为0；
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.contentOffset = CGPointMake(0, 0);
        }];
    }
    if (self.contentView.contentSize.width-point.x < absoultX) {
        //判断scroview的内容宽度减去点击按钮的中心X的距离小于scroview一半宽度的时候，将scroview滑动到最右边。
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.contentOffset = CGPointMake(self.contentView.contentSize.width-self.contentView.bounds.size.width, 0);
        }];
    }
}


@end
