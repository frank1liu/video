//
//  SNGoalNewsTableViewCell.m
//  ceshi
//
//  Created by kkk on 2021/4/7.
//

#import "SNGoalNewsTableViewCell.h"

@interface SNGoalNewsTableViewCell ()



@property(nonatomic, strong) UIView *backView;

@property(nonatomic, strong) UILabel *nameLabel;

 
@end

@implementation SNGoalNewsTableViewCell
 
#pragma mark -- initialization 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SNGoalNewsTableViewCell";
    SNGoalNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SNGoalNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID withType:0];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(NSInteger)type {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = 0;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.backView];
    [self.backView addSubview:self.nameLabel];
}

- (void)setGoalModel:(SNGoalNewsModel *)goalModel {
    _goalModel = goalModel;
    self.backView.x = kScreenWidth;
    if (goalModel.isAnimate) {
        [UIView animateWithDuration:0.35 animations:^{
            self.backView.x = 15;
            [self layoutIfNeeded];
        }];
    }else {
        self.backView.x = 15;
    }
    goalModel.isAnimate = NO;
    self.nameLabel.text = goalModel.title;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth-30, 44)];
        _backView.backgroundColor = randomRGB;
    }
    return _backView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
        _nameLabel.font = [UIFont systemFontOfSize:22];
        _nameLabel.textColor = [UIColor blackColor];;
    }
    return _nameLabel;
}

@end
