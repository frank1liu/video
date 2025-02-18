//
//  ChatEmojiFacePageView.h
//  XDET
//
//  Created by zbao huang on 14-8-21.
//  Copyright (c) 2014年 Xiaodou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmojiPageViewDelegate;

@interface ChatEmojiFacePageView : UIView<UIScrollViewDelegate>

{
    UIScrollView * scrollView;
    UIPageControl * _pageControl;
    NSDictionary * _dic;
}
@property(nonatomic,retain)id<EmojiPageViewDelegate> delegate;

@property(nonatomic,readonly) UIButton * sendButton;

-(void) showInView:(UIView *)view;

-(void)showInView:(UIView *)view withFrame:(CGRect)frame1;

-(void) hide;

-(void)canSend;

-(void)cannotSend;

@end


@protocol EmojiPageViewDelegate <NSObject>
@optional
/*
 * 当点击图标调用
 *@param  iconString   图标的内容
 */
-(void)emojiPageView:(ChatEmojiFacePageView*)emojiPageView  iconClick:(NSString*)iconString;
/*
 *点击删除图标调用
 */
-(void)emojiPageViewDeleteClick:(ChatEmojiFacePageView*)emojiPageView actionBlock:(NSString*(^)(NSString* string))block;
/*
 *发送
 */
-(void)emojiPageViewSendClick:(ChatEmojiFacePageView*)emojiPageView;
@end
