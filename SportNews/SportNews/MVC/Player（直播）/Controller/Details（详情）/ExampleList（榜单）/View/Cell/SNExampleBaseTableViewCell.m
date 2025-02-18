//
//  SNExampleBaseTableViewCell.m
//  SportNews
//
//  Created by 根哥 on 2021/3/10.
//

#import "SNExampleBaseTableViewCell.h"
#import "SNTeamRankCell.h"
#import "SNExamplePlayerRankCell.h"
#import "SNPlayerDefenCell.h"
#import "SNTeamRankFenQuCell.h"

@implementation SNExampleBaseTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView exampleModel:(SNExampleBaseModel *)model{
    NSString *reuseCellId = model.reuseCellId;
    SNExampleBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    if (cell == nil) {
        Class cls = NSClassFromString(reuseCellId);
        if (!cls) {
            return [[SNPlayerDefenCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCellId];
        }
        cell = [[cls alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCellId];
        
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}

- (void)configureModelData:(SNExampleBaseModel *)model{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
