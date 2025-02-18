//
//  SNExampleTopSelectView.m
//  SportNews
//
//  Created by kkk on 2021/3/10.
//

#import "SNExampleTopSelectView.h"

@interface SNExampleTopSelectView ()

@property(nonatomic, strong) NSMutableArray *buttonArray;
 
@property(nonatomic, strong) UIScrollView *contentView;

@property(nonatomic, strong) UIView *backView;

@property(nonatomic, strong) UIButton *lastButton;

@end

@implementation SNExampleTopSelectView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _marginLeft = 14;
        _marginTop = 4;
        _textColor = [UIColor colorWithHexString:@"#666666"];
        _selectTextColor = Blue_Color;
        _buttonWidth = 66;
        _buttonHeight = 32;
        
        [self setupSubviews];
    }
    return self;
}
 
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)setupSubviews {
    self.contentView = [[UIScrollView alloc] init];
    self.contentView.clipsToBounds = YES;
    self.contentView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.contentView.contentSize = CGSizeMake(kScreenWidth, 0);
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 25, self.height)];
    self.backView = backView;
    backView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    backView.layer.cornerRadius = self.bounds.size.height/2;
    [self.contentView addSubview:backView];
    
}

- (void)reloadDataWithArray:(NSArray *)datasArray {
    if (self.buttonArray.count > 0) {
        for (UIButton *button in self.buttonArray) {
            [button removeFromSuperview];
        }
        [self.buttonArray removeAllObjects];
    }
    if (datasArray.count == 0) {
        return;
    }
    CGFloat buttonW = self.buttonWidth;
    self.contentView.contentSize = CGSizeMake(buttonW*datasArray.count+20+self.marginLeft*2, 0);
    self.backView.width = buttonW*datasArray.count+self.marginLeft*2;
    for (int i = 0; i < datasArray.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.marginLeft+buttonW*i, self.marginTop, buttonW, self.buttonHeight)];
        button.tag = i;
        button.layer.cornerRadius = button.height/2;
        button.backgroundColor = UIColor.clearColor;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%@",datasArray[i]] forState:UIControlStateNormal];
        UIColor *textColor = self.textColor;
        [button setTitleColor:textColor forState:UIControlStateNormal];
        
        [self.backView addSubview:button];
        [self.buttonArray addObject:button];
        if (i == 0) {
            button.backgroundColor = UIColor.whiteColor;
            button.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
            [button setTitleColor:self.selectTextColor forState:UIControlStateNormal];
            self.lastButton = button;
        }
    }
}

- (void)buttonClicked:(UIButton *)sender {
    if (sender.tag == self.lastButton.tag) {
        return;
    }
    self.lastButton.backgroundColor = UIColor.clearColor;
    self.lastButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.lastButton setTitleColor:self.textColor forState:UIControlStateNormal];
    sender.backgroundColor = UIColor.whiteColor;
    sender.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    [sender setTitleColor:Blue_Color forState:UIControlStateNormal];
    self.lastButton = sender;
    
    if (self.clickWithTag) {
        self.clickWithTag(sender.tag);
    }
    if (self.notScroll) {
        return;
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

- (void)setContentViewColor:(UIColor *)contentViewColor{
    self.backView.backgroundColor = contentViewColor;
}

@end
