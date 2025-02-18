//
//  SNMessageEnterTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/2/26.
//

#import <UIKit/UIKit.h>
#import "JCHATChatModel.h"

NS_ASSUME_NONNULL_BEGIN
 
@interface SNMessageEnterTableViewCell : BaseXibTableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) JCHATChatModel                   *message;
@property (nonatomic, strong) NSString *hexColorFromName;
@property (nonatomic, strong) NSString *hexColorBody;
@end

NS_ASSUME_NONNULL_END
