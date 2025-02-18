//
//  HairCollectionCellSmall.m
//  safariSty
//
//  Created by MILLMAN on 2015/2/8.
//  Copyright (c) 2015年 MILLMAN. All rights reserved.
//

#import "iconCell.h"
@interface iconCell ()

@end
@implementation iconCell
@synthesize imgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"iconCell" owner:self options:nil] objectAtIndex:0];
    if(self) {

    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {

}

@end
