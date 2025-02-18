//
//  SNLiveSourcesView.m
//  cess
//
//  Created by kkk on 2021/6/4.
//

#import "SNLiveSourcesView.h"

@implementation SNLiveSourcesView


- (instancetype)initWithFrame:(CGRect)frame withModel:(LiveListModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubViews:model];
    }
    return self;
}

- (void)setupSubViews:(LiveListModel *)model {
    
    NSMutableArray *cartoonArray = [NSMutableArray array];
    [cartoonArray addObjectsFromArray:model.live_urls];
    [cartoonArray addObjectsFromArray:model.live_cartoon_url];
    //创建各个Button
    NSInteger currentRight = 0; // 记录当前Btn的right（右边）
    NSInteger currentBottom = 0; // 记录当前btn的bottom（底部）
    NSMutableArray *btnMaxArray = [NSMutableArray array];
    NSMutableArray *buttonArray = [NSMutableArray array];
    CGFloat originX = 20; //初始X
    CGFloat totalWidth = self.frame.size.width; //总宽
    CGFloat magin = 10; //按钮之间的间距
    CGFloat imageWidth = 30; //图片宽度
    UIFont *font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
    for (int i = 0; i < cartoonArray.count; i++) {
        LiveCartoonModel *cartoonModel = cartoonArray[i];
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn.enabled = cartoonModel.status;
        Btn.tag = i;
        [Btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:Btn];
        Btn.frame = CGRectMake(currentRight + originX, currentBottom, 80, 25);
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
            if (model.live_cartoon_url.count > 0) {
                if (model.status.integerValue == 0) {
                    Btn.enabled = YES;
                }else {
                    Btn.enabled = NO;
                }
            }
        }
        // 更新每个Btn的frame
        CGRect frame = CGRectMake(Btn.frame.origin.x, Btn.frame.origin.y, size.width + imageWidth, size.height + 15);
        Btn.frame = frame;
        // 设置btn的属性
        Btn.titleLabel.font = font;
        Btn.backgroundColor = [UIColor clearColor];
        [Btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [Btn setTitleColor:[UIColor colorWithHexString:@"#BBBBBB"] forState:UIControlStateDisabled];
        [Btn setTitle:[NSString stringWithFormat:@" %@",cartoonModel.name] forState:UIControlStateNormal];
        if (cartoonModel.index == 1) {
            [Btn setImage:[UIImage imageNamed:@"中文标清-lv"] forState:UIControlStateNormal];
        }else if (cartoonModel.index == 2) {
            [Btn setImage:[UIImage imageNamed:@"高清-lv"] forState:UIControlStateNormal];
        }else if (cartoonModel.index == 3) {
            [Btn setImage:[UIImage imageNamed:@"中文标清-lv"] forState:UIControlStateNormal];
        }else if (cartoonModel.index == 4) {
            [Btn setImage:[UIImage imageNamed:@"标清"] forState:UIControlStateNormal];
        }else if (cartoonModel.index == 0) {
            if ([cartoonModel.name containsString:@"动画"] && ![cartoonModel.url containsString:@".m3u8"]) {
                [Btn setImage:[UIImage imageNamed:@"动画直播"] forState:UIControlStateNormal];
            }else {
                [Btn setImage:[UIImage imageNamed:@"主播"] forState:UIControlStateNormal];
            }
        }
        Btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:Btn];
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
     CGRect frame = self.frame;
    frame.size.height = currentBottom;
    self.frame = frame;
    self.contentHeight = currentBottom;
    
}

- (void)btnClickAction:(UIButton *)sender {
    if (self.sourceWithTag) {
        self.sourceWithTag(sender.tag);
    }
}



@end
