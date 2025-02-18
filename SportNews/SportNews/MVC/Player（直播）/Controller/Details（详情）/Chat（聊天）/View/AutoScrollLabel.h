//
//  AutoScrollLabel.h
//  AutoScrollLabel
//
//  Created by Brian Stormont on 10/21/09.
//  Copyright 2009 Stormy Productions. All rights reserved.
//
//  Permission is granted to use this code free of charge for any project.
//

#import <UIKit/UIKit.h>

#define NUM_LABELS 1


@interface AutoScrollLabel : UIScrollView <UIScrollViewDelegate>{
	UILabel *label[NUM_LABELS];
}

// normal UILabel properties
@property(nonatomic,retain) UIColor *textColor;
@property(nonatomic, retain) UIFont *font;

- (void)readjustLabels;
- (void)setText: (NSString *) text;
 
 


@end
