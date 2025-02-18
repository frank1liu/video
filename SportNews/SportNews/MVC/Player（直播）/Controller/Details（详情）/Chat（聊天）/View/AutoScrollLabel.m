//
//  AutoScrollLabel.m
//  AutoScrollLabel
//
//  Created by Brian Stormont on 10/21/09.
//  Copyright 2009 Stormy Productions. 
//
//  Permission is granted to use this code free of charge for any project.
//

#import "AutoScrollLabel.h"
 
@implementation AutoScrollLabel
   
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self commonInit];
    }
    return self;
}
 
- (void)commonInit {
    for (int i=0; i< NUM_LABELS; ++i){
        label[i] = [[UILabel alloc] init];
        label[i].textColor = [UIColor whiteColor];
        label[i].backgroundColor = [UIColor clearColor];
        [self addSubview:label[i]];
    }
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.userInteractionEnabled = NO;
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    //[self scrollAction]; 循环就打开
}
 
- (void)scrollAction {
    self.contentOffset = CGPointMake(0,0);
	[UIView beginAnimations:@"scroll" context:nil];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:6];
    self.contentOffset = CGPointMake(self.width,0);
    //self.contentOffset = CGPointMake(self.width+label[0].width,0); //循环使用
	[UIView commitAnimations];
}
 
- (void)readjustLabels {
    
    [label[0] sizeToFit];
    CGRect frame;
    frame = label[0].frame;
    frame.origin.x = self.width;
    frame.origin.y = 0;
    frame.size.height = self.height;
    label[0].frame = frame;
	
	CGSize size;
	size.width = self.frame.size.width*2;
	size.height = self.frame.size.height;
	self.contentSize = size;
	[self setContentOffset:CGPointMake(0,0) animated:NO];
    [self scrollAction];
     
}
 
- (void)setText:(NSString *)text {
    label[0].text = text;
}

- (NSString *)text {
	return label[0].text;
}


- (void)setTextColor:(UIColor *)color {
    label[0].textColor = color;
}
  
- (void)setFont:(UIFont *)font {
    label[0].font = font;
}

  
@end
