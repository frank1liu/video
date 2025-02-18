//
//  BaseXibTableViewCell.h
//  EpochStore
//
//  Created by K哥 on 2019/7/25.
//  Copyright © 2019 K哥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseXibTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)evaluteWidth:(UILabel *)label;

@end

NS_ASSUME_NONNULL_END
