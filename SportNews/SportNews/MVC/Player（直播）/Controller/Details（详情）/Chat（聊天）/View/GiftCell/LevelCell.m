//
//  HairCollectionCellSmall.m
//  safariSty
//
//  Created by MILLMAN on 2015/2/8.
//  Copyright (c) 2015年 MILLMAN. All rights reserved.
//

#import "LevelCell.h"
@interface LevelCell ()

@end
@implementation LevelCell
@synthesize imgView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"LevelCell" owner:self options:nil] objectAtIndex:0];
    if(self) {

    }
    
    return self;
}

-(void)setupModel:(ChatGiftModel *)model imageDic:(NSMutableDictionary *)imageDic {
    self.nameLabel.text = model.name;
    self.voiceLabel.text = [NSString stringWithFormat:@"%@", model.yinlang];

    self.levelImgView.layer.cornerRadius = 8;
    self.levelImgView.clipsToBounds = YES;
    self.levelLabel.text = [NSString stringWithFormat:@"V%ld", (long)[model.level integerValue]];

    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel.userinfo.level >= [model.level integerValue]) {
        self.levelImgView.backgroundColor = [UIColor colorWithHexString:@"#E59442"];
    } else {
        self.levelImgView.backgroundColor = UIColor.lightGrayColor;
    }

    if (imageDic[model.url] != nil) {
        self.imgView.image = [UIImage imageWithData:imageDic[model.url]] ;
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: model.url]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imgView.image = [UIImage imageWithData:data];
                NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                imageDic[model.url] = UIImagePNGRepresentation(self.imgView.image);
                [df setObject:imageDic forKey:@"urlImageDic"];
            });
        });
    }
}

@end
