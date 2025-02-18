//
//  ChatBottomToolBar.h
//  XDET
//
//  Created by zbao huang on 14-8-21.
//  Copyright (c) 2014年 Xiaodou. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "ChatAudioRecordButton.h"
#import "HPGrowingTextView.h"
#import "ChatEmojiFacePageView.h"
#import "ChatToolContainerView.h"

#define emojiHeight  216


@class ChatBottomToolBar;

@protocol ChatToolBarDelegate <NSObject>

@optional

-(void)talkToolBar:(ChatBottomToolBar*)toolBar sendText:(NSString*)text giftType:(NSInteger)giftType;

-(void)talkToolBar:(ChatBottomToolBar*)toolBar sendGift:(NSString*)text;

-(void)talkToolBar:(ChatBottomToolBar*)toolBar changeHeight:(float)height;

-(void)talkToolBarSelectImage:(ChatBottomToolBar*)toolBar;

-(void)talkToolBarTakeImage:(ChatBottomToolBar*)toolBar;

-(void)talkToolBarPickerFile:(ChatBottomToolBar*)toolBar;

// 1:禮物 2:等級 3:氣泡
-(void)talkToolBar:(ChatBottomToolBar*)toolBar giftType:(NSInteger)giftType giftID:(NSString*)giftID sendGift:(NSString*)text withGifUrl:(NSString*)gifUrl imageUrl:(NSString*)imageUrl;

@end

@interface ChatBottomToolBar : UIView<EmojiPageViewDelegate,HPGrowingTextViewDelegate,ChatToolContainerViewDelegate>

@property (nonatomic,strong) UIView * inputBgView;
//@property (nonatomic,strong) UIImageView * inputBGImageView;

@property(nonatomic,strong) UIButton * btnFace;
@property(nonatomic,strong) UIButton * btnAdd;
@property(nonatomic,strong) UIButton * btnGift;
@property(nonatomic,strong) UIView   * slidePanel1;
@property(nonatomic,strong) UIView   * slidePanel2;
@property(nonatomic,strong) UIView   * slidePanel3;
@property(nonatomic,assign) BOOL       slideFlag;

@property(nonatomic,strong) UIButton * btnKeyboard;
//@property(nonatomic,strong) UIButton * btnSend;
//@property(nonatomic,strong) UIButton * btnVoice;

//@property(nonatomic,strong) ChatAudioRecordButton * recordVoice;
@property(nonatomic,strong) HPGrowingTextView * contentTextView;
@property(nonatomic,strong,readonly) ChatEmojiFacePageView * emojiPageView;
@property(nonatomic,strong,readonly) ChatToolContainerView * containerView;
@property(nonatomic,weak)id<ChatToolBarDelegate>delegate;
@property(nonatomic,strong) UIViewController *parentVC;

@property (nonatomic,assign) BOOL showKeyboard;

-(void)dismissKeyBoard;

- (void)isCanSend:(BOOL)send gameStatus:(NSInteger)gameStatus;

@end
