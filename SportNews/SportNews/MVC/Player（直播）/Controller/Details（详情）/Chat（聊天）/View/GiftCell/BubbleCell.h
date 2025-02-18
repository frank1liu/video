//
//  HairCollectionCellSmall.h
//  safariSty
//
//  Created by MILLMAN on 2015/2/8.
//  Copyright (c) 2015年 MILLMAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatGiftModel.h"

@interface BubbleCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIView *baseView;
@property (nonatomic, weak) IBOutlet UIImageView *imgbaseView;
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UIView *levelImgView;
@property (nonatomic, weak) IBOutlet UILabel *levelLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

-(void)setupModel:(ChatGiftModel *)model imageDic:(NSMutableDictionary *)imageDic;

@end
