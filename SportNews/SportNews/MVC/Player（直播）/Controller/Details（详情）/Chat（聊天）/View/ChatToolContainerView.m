//
//  ChatToolContainerView.m
//  XDET
//
//  Created by zbao huang on 14-8-25.
//  Copyright (c) 2014年 Xiaodou. All rights reserved.
//

#import "ChatToolContainerView.h"

@implementation ChatToolContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
        
        self.camareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.camareBtn.backgroundColor = [UIColor clearColor];
        [self.camareBtn setImage:[UIImage imageNamed:@"icon_camera_normal"] forState:UIControlStateNormal];
        [self.camareBtn setImage:[UIImage imageNamed:@"icon_camera_pressed"] forState:UIControlStateHighlighted];
        self.camareBtn.frame = CGRectMake(35, 10, 50, 50);
        [self.camareBtn addTarget:self action:@selector(btnCameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.camareBtn];
        
        UILabel * camLabe = [[UILabel alloc] initWithFrame:CGRectMake(45, 65, 42, 20)];
        camLabe.backgroundColor = [UIColor clearColor];
        camLabe.font = [UIFont systemFontOfSize:13.0f];
        camLabe.text = @"拍照";
        [self addSubview:camLabe];
        
        self.pickerImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pickerImageBtn.backgroundColor = [UIColor clearColor];
        [self.pickerImageBtn setImage:[UIImage imageNamed:@"icon_add_image_normal"] forState:UIControlStateNormal];
        [self.pickerImageBtn setImage:[UIImage imageNamed:@"icon_add_image_pressed"] forState:UIControlStateHighlighted];
        self.pickerImageBtn.frame = CGRectMake(135, 10, 50, 50);
        [self.pickerImageBtn addTarget:self action:@selector(btnPicAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.pickerImageBtn];
        
        UILabel * imageLabe = [[UILabel alloc] initWithFrame:CGRectMake(145, 65, 42, 20)];
        imageLabe.backgroundColor = [UIColor clearColor];
        imageLabe.font = [UIFont systemFontOfSize:13.0f];
        imageLabe.text = @"图片";
        [self addSubview:imageLabe];
        
        
        self.fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.fileBtn.backgroundColor = [UIColor clearColor];
        [self.fileBtn setImage:[UIImage imageNamed:@"icon_add_file_normal"] forState:UIControlStateNormal];
        [self.fileBtn setImage:[UIImage imageNamed:@"icon_add_file_normal"] forState:UIControlStateHighlighted];
        self.fileBtn.frame = CGRectMake(235, 10, 50, 50);
        [self.fileBtn addTarget:self action:@selector(btnFileAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.fileBtn];
        
        UILabel * fileLabe = [[UILabel alloc] initWithFrame:CGRectMake(245, 65, 42, 20)];
        fileLabe.backgroundColor = [UIColor clearColor];
        fileLabe.font = [UIFont systemFontOfSize:13.0f];
        fileLabe.text = @"文件";
        [self addSubview:fileLabe];
        
    }
    return self;
}


#pragma -mark 事件响应
-(void)btnPicAction:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolTackPic:)]) {
        [self.delegate talkToolTackPic:self];
    }
}
-(void)btnFileAction:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolTackFile:)]) {
        [self.delegate talkToolTackFile:self];
    }
}
-(void)btnCameraAction:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolTackCamera:)]) {
        [self.delegate talkToolTackCamera:self];
    }
}



@end
