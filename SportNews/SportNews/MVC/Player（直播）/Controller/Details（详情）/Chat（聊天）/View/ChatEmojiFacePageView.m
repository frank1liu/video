//
//  ChatEmojiFacePageView.m
//  XDET
//
//  Created by zbao huang on 14-8-21.
//  Copyright (c) 2014年 Xiaodou. All rights reserved.
//

#import "ChatEmojiFacePageView.h"
@implementation ChatEmojiFacePageView
@synthesize delegate;
#pragma mark  重写的方法

#define  kItemWidth  ((kScreenWidth - 16)/7)

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView
{
    self.backgroundColor = SRGB(248);
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 216)];
    
    scrollView.pagingEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.delegate=self;
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectZero];
    if([_pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)]){
        [_pageControl setPageIndicatorTintColor:RGBA(125, 220, 219, 0.5)];
        [_pageControl setCurrentPageIndicatorTintColor:Blue_Color];
    }
    [_pageControl addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
    [self addSubview:scrollView];
    [self addSubview:_pageControl];
    [self drawIcons];
    UIImageView * toolBar=[[UIImageView alloc]initWithFrame:CGRectMake(0, 217-37, SCREEN_WIDTH, 37)];
    toolBar.image=[UIImage imageNamed:@"ToolViewBkg_Black_ios7@2x.png"];
    toolBar.userInteractionEnabled=YES;
    [self addSubview:toolBar];
    
//    UIButton * sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    [sendButton setImage:[UIImage imageNamed:@"EmotionsSendBtnGrey_ios7@2x.png"] forState:UIControlStateNormal];
//    sendButton.frame=CGRectMake(SCREEN_WIDTH-70, 0, 70, 37);
//    [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [toolBar addSubview:sendButton];
//    _sendButton=sendButton;
//    
//    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 34)];
//    label.font=[UIFont systemFontOfSize:15];
//    label.textAlignment=NSTextAlignmentCenter;
//    label.textColor=[UIColor darkGrayColor];
//    label.backgroundColor=[UIColor clearColor];
//    label.text=@"发送";
//    [_sendButton addSubview:label];
}

-(void)layoutSubviews
{
    [scrollView setFrame:self.bounds];
    
    CGRect frame;
    frame.size=CGSizeMake(SCREEN_WIDTH, 20);
    frame.origin.x =0;
    frame.origin.y = self.frame.size.height-50;
    _pageControl.frame=frame;
}

#pragma -mark 私有方法
-(CGRect)getFrameForIndex:(int) index
{
    int page,row,list;
    page=index/20;
    row=(index%20)%7;
    list=(index%20)/7;
    return CGRectMake(page*kScreenWidth+row*kItemWidth+5,list*kItemWidth+5, kItemWidth, kItemWidth);
}

-(void)drawIcons
{
    NSString * path=[[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"];
    NSString *facePath = [[NSBundle mainBundle] pathForResource:@"Expression" ofType:@"bundle"];
    _dic=[NSDictionary dictionaryWithContentsOfFile:path];
    NSArray * keys=[_dic allValues];
    int count=(int)[keys count];
    for(int i=0;i<count;i++)
    {
        CGRect rect=[self getFrameForIndex:i];
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=rect;
        NSMutableString * icon=[[NSMutableString alloc]init];
        if(i<10){
           [icon appendFormat:@"f_static_00%d.png",i];
        } else if(i >= 10 && i <= 99) {
          [icon appendFormat:@"f_static_0%d.png",i];
        } else {
            [icon appendFormat:@"f_static_%d.png",i];
        }
        UIImage * faceImage = [UIImage imageWithContentsOfFile:[facePath stringByAppendingPathComponent:icon]] ;
        
        [button addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:faceImage forState:UIControlStateNormal];
        button.tag=i+100;
        [scrollView addSubview:button];
    }
    int page=0;
    if(count%20==0)
        page=count/20;
    else
        page=count/20+1;
    for(int i=0;i<page;i++)
    {
        CGRect rect=CGRectMake(i*kScreenWidth+6*kItemWidth+5,2*(kItemWidth)+5, kItemWidth, kItemWidth);
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"backFace"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"backFaceSelect"] forState:UIControlStateHighlighted];
        button.frame=rect;
        [scrollView addSubview:button];
    }
    
    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*page, self.frame.size.height);
    _pageControl.currentPage=1;
    _pageControl.numberOfPages=page;
    
}

#pragma -mark  响应方法

-(void)iconClick:(UIButton*) button
{
    int index=(int)(button.tag-100);
    NSString * key;
    
    if(index<10){
         key=[NSString stringWithFormat:@"f_static_00%d",index];
    } else if(index >= 10 && index <= 99) {
        key=[NSString stringWithFormat:@"f_static_0%d",index];
    } else {
         key=[NSString stringWithFormat:@"f_static_%d",index];
    }
    NSArray* arrayOfKeys = [_dic allKeysForObject:key];
    NSString * text = [arrayOfKeys firstObject];
    if(delegate&&[delegate respondsToSelector:@selector(emojiPageView:iconClick:)])
        [delegate emojiPageView:self iconClick:text];
}

-(void)deleteClick
{
    if(delegate&&[delegate respondsToSelector:@selector(emojiPageViewDeleteClick:actionBlock:)]){
        [delegate emojiPageViewDeleteClick:self actionBlock:^NSString *(NSString *string) {
            if(![string hasSuffix:@"]"]){
                if ([string length]>1) {
                    return [string substringToIndex:[string length]-1];
                }else{
                    return nil;
                }
            }
            NSRange range=[string rangeOfString:@"[" options:NSBackwardsSearch];
            if(range.location==NSNotFound)
                if ([string length]>1) {
                    return [string substringToIndex:[string length]-1];
                }else{
                    return nil;
                }
                else{
                    NSString * sub=[string substringToIndex:[string length]-1];
                    sub=[sub substringFromIndex:range.location];
                    NSRange  ran=[sub rangeOfString:@"]"];
                    if(ran.location!=NSNotFound)
                        return string;
                    else {
                        string=[string substringToIndex:range.location];
                        return string;
                    }
                }
        }];
    }
}
-(void)pageChange
{
    int page=(int)(_pageControl.currentPage);
    float x=320*page;
    CGPoint point=CGPointMake(x, 0);
    CGRect frame;
    frame.origin=point;
    frame.size=scrollView.frame.size;
    [scrollView scrollRectToVisible:frame animated:YES];
}
-(void)sendButtonClick
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(emojiPageViewSendClick:)]) {
        [self.delegate emojiPageViewSendClick:self];
    }
}

#pragma -mark  委托方法实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    int page=scrollView1.contentOffset.x/320;
    [_pageControl setCurrentPage:page];
    
}

#pragma -mark 接口方法

-(void)canSend
{ 
    self.sendButton.enabled=YES;
    [self.sendButton setImage:[UIImage imageNamed:@"EmotionsSendBtnGrey_ios_sel"] forState:UIControlStateNormal];
}

-(void)cannotSend
{
    self.sendButton.enabled=NO;
    [self.sendButton setImage:[UIImage imageNamed:@"EmotionsSendBtnGrey_ios7"] forState:UIControlStateNormal];
}

-(void)showInView:(UIView *)view withFrame:(CGRect)frame1
{
    self.transform=CGAffineTransformIdentity;
    [view addSubview:self];
    CGRect frame=frame1;
    CGRect beginFrame=CGRectMake(0,view.frame.size.height, 320, 0);
    self.frame=beginFrame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.frame=frame;
    [UIView commitAnimations];
    
}

-(void) showInView:(UIView *)view
{
    [self showInView:view withFrame:self.frame];
}
-(void)hide
{
    [UIView commitAnimations];
    [UIView animateWithDuration:0.25 animations:^{
        self.transform=CGAffineTransformMakeTranslation(0, 216);    } completion:^(BOOL finished) {
            if(finished)
                [self removeFromSuperview];
        }];
}


@end
