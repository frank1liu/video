//
//  SNStatisticalPlayerDataCell.m
//  SportNews
//
//  Created by 根哥 on 2021/1/26.
//

#import "SNStatisticalPlayerDataCell.h"
#import "JJStockView.h"

@interface SNStatisticalPlayerDataCell ()<StockViewDataSource,StockViewDelegate>

@property (nonatomic, strong) UIView *bgView;

@property(nonatomic,readwrite,strong) JJStockView *stockView;

@end


@implementation SNStatisticalPlayerDataCell

#pragma mark -- initialization 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
   if (self) {
       self.selectionStyle = UITableViewCellSelectionStyleNone;
       self.backgroundColor = UIColor.clearColor;
       [self setupSubviews];
   }
   return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.stockView];
    
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.bottom.equalTo(self).offset(-10);
        make.right.equalTo(self).offset(-12.5);
    }];
    
    [self.stockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView).offset(-13);
    }];

}

- (void)setStatisticalModel:(SNStatisticalModel *)statisticalModel {
    _statisticalModel = statisticalModel;
    [self.stockView reloadStockView];
}

#pragma mark - Stock DataSource
- (NSUInteger)countForStockView:(JJStockView*)stockView{
    if (self.section == 0) {
        return self.statisticalModel.awayPlayers.count;
    }
    return self.statisticalModel.homePlayers.count;
}

//左边竖排标题
- (UIView*)titleCellForStockView:(JJStockView*)stockView atRowPath:(NSUInteger)row{
    SNStatisticalPlayerDataModel *playerModel = self.section == 0? self.statisticalModel.awayPlayers[row]:self.statisticalModel.homePlayers[row];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    backView.backgroundColor = row % 2 == 0 ? [UIColor colorWithRed:205.0f/255.0 green:205.0f/255.0 blue:205.0f/255.0 alpha:0.08]:[UIColor whiteColor];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 103, 40)];
    label.text = [NSString stringWithFormat:@"%@",playerModel.name];
    label.textColor = [UIColor colorWithHexString:@"#666666"];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    [backView addSubview:label];
    return backView;
}

//内容
- (UIView*)contentCellForStockView:(JJStockView*)stockView atRowPath:(NSUInteger)row{
    
    SNStatisticalPlayerDataModel *playerModel = self.section == 0? self.statisticalModel.awayPlayers[row]:self.statisticalModel.homePlayers[row];
    UIView* bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60*14, 40)];
    bg.backgroundColor = row % 2 == 0 ? [UIColor colorWithRed:205.0f/255.0 green:205.0f/255.0 blue:205.0f/255.0 alpha:0.08]:[UIColor whiteColor];
//    NSArray *titleArray = @[@"首发",@"时间",@"得分",@"投篮",@"三分",@"罚球",@"前篮板",@"后篮板",@"总篮板",@"助攻",@"抢断",@"盖帽",@"失误",@"犯规"];
    for (int i = 0; i < 14; i++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(i * 60, 0, 60, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [bg addSubview:label];
        switch (i) {
            case 0:
                label.text = playerModel.isTiBu == 1? @"否":@"是";
                break;
            case 1:
                label.text = playerModel.time;
                break;
            case 2:
                label.text = playerModel.defen;
                break;
            case 3:
                label.text = playerModel.count;
                break;
            case 4:
                label.text = playerModel.threeCount;
                break;
            case 5:
                label.text = playerModel.faCount;
                break;
            case 6:
                label.text = playerModel.jGLanban;
                break;
            case 7:
                label.text = playerModel.fSLanban;
                break;
            case 8:
                label.text = playerModel.zongLanban;
                break;
            case 9:
                label.text = playerModel.zhugong;
                break;
            case 10:
                label.text = playerModel.qiangduan;
                break;
            case 11:
                label.text = playerModel.gaimao;
                break;
            case 12:
                label.text = playerModel.shiwu;
                break;
            case 13:
                label.text = playerModel.fangui;
                break;
            default:
                break;
        }
    }
    return bg;
}

#pragma mark - Stock Delegate
- (CGFloat)heightForCell:(JJStockView*)stockView atRowPath:(NSUInteger)row{
    return 40.0f;
}

//左上角
- (UIView*)headRegularTitle:(JJStockView*)stockView{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
    label.text = @"球员";
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    [backView addSubview:label];
    return backView;
}

//顶部标题
- (UIView*)headTitle:(JJStockView*)stockView {
    
    NSArray *titleArray = @[@"首发",@"时间",@"得分",@"投篮",@"三分",@"罚球",@"前篮板",@"后篮板",@"总篮板",@"助攻",@"抢断",@"盖帽",@"失误",@"犯规"];
    UIView* bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60*titleArray.count, 40)];
    bg.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < titleArray.count; i++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(i * 60, 0, 60, 40)];
        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        [bg addSubview:label];
    }
    return bg;
}

- (CGFloat)heightForHeadTitle:(JJStockView*)stockView{
    return 40.0f;
}

- (void)didSelect:(JJStockView*)stockView atRowPath:(NSUInteger)row{
    NSLog(@"DidSelect Row:%ld",row);
}

#pragma mark - Button Action

- (void)buttonAction:(UIButton*)sender{
    NSLog(@"Button Row:%ld",sender.tag);
}

#pragma mark - Get

- (JJStockView*)stockView{
    if(!_stockView){
    _stockView = [JJStockView new];
    _stockView.dataSource = self;
    _stockView.delegate = self;
    }
    return _stockView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(12.5, 0, kScreenWidth-25, 200)];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.cornerRadius = 13;
        _bgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0,5);
        _bgView.layer.shadowOpacity = 0.5;
    }
    return _bgView;
}

@end
