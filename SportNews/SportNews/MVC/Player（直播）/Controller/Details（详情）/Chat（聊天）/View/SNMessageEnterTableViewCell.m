//
//  SNMessageEnterTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/2/26.
//

#import "SNMessageEnterTableViewCell.h"

@implementation SNMessageEnterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 5;
}

- (void)setMessage:(JCHATChatModel *)message{
    _message = message;
      
    if (message.contentType == 10) {
        self.contentLabel.text = message.text;
        self.contentLabel.textColor = [UIColor colorWithHexString:@"#E6B95E"];
        self.backView.backgroundColor = RGB(255, 222, 150);
        return;
    }
    
    self.backView.backgroundColor = RGB(39, 197, 195);
    NSString *content = [NSString stringWithFormat:@" %@ ",message.fromName];
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@"欢迎"];
    NSDictionary * firstAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]};
    [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
        
    NSMutableAttributedString *secondPart = [[NSMutableAttributedString alloc] initWithString:content];
    NSDictionary * secondAttributes = @{NSForegroundColorAttributeName:Blue_Color};
    [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
    
    NSMutableAttributedString *thirdPart = [[NSMutableAttributedString alloc] initWithString:@"进入聊天室"];
    NSDictionary * thirdAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]};
    [thirdPart setAttributes:thirdAttributes range:NSMakeRange(0,thirdPart.length)];

    [firstPart appendAttributedString:secondPart];
    [firstPart appendAttributedString:thirdPart];
       
    self.contentLabel.attributedText = firstPart;

}

@end
