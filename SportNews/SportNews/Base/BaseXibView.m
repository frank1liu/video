//
//  BaseXibView.m
//  EpochStore
//
//  Created by K哥 on 2019/7/22.
//  Copyright © 2019 K哥. All rights reserved.
//

#import "BaseXibView.h"

@implementation BaseXibView

{
    CGRect _myFrame;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
        _myFrame = frame;
        self.frame = _myFrame;
        self.backgroundColor = UIColor.clearColor;

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.frame = _myFrame;
}

@end
