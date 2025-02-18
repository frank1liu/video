//
//  SNMessageCell.m
//  SportNews
//
//  Created by 根哥 on 2021/2/4.
//

#import "SNMessageCell.h"
#import "AWRichText.h"
#import "JCHATChatModel.h"
#import <MLLabel/NSString+MLExpression.h>
#import <MLLabel/MLLabel.h>

@interface SNMessageCell()
@property (nonatomic, strong) AWRichTextLabel                   *richLabel;
@property (nonatomic, strong) MLExpression          *expression;
@property (nonatomic,strong) MLLabel * contentLabel;

@end
@implementation SNMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self) {
//      [self setupSubviews];
  }
  return self;
}

- (void)setupSubviews{
    
    
}

-(void)prepareForReuse{
    [super prepareForReuse];
    _message = nil;
    _hexColorFromName = nil;
    _hexColorBody = nil;
    [self.btnLevel removeFromSuperview];
    _btnLevel = nil;
    _level = -1;
}

- (void)setMessage:(JCHATChatModel *)message{
    _message = message;
    if (self.richLabel.superview) {
        [self.richLabel removeFromSuperview];
    }
    if (self.btnLevel.superview) {
        [self.btnLevel removeFromSuperview];
        self.level = -1;
    }
    AWRichText *richText = [[AWRichText alloc] init];
    

    //创建名称，文本类型 text和font是必须设置的。
    NSString *name = [NSString stringWithFormat:@"%@：",message.fromName];
//    AWRTTextComponent *nameComp = [[AWRTTextComponent alloc] init]
//    .AWText(name)
//    .AWColor(RGB(38, 74, 137))
//    .AWFont([UIFont systemFontOfSize:12])
//    .AWPaddingLeft(@2);
//    [richText addComponent: nameComp];
    
    if ([CommonTools isBlankString:message.text]) {
        message.text = @" ";
    }
    
    NSString *content = [NSString stringWithFormat:@"%@%@",name ,message.text];

    self.expression = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"faceMap_ch" bundleName:@"Expression"];
    NSMutableAttributedString *attribute = [[content expressionAttributedStringWithExpression:self.expression] mutableCopy];
    [attribute setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:self.hexColorFromName]} range:NSMakeRange(0, name.length)];
    // [attribute setAttributes:@{NSForegroundColorAttributeName:RGB(38, 74, 137)} range:NSMakeRange(name.length, content.length-name.length)];
    @try {
        [attribute setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:self.hexColorBody]} range:NSMakeRange(name.length, content.length-name.length)];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }

    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(kScreenWidth - 80, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    MLLabel *contentLabel = [[MLLabel alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height + 6)];
//    contentLabel.backgroundColor = [UIColor redColor];
    contentLabel.numberOfLines = 0;
//    contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 120;
    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    contentLabel.attributedText = attribute;
    
    ((AWRTViewComponent *)[richText addComponentFromPoolWithType:AWRTComponentTypeView])
      .AWView(contentLabel)
      .AWFont([UIFont systemFontOfSize:14])
      .AWBoundsDepend(@(AWRTAttchmentBoundsDependContent))
      .AWAlignment(@(AWRTAttachmentAlignTop));
    
    //创建内容文本类型 text和font是必须设置的。

//    AWRTTextComponent *contentComp = [[AWRTTextComponent alloc] init]
//    .AWText(content)
//    .AWColor(RGB(51, 51, 51))
//    .AWFont([UIFont systemFontOfSize:12])
//    .AWPaddingLeft(@2);
//    [richText addComponent: contentComp];

    
    //创建label，AWRichTextLabel是UILabel的子类
    AWRichTextLabel *richLabel = [richText createRichTextLabel];
    //请务必设置rtFrame属性，设置后会自动计算frame的尺寸
    //宽度为非0，高度为0表示高度自适应。另外若宽度设置特别大，超出文字内容，最终生成的宽度仍然是以文字内容宽度为准。
    //宽度为0表示单行。
    //系统属性numberOfLines无效
    richLabel.rtFrame = CGRectMake(56, 5, SCREEN_WIDTH - 30, 0);
    richLabel.numberOfLines = 0;
    self.richLabel = richLabel;
    [self.contentView addSubview:richLabel];
    [richText attributedString];
    CGFloat height = richLabel.frame.size.height + 5;
    
    message.contentHeight = height > 28?height:28;


    //self.btnLevel = [[UIButton alloc] initWithFrame:CGRectMake(12, 8, 36, 18.5)];
    self.btnLevel = [[UIButton alloc]init];

    if ([name isEqualToString:@"管理员："]) {
        self.btnLevel.frame = CGRectMake(12, 8, 36+8, 18.5);
        richLabel.rtFrame = CGRectMake(56+8, 5, SCREEN_WIDTH - 30, 0);

        [self.btnLevel setTitle:@"管理员" forState:UIControlStateNormal];
        self.btnLevel.contentMode = UIViewContentModeScaleAspectFit;
        self.btnLevel.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.btnLevel setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.btnLevel setBackgroundImage:[SNMessageCell getMessageLevelImage:0] forState:UIControlStateNormal];
    }
    else if (self.level == 0) {
        self.btnLevel.frame = CGRectMake(12, 8, 36, 18.5);

        [self.btnLevel setTitle:@"遊客" forState:UIControlStateNormal];
        self.btnLevel.contentMode = UIViewContentModeScaleAspectFit;
        // self.btnLevel.titleLabel.text = @"遊客";
        self.btnLevel.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.btnLevel setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.btnLevel setBackgroundImage:[SNMessageCell getMessageLevelImage:self.level] forState:UIControlStateNormal];
    } else {
        richLabel.rtFrame = CGRectMake(80, 5, SCREEN_WIDTH - 30, 0);
        self.btnLevel.frame = CGRectMake(12, 8, 60, 21.5);
        // [self.btnLevel setTitle:@"" forState:UIControlStateNormal];
        [self.btnLevel setBackgroundImage:[SNMessageCell getMessageLevelImage:self.level] forState:UIControlStateNormal];
    }

    [self.contentView addSubview:self.btnLevel];
}

+ (UIImage *) getMessageLevelImage:(NSInteger)level {
    switch (level) {
        case 0:
            return UIImageMake(@"level0bg");      // 遊客
            break;
        case 1:
            return UIImageMake(@"level1");
            break;
        case 2:
            return UIImageMake(@"level2");
            break;
        case 3:
            return UIImageMake(@"level3");
            break;
        case 4:
            return UIImageMake(@"level4");
            break;
        case 5:
            return UIImageMake(@"level5");
            break;
        case 6:
            return UIImageMake(@"level6");
            break;
        case 7:
            return UIImageMake(@"level7");
            break;
        case 8:
            return UIImageMake(@"level8");
            break;
        case 9:
            return UIImageMake(@"level9");
            break;
        case 10:
            return UIImageMake(@"level10");
            break;
        case 11:
            return UIImageMake(@"level11");
            break;
        case 12:
            return UIImageMake(@"level12");
            break;
        case 13:
            return UIImageMake(@"level13");
            break;
        case 14:
            return UIImageMake(@"level14");
            break;
        case 15:
            return UIImageMake(@"level15");
            break;
        case 16:
            return UIImageMake(@"level16");
            break;
        case 17:
            return UIImageMake(@"level17");
            break;
        case 18:
            return UIImageMake(@"level18");
            break;
        case 19:
            return UIImageMake(@"level19");
            break;
        case 20:
            return UIImageMake(@"level20");
            break;
        case 21:
            return UIImageMake(@"level21");
            break;
        case 22:
            return UIImageMake(@"level22");
            break;
        case 23:
            return UIImageMake(@"level23");
            break;
        case 24:
            return UIImageMake(@"level24");
            break;
        case 25:
            return UIImageMake(@"level25");
            break;
        case 26:
            return UIImageMake(@"level26");
            break;
        case 27:
            return UIImageMake(@"level27");
            break;
        case 28:
            return UIImageMake(@"level28");
            break;
        case 29:
            return UIImageMake(@"level29");
            break;
        case 30:
            return UIImageMake(@"level30");
            break;
        case 31:
            return UIImageMake(@"level31");
            break;
        case 32:
            return UIImageMake(@"level32");
            break;
        case 33:
            return UIImageMake(@"level33");
            break;
        case 34:
            return UIImageMake(@"level34");
            break;
        case 35:
            return UIImageMake(@"level35");
            break;
        case 36:
            return UIImageMake(@"level36");
            break;
        case 37:
            return UIImageMake(@"level37");
            break;
        case 38:
            return UIImageMake(@"level38");
            break;
        case 39:
            return UIImageMake(@"level39");
            break;
        case 40:
            return UIImageMake(@"level40");
            break;
        case 41:
            return UIImageMake(@"level41");
            break;
        case 42:
            return UIImageMake(@"level42");
            break;
        case 43:
            return UIImageMake(@"level43");
            break;
        case 44:
            return UIImageMake(@"level44");
            break;
        case 45:
            return UIImageMake(@"level45");
            break;
        case 46:
            return UIImageMake(@"level46");
            break;
        case 47:
            return UIImageMake(@"level47");
            break;
        case 48:
            return UIImageMake(@"level48");
            break;
        case 49:
            return UIImageMake(@"level49");
            break;
        case 50:
            return UIImageMake(@"level50");
            break;
        case 51:        // 遊客的fromName
            //return @"264A89";
            break;
        default:
            break;
    }
    // return @"#FFB587";
    return UIImageMake(@"level0bg");
}

//
//
//+ (NSAttributedString*)expressionAttributedStringWithString:(id)string expression:(MLExpression*)expression {
//
//
//    NSAttributedString *attributedString = nil;
//    if ([string isKindOfClass:[NSString class]]) {
//        attributedString = [[NSAttributedString alloc]initWithString:string];
//    }else{
//        attributedString = string;
//    }
//
//    if (attributedString.length<=0) {
//        return attributedString;
//    }
//
//    NSMutableAttributedString *resultAttributedString = [NSMutableAttributedString new];
//
//    //处理表情
//    NSArray *results = [expression.expressionRegularExpression matchesInString:attributedString.string
//                                                            options:NSMatchingWithTransparentBounds
//                                                              range:NSMakeRange(0, [attributedString length])];
//    //遍历表情，然后找到对应图像名称，并且处理
//    NSUInteger location = 0;
//    for (NSTextCheckingResult *result in results) {
//        NSRange range = result.range;
//        NSAttributedString *subAttrStr = [attributedString attributedSubstringFromRange:NSMakeRange(location, range.location - location)];
//        //先把非表情的部分加上去
//        [resultAttributedString appendAttributedString:subAttrStr];
//
//        //下次循环从表情的下一个位置开始
//        location = NSMaxRange(range);
//
//        NSAttributedString *expressionAttrStr = [attributedString attributedSubstringFromRange:range];
//        NSString *imageName = expression.expressionMap[expressionAttrStr.string];
//        if (imageName.length>0) {
//            //加个表情到结果中
//            UIImage *image = nil;
//            if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
//                NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:expression.bundleName withExtension:nil]];
//                image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
//            }else{
//                NSString *imagePath = [expression.bundleName stringByAppendingPathComponent:imageName];
//                image = [UIImage imageNamed:imagePath];
//            }
//
//            MLTextAttachment *textAttachment = [MLTextAttachment textAttachmentWithLineHeightMultiple:kExpressionLineHeightMultiple imageBlock:^UIImage *(CGRect imageBounds, NSTextContainer *textContainer, NSUInteger charIndex, MLTextAttachment *textAttachment) {
//                return image;
//            } imageAspectRatio:image.size.width/image.size.height];
//
//            NSMutableAttributedString *attachmentAttributedString = [[NSAttributedString attributedStringWithAttachment:textAttachment]mutableCopy];
//            [expressionAttrStr enumerateAttributesInRange:NSMakeRange(0, expressionAttrStr.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//                if (attrs.count>0&&range.length==expressionAttrStr.length) {
//                    [attachmentAttributedString addAttributes:attrs range:NSMakeRange(0, attachmentAttributedString.length)];
//                }
//            }];
//
//            [resultAttributedString appendAttributedString:attachmentAttributedString];
//        }else{
//            //找不到对应图像名称就直接加上去
//            [resultAttributedString appendAttributedString:expressionAttrStr];
//        }
//    }
//
//    if (location < [attributedString length]) {
//        //到这说明最后面还有非表情字符串
//        NSRange range = NSMakeRange(location, [attributedString length] - location);
//        NSAttributedString *subAttrStr = [attributedString attributedSubstringFromRange:range];
//        [resultAttributedString appendAttributedString:subAttrStr];
//    }
//
//    return resultAttributedString;
//}

@end
