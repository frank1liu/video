//
//  ChatToolContainerView.h
//  XDET
//
//  Created by zbao huang on 14-8-25.
//  Copyright (c) 2014年 Xiaodou. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ChatToolContainerView;

@protocol ChatToolContainerViewDelegate <NSObject>

-(void)talkToolTackCamera:(ChatToolContainerView*)containerView;
-(void)talkToolTackPic:(ChatToolContainerView*)containerView;
-(void)talkToolTackFile:(ChatToolContainerView*)containerView;

@end


@interface ChatToolContainerView : UIView

@property (nonatomic,strong) UIButton * camareBtn;
@property (nonatomic,strong) UIButton * pickerImageBtn;
@property (nonatomic,strong) UIButton * fileBtn;
@property(nonatomic,weak)id<ChatToolContainerViewDelegate>delegate;

@end
