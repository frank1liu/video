//
//  SNMessageCell.h
//  SportNews
//
//  Created by 根哥 on 2021/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JCHATChatModel;
@interface SNMessageCell : UITableViewCell

@property (nonatomic, strong) JCHATChatModel                   *message;
@property (nonatomic, strong) NSString *hexColorFromName;
@property (nonatomic, strong) NSString *hexColorBody;
@property (nonatomic, strong) UIButton *btnLevel;
@property (nonatomic, assign) NSInteger level;

+ (UIImage *) getMessageLevelImage:(NSInteger)level;

@end

NS_ASSUME_NONNULL_END
