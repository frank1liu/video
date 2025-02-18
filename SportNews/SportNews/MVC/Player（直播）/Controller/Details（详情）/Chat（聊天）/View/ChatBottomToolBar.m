//
//  ChatBottomToolBar.m
//  XDET
//
//  Created by zbao huang on 14-8-21.
//  Copyright (c) 2014年 Xiaodou. All rights reserved.
//

#import "ChatBottomToolBar.h"
#import "GiftCell.h"
#import "LevelCell.h"
#import "bubbleCell.h"
#import "ChatGiftModel.h"
#import "VoiceWebViewController.h"
#import "GiftLoginView.h"
#import "GiftRegisterView.h"
#import "SNUserWebViewController.h"

typedef NS_ENUM(NSInteger,ToolBarEventType) {
    ToolBarEventTypeFace,
    ToolBarEventTypeKeyboard,
    ToolBarEventTypeEdit,
    ToolBarEventTypeAdd,
    ToolBarEventTypeGift
};

static NSString * const CellIdentifier1 = @"GiftCell";
static NSString * const CellIdentifier2 = @"LevelCell";
static NSString * const CellIdentifier3 = @"BubbleCell";

@interface ChatBottomToolBar () <UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat contentOffX;
    NSString * tmpContent;
}

@property (nonatomic, strong) UIButton          *maskBtn;
@property (nonatomic, strong) UICollectionView  *collectionView;

@property(nonatomic, assign) BOOL delaySend;

@property (nonatomic, strong) UIView   *labBaseView;
@property (nonatomic, strong) UILabel  *lab1;
@property (nonatomic, strong) UILabel  *lab2;
@property (nonatomic, strong) UILabel  *lab3;
@property (nonatomic, strong) UILabel  *lab4;
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, assign) NSInteger selectedSubIndex;

@property (nonatomic, strong) NSMutableArray  *giftDataAry;
@property (nonatomic, strong) NSMutableArray  *levelDataAry;
@property (nonatomic, strong) NSMutableArray  *bubbleDataAry;
@property (nonatomic, strong) NSMutableArray  *normalDataAry;

@property (nonatomic, strong) NSMutableDictionary  *urlImageDic;
@property (nonatomic, strong) NSUserDefaults *df;
@property (nonatomic, strong) LoginUserModel *loginModel;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) GiftLoginView *loginView;
@property (nonatomic, strong) GiftRegisterView *registerView;

@end

@implementation ChatBottomToolBar
@synthesize labBaseView;
@synthesize lab1;
@synthesize lab2;
@synthesize lab3;
@synthesize lab4;
@synthesize selectedIndex;
@synthesize selectedSubIndex;
@synthesize urlImageDic;
@synthesize df;
@synthesize loginModel;
@synthesize sendLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.selectedIndex = 1;
        self.selectedSubIndex = -1;
        self.showKeyboard = NO;
        self.backgroundColor = UIColor.whiteColor;
        self.contentTextView.contentMode = UIViewContentModeScaleToFill;
        self.inputBgView = [[UIView alloc]init];
        self.inputBgView.layer.cornerRadius = 20;
        self.inputBgView.backgroundColor = RGB(247, 247, 247);
        [self addSubview:self.inputBgView];

        // 偵測是否有登錄
        loginModel = [UserModelTool loginModel];

        //表情
        self.btnFace = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnFace setImage:[UIImage imageNamed:@"talk_face"] forState:UIControlStateNormal];
        [self.btnFace setImage:[UIImage imageNamed:@"talk_face_sel"] forState:UIControlStateHighlighted];
        self.btnFace.tag = ToolBarEventTypeFace;
        
        [self.btnFace addTarget:self action:@selector(toolBarAction:) forControlEvents:UIControlEventTouchUpInside];

        [self.inputBgView addSubview:self.btnFace];
        
        //添加
        self.btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnAdd setImage:[UIImage imageNamed:@"发送"] forState:UIControlStateNormal];
        _btnAdd.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        _btnAdd.backgroundColor = Blue_Light_Color;
        _btnAdd.enabled = NO;
        _btnAdd.layer.cornerRadius = 14;
        self.btnAdd.tag = ToolBarEventTypeAdd;

        [self.btnAdd addTarget:self action:@selector(toolBarAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnAdd];

        //禮物
        self.btnGift = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnGift setImage:[UIImage imageNamed:@"giftBtn"] forState:UIControlStateNormal];
        _btnGift.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        _btnGift.backgroundColor = UIColor.clearColor;
        _btnGift.enabled = YES;
        self.btnGift.tag = ToolBarEventTypeGift;
        [self.btnGift addTarget:self action:@selector(toolBarAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnGift];

        //键盘
        self.btnKeyboard = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnKeyboard.backgroundColor = [UIColor clearColor];
        [self.btnKeyboard setImage:[UIImage imageNamed:@"talk_keyboard"] forState:UIControlStateNormal];
        [self.btnKeyboard setImage:[UIImage imageNamed:@"talk_keyboard_sel"] forState:UIControlStateHighlighted];
        [self.btnKeyboard addTarget:self action:@selector(toolBarAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.inputBgView addSubview:self.btnKeyboard];
        self.btnKeyboard.hidden = YES;
        self.btnKeyboard.tag = ToolBarEventTypeKeyboard;

        //消息输入框
        self.contentTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectZero];
        self.contentTextView.backgroundColor = [UIColor clearColor];
        self.contentTextView.minHeight = 30;
        self.contentTextView.minNumberOfLines = 1;
        self.contentTextView.maxNumberOfLines = 40;
        self.contentTextView.delegate = self;
        self.contentTextView.isScrollable = YES;
        self.contentTextView.returnKeyType = UIReturnKeyDone;
        self.contentTextView.contentMode = UIViewContentModeScaleToFill;
        self.contentTextView.contentInset = UIEdgeInsetsMake(0, 2, 0, 2); 
        self.contentTextView.placeholder = @"说点东西吧...";
        self.contentTextView.tag = ToolBarEventTypeEdit;
     
        [self.inputBgView addSubview:self.contentTextView];

        // 上升窗
        self.slidePanel1 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        self.slidePanel2 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        self.slidePanel3 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        self.slidePanel1.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        self.slidePanel2.backgroundColor = [UIColor colorWithHexString:@"#303033"];
        self.slidePanel3.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        self.slidePanel2.layer.cornerRadius = 14;
        self.slidePanel2.layer.maskedCorners = kCALayerMinXMinYCorner|kCALayerMaxXMinYCorner;
        self.slidePanel2.clipsToBounds = YES;
        [self.slidePanel2 addSubview: [self getCategoryTextView]];
        [self.slidePanel2 addSubview:[self getVoiceText]];
        [self.slidePanel2 addSubview:[self getGiveView]];
        [self.slidePanel1 addSubview:self.slidePanel2];
        [self.slidePanel1 addSubview:self.slidePanel3];
        [[UIApplication sharedApplication].keyWindow addSubview:self.slidePanel1];
        [self.slidePanel1 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toolBarGiftAction)];
        [self.slidePanel3 addGestureRecognizer:tap];

        // collection view
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // flowLayout.itemSize = CGSizeMake(120, 120);
        // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 46, SCREEN_WIDTH, 258) collectionViewLayout:flowLayout];

        UINib *nib1 = [UINib nibWithNibName:CellIdentifier1 bundle:nil];
        UINib *nib2 = [UINib nibWithNibName:CellIdentifier2 bundle:nil];
        UINib *nib3 = [UINib nibWithNibName:CellIdentifier3 bundle:nil];

        [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:CellIdentifier1];
        [self.collectionView registerNib:nib2 forCellWithReuseIdentifier:CellIdentifier2];
        [self.collectionView registerNib:nib3 forCellWithReuseIdentifier:CellIdentifier3];

        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = UIColor.clearColor;

        [self.slidePanel2 addSubview: self.collectionView];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
         
        [self.inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-8-xBottomHeight-emojiHeight);
            make.right.equalTo(self.btnAdd.mas_left).offset(-10);
        }];
        
        [self.btnFace mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inputBgView).offset(8);
            make.centerY.equalTo(self.inputBgView).offset(0);
            make.size.mas_equalTo(CGSizeMake(34, 34));
        }];
        [self.btnKeyboard mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.btnFace);
            make.size.equalTo(self.btnFace);
        }];

        [self.btnGift mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.btnAdd.mas_right).offset(4);
            make.right.equalTo(self).offset(-12);
            make.bottom.equalTo(self).offset(-10.5-xBottomHeight-emojiHeight);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(35);
        }];

        [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.inputBgView.mas_right).offset(4);
            make.right.equalTo(self.btnGift.mas_left).offset(-8);
            make.bottom.equalTo(self).offset(-10.5-xBottomHeight-emojiHeight);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(35);
        }];

        [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btnFace.mas_right).offset(8);
            make.right.equalTo(self.inputBgView).offset(-5);
            make.bottom.equalTo(self.inputBgView).offset(-4);
            make.top.equalTo(self.inputBgView).offset(5);
        }];
        
        [self addSubview:self.maskBtn];
        self.maskBtn.hidden = YES;
        [self.maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];

        if (loginModel != nil) {
            [self initData];
        } else {
            self.loginView = [[GiftLoginView alloc] init];
            self.registerView = [[GiftRegisterView alloc] init];
            self.loginView.delegate = (id)self;
            self.registerView.delegate = (id)self;
            self.slidePanel2.backgroundColor = UIColor.clearColor;
            self.slidePanel1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            self.slidePanel3.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        }
    }
    
    return self;
}

- (void)initData {
    self.df = [NSUserDefaults standardUserDefaults];
    self.giftDataAry = [NSMutableArray new];
    self.levelDataAry = [NSMutableArray new];
    self.bubbleDataAry = [NSMutableArray new];

    NSArray *gifts = [self unarchiveGiftData];
    if (gifts != nil) {
        self.normalDataAry = [NSMutableArray arrayWithArray: gifts];
    } else {
        self.normalDataAry = [NSMutableArray new];
    }

    NSDictionary *dic = [df dictionaryForKey:@"urlImageDic"];
    if (dic != nil) {
        self.urlImageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    } else {
        self.urlImageDic = [NSMutableDictionary new];
    }

    [self requestData];
}

-(void)didMoveToSuperview {
    
}

- (void)toolBarAction:(UIButton *)sender{
    switch (sender.tag) {
        case ToolBarEventTypeFace: //表情
            [self btnFaceAction:sender];
            break;
        case ToolBarEventTypeKeyboard: //键盘
            [self btnKeyboardAction:sender];
            break;
        case ToolBarEventTypeEdit: //编辑
            break;
        case ToolBarEventTypeAdd:  //发送
            [self btnSendAction:sender];
            break;
        case ToolBarEventTypeGift: //發送禮物
            [self toolBarGiftAction];
            break;
    }
    
}

- (void)toolBarGiftAction {
    if (loginModel == nil) {
        if (self.slideFlag == NO) {
            [self ChangeToLogin:1];
        }
    } else {
        [self.loginView removeFromSuperview];
        [self.registerView removeFromSuperview];
    }
    if (self.slideFlag == NO) {
        CGFloat delay = 0.0;
        if (self.showKeyboard) {
            delay = 0.3;
            [self dismissKeyBoard];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.slidePanel1.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, -SCREEN_HEIGHT);
                if (self.loginModel == nil) {
                    self.slidePanel2.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, -400);
                    self.slidePanel3.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-400);
                } else {
                    self.slidePanel2.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, -380);
                    self.slidePanel3.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-380);
                }
            } completion:^(BOOL finished) {
                self.slideFlag = YES;
            }];
        });
    } else {
        [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.slidePanel1.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
            self.slidePanel2.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
            self.slidePanel3.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        } completion:^(BOOL finished) {
            self.slideFlag = NO;
            if (self.loginModel == nil) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginPhonePasswordDismiss" object:nil userInfo:nil];
            }
        }];
    }
}

- (void)ChangeToLogin:(NSInteger)index {
    [self.registerView removeFromSuperview];
    [self.slidePanel2 addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.slidePanel2);
    }];
    self.slidePanel2.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, -400);
    self.slidePanel3.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-400);
}

- (void)ChangeToRegister:(NSInteger)index {
    [self.loginView removeFromSuperview];
    [self.slidePanel2 addSubview:self.registerView];
    [self.registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.slidePanel2);
    }];
    self.slidePanel2.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, -520);
    self.slidePanel3.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-520);
}

- (void)MoveKeyboardUp:(NSInteger)type {
    if (type == 1) {
        self.slidePanel2.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, -630);
        self.slidePanel3.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-630);
    } else {
        self.slidePanel2.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, -744);
        self.slidePanel3.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-744);
    }
}

- (void)MoveKeyboardDown:(NSInteger)type {
    if (type == 1) {
        self.slidePanel2.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, -400);
        self.slidePanel3.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-400);
    } else {
        self.slidePanel2.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, -520);
        self.slidePanel3.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-520);
    }
}

- (void)LoginSuccessMoveView {
    loginModel = [UserModelTool loginModel];
    [self toolBarGiftAction];
    self.slidePanel1.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    self.slidePanel2.backgroundColor = [UIColor colorWithHexString:@"#303033"];
    self.slidePanel3.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    [self initData];
}

- (void)RegisterSuccessMoveView {
    [self LoginSuccessMoveView];
}

- (UIView *)getCategoryTextView {
    labBaseView = [[UIView alloc]initWithFrame:CGRectMake(18, 20, 260, 42)];
    labBaseView.backgroundColor = UIColor.clearColor;
    lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 46, 16)];
    lab1.textColor = Blue_Color;
    lab1.font = [UIFont systemFontOfSize:20];
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.tag = 1001;
    [lab1 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGiftAction:)];
    [lab1 addGestureRecognizer:tap1];
    lab1.text = @"礼物";
    lab2 = [[UILabel alloc]initWithFrame:CGRectMake(48, 0, 46, 16)];
    lab2.textColor = UIColor.whiteColor;
    lab2.font = [UIFont systemFontOfSize:15];
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.tag = 1002;
    [lab2 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLevelAction:)];
    [lab2 addGestureRecognizer:tap2];
    lab2.text = @"等级";
    lab3 = [[UILabel alloc]initWithFrame:CGRectMake(48*2, 0, 46, 16)];
    lab3.textColor = UIColor.whiteColor;
    lab3.font = [UIFont systemFontOfSize:15];
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.tag = 1003;
    [lab3 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBubbleAction:)];
    [lab3 addGestureRecognizer:tap3];
    lab3.text = @"气泡";
    lab4 = [[UILabel alloc]initWithFrame:CGRectMake(48*3, 0, 46, 16)];
    lab4.textColor = UIColor.whiteColor;
    lab4.font = [UIFont systemFontOfSize:15];
    lab4.textAlignment = NSTextAlignmentCenter;
    lab4.tag = 1004;
    [lab4 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNormalAction:)];
    [lab4 addGestureRecognizer:tap4];
    lab4.text = @"常用";
    [labBaseView addSubview:lab1];
    [labBaseView addSubview:lab2];
    [labBaseView addSubview:lab3];
    [labBaseView addSubview:lab4];
    return labBaseView;
}

- (UILabel *)getVoiceText {
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 320, 80, 16)];
    lab.textColor = Blue_Color;
    lab.font = [UIFont systemFontOfSize:15];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.tag = 525;
    [lab setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toVoiceMission)];
    [lab addGestureRecognizer:tap];
    lab.text = @"获音浪 >";
    return lab;
}

- (void)toVoiceMission {
    [self toolBarGiftAction];
//    VoiceWebViewController *web = [[VoiceWebViewController alloc]initWithNibName:@"VoiceWebViewController" bundle:nil];
//    // AppDelegate *app = (id)[UIApplication sharedApplication].delegate;
//    [self.parentVC.navigationController pushViewController:web animated:YES];
    SNUserWebViewController *VC = [[SNUserWebViewController alloc] init];
    //VC.url = [NSString stringWithFormat:@"%@user/info",BaseUrl];
    VC.url = @"https://kzbbckjl.com/user/mission";
    [self.parentVC.navigationController pushViewController:VC animated:YES];
}

- (UIView *)getGiveView {
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, 308, 100, 40)];
    v.layer.cornerRadius = 20;
    v.clipsToBounds = YES;
    v.backgroundColor = Blue_Color;
    [v setUserInteractionEnabled: YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector((sendGift:))];
    [v addGestureRecognizer:tap];
    sendLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 100, 20)];
    sendLabel.textColor = UIColor.whiteColor;
    sendLabel.font = [UIFont systemFontOfSize:17];
    sendLabel.textAlignment = NSTextAlignmentCenter;
    sendLabel.tag = 1222;
    sendLabel.text = @"赠送";
    [v addSubview:sendLabel];
    return v;
}

- (void)sendGift:(UITapGestureRecognizer *)sender {
    if (selectedIndex == 1 && self.selectedSubIndex >= 0) {
        ChatGiftModel *model = self.giftDataAry[self.selectedSubIndex];
        if (![self isContainModel:model]) {
            [self.normalDataAry addObject:model];
            [self archiveGiftData:self.normalDataAry];
        }
        [self sendAction:1 giftModel:model];
    } else if (selectedIndex == 2 && self.selectedSubIndex >= 0) {
        ChatGiftModel *model = self.levelDataAry[self.selectedSubIndex];
        if (loginModel.userinfo.level < [model.level integerValue]) {
            [MBProgressHUD showSuccess:@"等级, 音浪不足" toView:nil];
            return;
        }
        if (![self isContainModel:model]) {
            [self.normalDataAry addObject:model];
            [self archiveGiftData:self.normalDataAry];
        }
        [self sendAction:2 giftModel:model];
    } else if (selectedIndex == 3 && self.selectedSubIndex >= 0) {
        ChatGiftModel *model = self.bubbleDataAry[self.selectedSubIndex];
        if (loginModel.userinfo.level < [model.level integerValue]) {
            selectedSubIndex = -1;
            [self.collectionView reloadData];
            [MBProgressHUD showSuccess:@"未达到设置等级" toView:nil];
            return;
        }
        if (![self isContainModel:model]) {
            [self.normalDataAry addObject:model];
            [self archiveGiftData:self.normalDataAry];
        }
        [self sendAction:3 giftModel:model];
    } else {        // 呈現常用
        ChatGiftModel *model = self.normalDataAry[self.selectedSubIndex];
        if ([model.type intValue] == 0) {
            [self sendAction:1 giftModel:model];
        } else if ([model.type intValue] == 1) {
            ChatGiftModel *model = self.levelDataAry[self.selectedSubIndex];
            if (loginModel.userinfo.level < [model.level integerValue]) {
                [MBProgressHUD showSuccess:@"等级, 音浪不足" toView:nil];
                return;
            }
            [self sendAction:2 giftModel:model];
        } else if ([model.type intValue] == 2) {
            if (loginModel.userinfo.level < [model.level integerValue]) {
                selectedSubIndex = -1;
                [self.collectionView reloadData];
                [MBProgressHUD showSuccess:@"未达到设置等级" toView:nil];
                return;
            }
            [self sendAction:3 giftModel:model];
        }
    }
}

- (BOOL)isContainModel:(ChatGiftModel *)model {
    for (ChatGiftModel *normal in self.normalDataAry) {
        if ([normal.url isEqualToString:model.url]) {
            return YES;
        }
    }
    return NO;
}

- (void)sendAction:(NSInteger)giftType giftModel:(ChatGiftModel *)giftModel {
    if (giftType == 3) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:giftModel._9file]];
            [self->df setObject:data forKey:@"9fileImage"];
        });
        [self.df setObject:giftModel._9file forKey:@"9file"];
        [self.df setObject:giftModel._9fileBg forKey:@"9fileBg"];
        [self.df setObject:giftModel.giftID forKey:@"9fileId"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:@"设置成功" toView:nil];
        });
        NSDictionary *param = @{
            @"uid":loginModel.uid,
            @"bobbleId": giftModel.giftID
        };
        
//        if ([giftModel.giftID isEqualToString:@"2"]) {
//            loginModel.userinfo.bobbleFrontColor = @"#C16565";
//            [UserModelTool save:loginModel];
//        } else if ([giftModel.giftID isEqualToString:@"3"]) {
//            loginModel.userinfo.bobbleFrontColor = @"#BC7248";
//            [UserModelTool save:loginModel];
//        } else if ([giftModel.giftID isEqualToString:@"4"]) {
//            loginModel.userinfo.bobbleFrontColor = @"#55687E";
//            [UserModelTool save:loginModel];
//        }

        loginModel.userinfo.bobbleFrontColor = giftModel.bubbleFrontColor;
        [UserModelTool save:loginModel];

        [KYApiHttpTool GET:URL_SendBubbleGift withParams:param success:^(NSDictionary * _Nonnull response) {
            NSLog(@"[Adam: %@]", response);
        } failure:^(NSError * _Nonnull error) {

        }];
    } else {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:giftType: giftID:sendGift:withGifUrl:imageUrl:)]) {
            [self.delegate talkToolBar:self giftType:giftType giftID:giftModel.giftID sendGift:giftModel.name withGifUrl:giftModel.gifUrl imageUrl:giftModel.url];
        }
    }
    [self.collectionView reloadData];
    [self toolBarGiftAction];
}

- (void)tapEditAction {
    
}

#pragma -mark 事件响应
-(void)btnFaceAction:(id)sender {
    [self showEmojiPageView];
    self.btnKeyboard.hidden = NO;
     
    self.btnFace.hidden = YES;
}

-(void)btnKeyboardAction:(id)sender {
    [self beginEdit];
}

-(void)btnSendAction:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:sendText:giftType:)]) {
        [self.delegate talkToolBar:self sendText:self.contentTextView.text giftType:-1];
        self.contentTextView.text=@"";
        self.delaySend = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.delaySend = NO;
            if ([self.contentTextView.text length] > 0) {
                self.btnAdd.enabled = YES;
                [self.emojiPageView canSend];
            }else{
                self.btnAdd.enabled = NO;
                [self.emojiPageView cannotSend];
            }
        });
    }
}
-(void)tackImageAction:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBarTakeImage:)]) {
        [self.delegate talkToolBarTakeImage:self];
    }
}
-(void)selectImageAction:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBarSelectImage:)]) {
        [self.delegate talkToolBarSelectImage:self];
    }
}

-(void)showEmojiPageView{
    
    self.showKeyboard = YES;
    if (_emojiPageView == nil) {

        _emojiPageView=[[ChatEmojiFacePageView alloc] initWithFrame:CGRectZero];
        _emojiPageView.delegate=self;
        _emojiPageView.userInteractionEnabled = YES;
        _emojiPageView.multipleTouchEnabled = YES;
        [self addSubview:_emojiPageView];
        [_emojiPageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-xBottomHeight);
            make.left.and.right.mas_equalTo(0);
            make.height.mas_equalTo(emojiHeight);
        }];
    }
    _emojiPageView.alpha = 1;
    _emojiPageView.hidden = NO;
    if (tmpContent != nil && tmpContent.length > 0) {
        _contentTextView.text = tmpContent;
    }
    self.contentTextView.hidden=NO;
    [self.contentTextView resignFirstResponder];

    [UIView animateWithDuration:0.25 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:changeHeight:)]) {
        [self.delegate talkToolBar:self changeHeight:-(emojiHeight+self.frame.size.height)];
    }
}

-(void)showContainerView{
    
    self.showKeyboard = YES;
    if (tmpContent != nil && tmpContent.length > 0) {
        _contentTextView.text = tmpContent;
    }
    self.contentTextView.hidden = NO;
    [self.contentTextView resignFirstResponder];
    self.btnKeyboard.hidden = NO;
    self.btnFace.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-emojiHeight);
        }];
    }];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:changeHeight:)]) {
        [self.delegate talkToolBar:self changeHeight:-(emojiHeight+self.frame.size.height)];
    }
}

#pragma -mark 回调
//改变键盘高度
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (growingTextView.frame.size.height - height);
    NSLog(@"ChangeHeigh height = %f",height);
    NSLog(@"diff height = %f",diff);
    NSLog(@"growingTextView height = %f",growingTextView.frame.size.height);
    WeakSelf;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(MAX(56, (weakSelf.frame.size.height-diff)));
    }];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:changeHeight:)]) {
        [self.delegate talkToolBar:self changeHeight:self.superview.frame.size.height-self.frame.origin.y];
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:sendText:giftType:)]) {
            [self.delegate talkToolBar:self sendText:self.contentTextView.text giftType:-1];
            self.contentTextView.text=@"";
            tmpContent = @"";
        }
        return NO;
    }

    return YES;
}

-(void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    if (self.delaySend) {
        return;
    }
    if ([growingTextView.text length]>0) { 
        self.btnAdd.enabled = YES;
        [_emojiPageView canSend];
    }else{
        self.btnAdd.enabled = NO;
        [_emojiPageView cannotSend];
    }
}

-(void)beginEdit {
  
    [UIView animateWithDuration:0.1 animations:^{
        self.emojiPageView.alpha = 0;
    }];
    self.contentTextView.hidden=NO;
    self.btnFace.hidden = NO;
    self.btnAdd.hidden = NO;
    self.btnKeyboard.hidden = YES;
    [self.contentTextView becomeFirstResponder];
    
}


#pragma mark -
-(void)dismissKeyBoard{
    if (!self.showKeyboard) {
        return;
    }
    self.showKeyboard = NO;
    //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
    [self.contentTextView resignFirstResponder];
    self.btnKeyboard.hidden=YES;
    self.btnAdd.hidden = NO;
    self.btnFace.hidden = NO;
    self.emojiPageView.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(emojiHeight);
        }];
    }];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:changeHeight:)]) {
        [self.delegate talkToolBar:self changeHeight:self.frame.size.height];
    }
}

#pragma mark -
- (void)inputKeyboardWillShow:(NSNotification *)notification {
    
    self.showKeyboard = YES;
    self.btnKeyboard.hidden=YES;
    self.btnAdd.hidden = NO;
    self.btnFace.hidden = NO;
    // [self.btnGift setUserInteractionEnabled:NO];
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:animationTime animations:^{
        if (!self || !self.superview) {
            return;
        }
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-keyBoardFrame.size.height+emojiHeight+xBottomHeight - (IPHONE_X ? (20) : 0));
        }];
    }];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:changeHeight:)]) {
        [self.delegate talkToolBar:self changeHeight:keyBoardFrame.size.height+self.frame.size.height];
    }
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {
    self.btnFace.hidden = NO;
    self.btnKeyboard.hidden = YES;
    [self.btnGift setUserInteractionEnabled: YES];
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        if (!self || !self.superview) {
            return;
        }
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(emojiHeight);
        }];
    }];

}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)emojiPageView:(ChatEmojiFacePageView*)emojiPageView  iconClick:(NSString*)iconString
{
    NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.contentTextView.text];
    [faceString appendString:iconString];
    self.contentTextView.text = faceString;
}

- (void)emojiPageViewDeleteClick:(ChatEmojiFacePageView*)emojiPageView actionBlock:(NSString*(^)(NSString* string))block {
    self.contentTextView.text=block(self.contentTextView.text);
}

- (void)emojiPageViewSendClick:(ChatEmojiFacePageView *)emojiPageView
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:sendText:giftType:)]) {
        [self.delegate talkToolBar:self sendText:self.self.contentTextView.text giftType:-1];
        self.self.contentTextView.text=nil;
    }
}

- (void)talkToolTackPic:(ChatToolContainerView*)containerView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(talkToolBarSelectImage:)]) {
        [self.delegate talkToolBarSelectImage:self];
    }
    //    [self dismissKeyBoard];
}

-(void)talkToolTackFile:(ChatToolContainerView*)containerView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(talkToolBarPickerFile:)]) {
        [self.delegate talkToolBarPickerFile:self];
    }
    //    [self dismissKeyBoard];
}
-(void)talkToolTackCamera:(ChatToolContainerView *)containerView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(talkToolBarTakeImage:)]) {
        [self.delegate talkToolBarTakeImage:self];
    }
    //    [self dismissKeyBoard];
}

- (UIButton *)maskBtn {
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc]init];
        _maskBtn.backgroundColor = [UIColor clearColor];
    }
    return _maskBtn;
}

- (void)isCanSend:(BOOL)send gameStatus:(NSInteger)gameStatus {
    self.maskBtn.hidden = send;
    if (gameStatus == 2) {      // 比賽結束不能發言
        self.maskBtn.hidden = NO;
        self.contentTextView.placeholder = @"赛事已结束不能发言";
        return;
    }
    if (send) {
        self.contentTextView.placeholder = @"说点东西吧...";
    }else {
        self.contentTextView.placeholder = @"比赛未开始不能发言";
    }
}

// collection delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (selectedIndex == 1) {
        return self.giftDataAry.count;
    } else if (selectedIndex == 2) {
        return  self.levelDataAry.count;
    } else if (selectedIndex == 3) {
        return self.bubbleDataAry.count;
    } else {
        return self.normalDataAry.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (selectedIndex == 1) {
        return [self configGiftCell:collectionView indexPath:indexPath isNormal:NO];
    } else if (selectedIndex == 2) {
        return [self configLevelCell:collectionView indexPath:indexPath isNormal:NO];
    } else if (selectedIndex == 3) {
        return [self configBubblelCell:collectionView indexPath:indexPath isNormal:NO];
    } else {            // 呈現常用
        ChatGiftModel *model = self.normalDataAry[indexPath.row];
        if ([model.type longLongValue] == 0) {
            return [self configGiftCell:collectionView indexPath:indexPath isNormal:YES];
        } else if ([model.type longLongValue] == 1) {
            return [self configLevelCell:collectionView indexPath:indexPath isNormal:YES];
        } else if ([model.type longLongValue] == 2) {
            return [self configBubblelCell:collectionView indexPath:indexPath isNormal:YES];
        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedIndex == 4) {
        ChatGiftModel *model = self.normalDataAry[indexPath.row];
        if (![model._9file isEqualToString:@""]) {
            sendLabel.text = @"设置";
        } else {
            sendLabel.text = @"赠送";
        }
    }
    if (selectedSubIndex == indexPath.row) {
        if (selectedIndex == 3) {
            if ([self.df objectForKey:@"9file"] != nil) {
                [self.df removeObjectForKey:@"9file"];
                [self.df removeObjectForKey:@"9fileBg"];
                [self.df removeObjectForKey:@"9fileImage"];
                [MBProgressHUD showSuccess:@"取消设置" toView:nil];
            }
        }
        selectedSubIndex = -1;
    } else {
        selectedSubIndex = indexPath.row;
    }
    [self.collectionView reloadData];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5,10,5,10); // 定義每個section的四邊間距 (上，左，下，右)
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

- (GiftCell *)configGiftCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath isNormal:(BOOL)isNormal  {
    GiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier1 forIndexPath:indexPath];

    if (!isNormal) {
        ChatGiftModel *model = self.giftDataAry[indexPath.row];
        [cell setupModel:model imageDic:urlImageDic];
    } else {
        ChatGiftModel *model = self.normalDataAry[indexPath.row];
        [cell setupModel:model imageDic:urlImageDic];
    }

    cell.baseView.backgroundColor = [UIColor colorWithHexString:@"#303033"];
    [cell.imgbaseView setHidden:YES];

    if (selectedSubIndex == -1) {
        cell.baseView.backgroundColor = [UIColor colorWithHexString:@"#303033"];
        [cell.imgbaseView setHidden:YES];
    } else if (selectedSubIndex == indexPath.row) {
        // cell.baseView.backgroundColor = [UIColor colorWithHexString:@"#F6BD33"];
        [cell.imgbaseView setHidden:NO];
    }

    return cell;
}

- (LevelCell *)configLevelCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath isNormal:(BOOL)isNormal  {
    LevelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier2 forIndexPath:indexPath];

    if (!isNormal) {
        ChatGiftModel *model = self.levelDataAry[indexPath.row];
        [cell setupModel:model imageDic:urlImageDic];
    } else {
        ChatGiftModel *model = self.normalDataAry[indexPath.row];
        [cell setupModel:model imageDic:urlImageDic];
    }

    cell.baseView.backgroundColor = [UIColor colorWithHexString:@"#303033"];
    [cell.imgbaseView setHidden:YES];

    if (selectedSubIndex == -1) {
        cell.baseView.backgroundColor = [UIColor colorWithHexString:@"#303033"];
        [cell.imgbaseView setHidden:YES];
    } else if (selectedSubIndex == indexPath.row) {
        // cell.baseView.backgroundColor = [UIColor colorWithHexString:@"#F6BD33"];
        [cell.imgbaseView setHidden:NO];
    }

    return cell;
}

- (BubbleCell *)configBubblelCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath isNormal:(BOOL)isNormal  {
    BubbleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier3 forIndexPath:indexPath];

    if (!isNormal) {
        ChatGiftModel *model = self.bubbleDataAry[indexPath.row];
        [cell setupModel:model imageDic:urlImageDic];
    } else {
        ChatGiftModel *model = self.normalDataAry[indexPath.row];
        [cell setupModel:model imageDic:urlImageDic];
    }

    cell.baseView.backgroundColor = [UIColor colorWithHexString:@"#303033"];
    [cell.imgbaseView setHidden:YES];

    if (selectedSubIndex == -1) {
        cell.baseView.backgroundColor = [UIColor colorWithHexString:@"#303033"];
        [cell.imgbaseView setHidden:YES];
    } else if (selectedSubIndex == indexPath.row) {
        // cell.baseView.backgroundColor = [UIColor colorWithHexString:@"#F6BD33"];
        [cell.imgbaseView setHidden:NO];
    }

    if (!isNormal) {
        ChatGiftModel *model = self.bubbleDataAry[indexPath.row];
        if ([model._9file isEqualToString:[self.df objectForKey:@"9file"]]) {
            [cell.imgbaseView setHidden:NO];
        }
    }

    return cell;
}

- (void)requestData {
    [KYApiHttpTool GET:URL_GetGift withParams:@{@"GiftType" : @"0"} success:^(NSDictionary * _Nonnull response) {
        [self.giftDataAry removeAllObjects];
        for (NSDictionary *d in response[@"data"]) {
            ChatGiftModel *model = [ChatGiftModel new];
            model.level = [NSString stringWithFormat:@"%ld", [d[@"gift_level"] longValue]];
            model.name  = d[@"gift_name"];
            model.url   = d[@"gift_static_url"];
            model.type  = [NSString stringWithFormat:@"%ld", [d[@"gift_type"] longValue]];
            model.giftID = [NSString stringWithFormat:@"%ld", [d[@"id"] longValue]];
            model.yinlang = [NSString stringWithFormat:@"%ld音浪", [d[@"gift_yinlang"] longValue]];
            model.gifUrl  = d[@"gift_trends_url"];
            model._9file  = @"";
            model.bubbleFrontColor = @"";
            [self.giftDataAry addObject:model];
        }
        [self.collectionView reloadData];
        [KYApiHttpTool GET:URL_GetGift withParams:@{@"GiftType" : @"1"} success:^(NSDictionary * _Nonnull response) {
            [self.levelDataAry removeAllObjects];
            for (NSDictionary *d in response[@"data"]) {
                ChatGiftModel *model = [ChatGiftModel new];
                model.level = [NSString stringWithFormat:@"%ld", [d[@"gift_level"] longValue]];
                model.name  = d[@"gift_name"];
                model.url   = d[@"gift_static_url"];
                model.type  = [NSString stringWithFormat:@"%ld", [d[@"gift_type"] longValue]];
                model.giftID = [NSString stringWithFormat:@"%ld", [d[@"id"] longValue]];
                model.yinlang = [NSString stringWithFormat:@"%ld音浪", [d[@"gift_yinlang"] longValue]];
                model.gifUrl  = d[@"gift_trends_url"];
                model._9file  = @"";
                model.bubbleFrontColor = @"";
                [self.levelDataAry addObject:model];
            }
            [KYApiHttpTool GET:URL_BubbleGift withParams:nil success:^(NSDictionary * _Nonnull response) {
                [self.bubbleDataAry removeAllObjects];
                for (NSDictionary *d in response[@"data"]) {
                    ChatGiftModel *model = [ChatGiftModel new];
                    model.level = [NSString stringWithFormat:@"%ld", [d[@"bobble_level"] longValue]];
                    model.name  = d[@"bobble_name"];
                    model.url   = d[@"bobble_specimen_url"];
                    model.type  = @"2";
                    model.giftID = [NSString stringWithFormat:@"%ld", [d[@"id"] longValue]];
                    model.yinlang = @"33";
                    model.gifUrl  = @"";
                    model._9file  = d[@"bobble_background_android_url"];
                    model._9fileBg  = d[@"bobble_background_url"];
                    model.bubbleFrontColor = d[@"bobble_front_color"];
                    [self.bubbleDataAry addObject:model];
                }
            } failure:^(NSError * _Nonnull error) {

            }];
        } failure:^(NSError * _Nonnull error) {

        }];
    } failure:^(NSError * _Nonnull error) {

    }];
}

- (void)tapGiftAction:(UITapGestureRecognizer *)sender {
    if (selectedIndex == 1) {
        return;
    }
    lab1.font = [UIFont systemFontOfSize:20];
    lab2.font = [UIFont systemFontOfSize:15];
    lab3.font = [UIFont systemFontOfSize:15];
    lab4.font = [UIFont systemFontOfSize:15];
    lab1.textColor = Blue_Color;
    lab2.textColor = UIColor.whiteColor;
    lab3.textColor = UIColor.whiteColor;
    lab4.textColor = UIColor.whiteColor;
    sendLabel.text = @"赠送";
    selectedIndex = 1;
    selectedSubIndex = -1;
    UILabel *lab = (UILabel *)[self.slidePanel2 viewWithTag:525];
    lab.text = @"获音浪 >";
    [self.collectionView reloadData];
}

- (void)tapLevelAction:(UITapGestureRecognizer *)sender {
    if (selectedIndex == 2) {
        return;
    }
    lab1.font = [UIFont systemFontOfSize:15];
    lab2.font = [UIFont systemFontOfSize:20];
    lab3.font = [UIFont systemFontOfSize:15];
    lab4.font = [UIFont systemFontOfSize:15];
    lab1.textColor = UIColor.whiteColor;
    lab2.textColor = Blue_Color;
    lab3.textColor = UIColor.whiteColor;
    lab4.textColor = UIColor.whiteColor;
    sendLabel.text = @"赠送";
    selectedIndex = 2;
    selectedSubIndex = -1;
    UILabel *lab = (UILabel *)[self.slidePanel2 viewWithTag:525];
    lab.text = @"去升级 >";
    [self.collectionView reloadData];
}

- (void)tapBubbleAction:(UITapGestureRecognizer *)sender {
    if (selectedIndex == 3) {
        return;
    }
    lab1.font = [UIFont systemFontOfSize:15];
    lab2.font = [UIFont systemFontOfSize:15];
    lab3.font = [UIFont systemFontOfSize:20];
    lab4.font = [UIFont systemFontOfSize:15];
    lab1.textColor = UIColor.whiteColor;
    lab2.textColor = UIColor.whiteColor;
    lab3.textColor = Blue_Color;
    lab4.textColor = UIColor.whiteColor;
    sendLabel.text = @"设置";
    selectedIndex = 3;
    selectedSubIndex = -1;
    UILabel *lab = (UILabel *)[self.slidePanel2 viewWithTag:525];
    lab.text = @"去升级 >";
    [self.collectionView reloadData];
}

- (void)tapNormalAction:(UITapGestureRecognizer *)sender {
    if (selectedIndex == 4) {
        return;
    }
    lab1.font = [UIFont systemFontOfSize:15];
    lab2.font = [UIFont systemFontOfSize:15];
    lab3.font = [UIFont systemFontOfSize:15];
    lab4.font = [UIFont systemFontOfSize:20];
    lab1.textColor = UIColor.whiteColor;
    lab2.textColor = UIColor.whiteColor;
    lab3.textColor = UIColor.whiteColor;
    lab4.textColor = Blue_Color;
    sendLabel.text = @"赠送";
    selectedIndex = 4;
    selectedSubIndex = -1;
    UILabel *lab = (UILabel *)[self.slidePanel2 viewWithTag:525];
    lab.text = @"去升级 >";
    [self.collectionView reloadData];
}

- (void)archiveGiftData:(NSMutableArray *)giftAry {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:giftAry];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Gift"];
}

- (NSArray *)unarchiveGiftData {
    NSData *giftsData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Gift"];
    NSArray *gifts = [NSKeyedUnarchiver unarchiveObjectWithData:giftsData];
    return gifts;
}

@end
