//
//  SNDatasFootInjuryTeamTopTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/2/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNDatasFootInjuryTeamTopTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setupTeamName:(NSString *)teamName iconImage:(NSString *)iconStr;

//是不是最顶上的
- (void)cellIsTopOne:(BOOL)isTop;

@end

NS_ASSUME_NONNULL_END
