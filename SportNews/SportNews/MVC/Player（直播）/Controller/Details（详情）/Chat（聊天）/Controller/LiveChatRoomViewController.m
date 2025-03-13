//
//  LiveChatRoomViewController.m
//  SportNews
//
//  Created by kkk on 2021/1/16.
//

#import "LiveChatRoomViewController.h"
#import "SNChatRemindAuthView.h"
#import "JCHATChatModel.h" 
#import "ChatBottomToolBar.h"
#import "SNMessageCell.h"
#import "UITableView+Scroll.h"
#import "AutoScrollLabel.h"
#import "SNMessageEnterTableViewCell.h"
#import "BarrageManager.h"
#import <NIMSDK/NIMSDK.h>
#import "QrcodeCell.h"
#import "GiftMsgCell.h"
#import "GiftBubbleCell.h"
#import "GiftBubble2Cell.h"
#import "SWNinePatchImageFactory.h"
#import "TalkBaseViewController.h"
#import <MLLabel/NSString+MLExpression.h>
#import "SNUserWebViewController.h"

#define maxOnlineCount 1000

extern NSString *talkWebUrl;

@interface LiveChatRoomViewController ()<ChatToolBarDelegate,UITableViewDataSource,UITableViewDelegate,NIMChatManagerDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) NSMutableArray                   *dataSource;
@property (nonatomic, strong) ChatBottomToolBar                *chatToolBar;

//顶部的
@property(nonatomic, strong) UIView *backView;
@property (nonatomic , strong) AutoScrollLabel *scrollLabel;
@property(nonatomic, strong) UILabel *countLabel;
@property (nonatomic , strong) UIButton *loginBtn;
@property (nonatomic , strong) UIView *topView;

//底部有新消息
@property (nonatomic , strong) UIButton *newsBtn;

@property(nonatomic, assign) BOOL isGettingRoomId;

@property(nonatomic, assign) BOOL isHaveDraggTop;

//进入聊天是成功了
@property(nonatomic, assign) BOOL isEnterSuccess;
//正在进入聊天室
@property(nonatomic, assign) BOOL isEnteringRoom;

@property (nonatomic,strong) NSTimer *timer;

@property(nonatomic, assign) NSInteger countOnline;

//当前的num
@property(nonatomic, assign) NSInteger currentNum;

@property (nonatomic,strong) UIImageView *bannerImageView;

@property (nonatomic,strong) UIImage *imgQr;
@property (nonatomic,strong) UILabel *labTitle;
@property (nonatomic,strong) UILabel *labContent;
@property (nonatomic,strong) UILabel *labAddressIos;
@property(nonatomic, assign) BOOL hasQrcodeData;
@property (nonatomic, strong) NSUserDefaults *df;
@property (nonatomic, strong) UIView *talkBaseView;
// @property (nonatomic, strong) TalkBaseViewController *talkBaseVC;
@property (nonatomic, strong) SNUserWebViewController *talkWebVC;

@end

@implementation LiveChatRoomViewController
@synthesize df;

static NSString *cellIdentifier = @"MessageCell";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTalkBaseView) name:@"ShowTalkBaseView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTalkBaseView) name:@"HideTalkBaseView" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollToBottom:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.chatToolBar dismissKeyBoard];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowTalkBaseView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HideTalkBaseView" object:nil];
}
 
- (void)viewDidLoad {
    [super viewDidLoad];

    self.talkBaseView = [[UIView alloc]initWithFrame:CGRectZero];
    self.talkBaseView.backgroundColor = UIColor.clearColor;

    // self.talkBaseVC = [[TalkBaseViewController alloc]initWithNibName:@"TalkBaseViewController" bundle:nil];
//    self.talkWebVC = [[SNUserWebViewController alloc]init];
//    self.talkWebVC.url = talkWebUrl;

    self.hasQrcodeData = YES;

    [self getQRcodeInfo];

    [self setupScrollView];
    
    [self setupComponentView];
      
    [self initTimer];
    
    [self setupParams];
    
    [self getYXRoomID];

    self.imgQr = [[UIImage alloc]init];
    self.labTitle = [[UILabel alloc]init];
    self.labContent = [[UILabel alloc]init];
    self.labAddressIos = [[UILabel alloc]init];

    self.df = [NSUserDefaults standardUserDefaults];

//    self.bannerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.messageTableView.height+30, SCREEN_WIDTH, 114)];
//    self.bannerImageView.image = [UIImage imageNamed:@"card"];
//    self.bannerImageView.contentMode = UIViewContentModeScaleToFill;
//    [self.view addSubview:self.bannerImageView];
}

- (void)showTalkBaseView {
    [self hideTalkBaseView];
    self.talkWebVC = nil;
    self.talkWebVC = [[SNUserWebViewController alloc]init];
    self.talkWebVC.url = talkWebUrl;
    [self.view addSubview:self.talkBaseView];
    self.talkBaseView.backgroundColor = UIColor.yellowColor;
    [self addChildViewController:self.talkWebVC];
    self.talkWebVC.view.frame = self.talkBaseView.bounds;
    [self.talkBaseView addSubview:self.talkWebVC.view];
    [self.view bringSubviewToFront:self.talkBaseView];
    [self.talkWebVC setWebViewSize:CGRectMake(0, 0, kScreenWidth, self.talkBaseView.frame.size.height)];
}

- (void)hideTalkBaseView {
    [self.talkWebVC willMoveToParentViewController:nil];
    [self.talkWebVC.view removeFromSuperview];
    [self.talkWebVC removeFromParentViewController];
    self.talkBaseView.backgroundColor = UIColor.clearColor;
    [self.talkBaseView removeFromSuperview];
    self.talkWebVC = nil;
}

- (void)getQRcodeInfo {
    NSDictionary *param = @{
        @"pid":@1,
        @"mid":self.model.ID,
        @"live_user_name":self.liveUserName
    };
    [KYApiHttpTool GET:URL_GetQrcodeInfo withParams:param success:^(NSDictionary * _Nonnull response) {
        NSLog(@"%@", response);
        NSLog(@"%lu", [response[@"data"] count]);
        if ([response[@"data"] count] == 0) {
            self.hasQrcodeData = NO;
        }
        NSString *tmp = [[response[@"data"][0]objectForKey:@"img_qr"] stringByReplacingOccurrencesOfString: @"\r\n" withString:@""];
        NSString *url = tmp;
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        self.imgQr = [[UIImage alloc] initWithData:imageData];
        self.labTitle.text = [response[@"data"][0]objectForKey:@"title"];
        self.labContent.text = [response[@"data"][0]objectForKey:@"content"];
        self.labAddressIos.text = [response[@"data"][0]objectForKey:@"address_ios"];
        // self.labAddressIos.text = url;
    } failure:^(NSError * _Nonnull error) {

    }];
}

- (void)setupParams {
    [KYRemindView dismiss];
    self.currentNum = self.cartoonModel.room_num; //72057594037927935
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNotifa:) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMSG:) name:@"SendMSG" object:nil];
    
    JCHATChatModel *model = [[JCHATChatModel alloc]init];
    model.contentType = 10;
    model.text = @"正在连接聊天室...";
    [self.dataSource addObject:model];
    [self.messageTableView reloadData];
}

- (void)initTimer {
    self.isEnterSuccess = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

//获取网易的聊天室id
- (void)getYXRoomID {
    self.isGettingRoomId = YES;
    NSMutableDictionary *param = @{
        @"mid" : self.model.ID,
        @"type" : self.matchType,           // type: 1 足球  2 篮球
        @"apptype" : @2,
        @"num" : @0,
        @"pid" : @4
    }.mutableCopy;
    if (self.cartoonModel) {
        [param setValue:@(self.cartoonModel.room_num) forKey:@"num"];
    }
    [KYApiHttpTool GETNoHud:URL_YXRoomID withParams:param success:^(NSDictionary * _Nonnull response) {
        NSString *roomid = response[@"roomid"];
        [self enterYXChatRoom:roomid];
        self.isGettingRoomId = YES;
    } failure:^(NSError * _Nullable error) {
        self.isGettingRoomId = NO;
    }];
}

- (void)timerAction {
    if ([CommonTools isBlankString:self.roomID]) {
        if (!self.isGettingRoomId) {
            [self getYXRoomID];
        }
    }else {
        if (!self.isEnterSuccess) {
            if (!self.isEnteringRoom) {
                [self enterYXChatRoom:self.roomID];
            }
        }else {
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
        }
    }
}

//切换了主播 需要切换聊天室
- (void)selectCartoonModel:(LiveCartoonModel *)cartoonModel {
    _cartoonModel = cartoonModel;
    //同一个主播或者 不是主播流的时候 不需要切换
    if (self.currentNum == cartoonModel.room_num || cartoonModel.index != 0) {
        return;
    }
    self.currentNum = cartoonModel.room_num;
    [self.dataSource removeAllObjects];
    JCHATChatModel *model = [[JCHATChatModel alloc]init];
    model.contentType = 10;
    model.text = @"正在切换聊天室...";
    [self.dataSource addObject:model];
    [self.messageTableView reloadData];
    WeakSelf
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:self.roomID completion:^(NSError * _Nullable error) {
        weakSelf.roomID = nil;
        [weakSelf initTimer];
        [weakSelf getYXRoomID];
    }];
}

//登录网易云信的账号
- (void)loginYXAccount {
    NSString *yxAccid = [[NSUserDefaults standardUserDefaults] objectForKey:K_WANGYI_ACCID];
    NSString *yxToken = [[NSUserDefaults standardUserDefaults] objectForKey:K_WANGYI_TOKEN];
    WeakSelf
    if (yxAccid && yxToken) {
        [[NIMSDK sharedSDK].loginManager login:yxAccid token:yxToken completion:^(NSError * _Nullable error) {
            weakSelf.isEnteringRoom = NO;
        }];
    }else {
        NSMutableDictionary *param = @{
            @"apptype": @2,
            @"deivceid": [KKKeyChain getDeviceIDInKeychain]
        }.mutableCopy;
        NSString *nickName = [[NSUserDefaults standardUserDefaults] valueForKey:K_TouristsNickName];
        LoginUserModel *loginModel = [UserModelTool loginModel];
        if (loginModel) {
            [param setValue:loginModel.userinfo.mobile forKey:@"mobile"];
            [param setValue:loginModel.uid forKey:@"uid"];
            nickName = loginModel.userinfo.nickname;
        }
        if (nickName) {
            [param setValue:nickName forKey:@"nickname"];
        }
        [KYApiHttpTool GET:URL_YXUserID withParams:param success:^(NSDictionary * _Nonnull response) {
            NSString *accid = response[@"accid"];
            NSString *token = response[@"token"];
            NSString *nickName = [[NSUserDefaults standardUserDefaults] valueForKey:K_TouristsNickName];
            if ([CommonTools isBlankString:nickName]) {
                [[NSUserDefaults standardUserDefaults] setValue:response[@"nickname"] forKey:K_TouristsNickName];
            }
            [[NSUserDefaults standardUserDefaults] setValue:accid forKey:K_WANGYI_ACCID];
            [[NSUserDefaults standardUserDefaults] setValue:token forKey:K_WANGYI_TOKEN];
            [[NIMSDK sharedSDK].loginManager login:accid token:token completion:^(NSError * _Nullable error) {
                weakSelf.isEnteringRoom = NO;
            }];
        } failure:^(NSError * _Nonnull error) {
            weakSelf.isEnteringRoom = NO;
        }];
    }
}

 
// 进入云信聊天室
- (void)enterYXChatRoom:(NSString *)roomID {
    self.roomID = roomID;
    self.isEnteringRoom = YES;
    if ([NIMSDK sharedSDK].loginManager.isLogined) {
        NIMChatroomEnterRequest *request = [NIMChatroomEnterRequest new];
        request.roomId = roomID;
        request.roomNickname = [self getNickName];
        WeakSelf
        [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
            if (error) {
                return;
            }
            if (self.dataSource.count > 1) {
                //去登陆成功回来后会重新 进入同一个聊天室 不需要获取记录
                return;
            }
            NSLog(@"[Adam] chatroom online count: %ld", chatroom.onlineUserCount);
            weakSelf.isEnterSuccess = YES;
            JCHATChatModel *model = [[JCHATChatModel alloc]init];
            model.contentType = 10;
            model.text = @"聊天室连接成功...";
            [weakSelf.dataSource addObject:model];
            [weakSelf.messageTableView reloadData];
            //获取之前的聊天记录
            NIMHistoryMessageSearchOption *option = [NIMHistoryMessageSearchOption new];
            option.limit = 100;
//            NSDateComponents *comp1 = [[NSDateComponents alloc]init];
//            comp1.year = 1990;
//            comp1.month = 1;
//            comp1.day = 1;
//            NSDate *date1 = [[NSCalendar currentCalendar] dateFromComponents:comp1];
//            option.endTime = [date1 timeIntervalSince1970];
//            NSDate *date2 = [NSDate date];
//            option.startTime = [date2 timeIntervalSince1970];
            //option.messageTypes
//            [NIMSDK sharedSDK].
            // NIMSession *session = [NIMSession session:self.roomID type:NIMSessionTypeChatroom];

//            [[NIMSDK sharedSDK].conversationManager fetchMessageHistory:session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
//                NSLog(messages);
//            }];
            [[NIMSDK sharedSDK].chatroomManager fetchMessageHistory:roomID option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
                NSLog(@"[Adam]room id: %@, message count: %lu", roomID, (unsigned long)messages.count);
                NSMutableArray *msgArray = [NSMutableArray array];
                for (NIMMessage *message in messages) {
                    JCHATChatModel *model = [[JCHATChatModel alloc]init];
                    // NSLog(@"[Adam] message: %@", message);
                    model.msgId = message.messageId;
                    NIMMessageChatroomExtension *messageExt = (NIMMessageChatroomExtension *)message.messageExt;
                    model.fromName = messageExt.roomNickname;
                    int level = [message.remoteExt[@"level"] intValue];
                    if (level == 0) {
                        model.level = 0;
                    } else {
                        model.level = level;
                    }
                    if (message.messageType == NIMMessageTypeText) {
                        if (message.remoteExt[@"giftName"] == nil && message.remoteExt[@"bubbleUrl"] == nil) {
                            model.contentType = 0;
                            model.text = message.text;
                            [msgArray addObject:model];
                        } else if (message.remoteExt[@"bubbleUrl"] != nil) {
                            model.contentType = 3;
                            model.bubbleAndroidUrl = message.remoteExt[@"bobbleBackgroundAndroidUrl"];
                            model.bubbleFrontColor = message.remoteExt[@"bobbleFrontColor"];
                            model.text = message.text;
                            UILabel *l = [[UILabel alloc]init];
                            l.numberOfLines = 0;
                            l.text = message.text;
                            int w = [l calculateSizeForWidth:SCREEN_WIDTH].width;
                            if (w >= SCREEN_WIDTH - 120) {
                                model.contentType = 4;
                            }
                            [msgArray addObject:model];
                        } else {
                            model.contentType = 1;
                            model.fromName = message.remoteExt[@"nickName"];
                            model.text = [NSString stringWithFormat:@"%@%@ %@ %@", @"送了一个", message.remoteExt[@"giftName"], message.remoteExt[@"giftTrendsUrl"], @""];
                            [msgArray addObject:model];
                        }
                    } else if (message.messageType == NIMMessageTypeNotification) {
                        //网易自己通知加入聊天室
                        NIMNotificationObject *notification = (NIMNotificationObject *)message.messageObject;
                        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notification.content;
                        if (content.eventType == NIMChatroomEventTypeEnter) {
                            model.contentType = 1;
                            model.fromName = content.source.nick;
                            //在线人数大于maxOnlineCount人后 不在添加 欢迎加入聊天室
                            if (weakSelf.countOnline < maxOnlineCount) {
                                [msgArray addObject:model];
                            }
                        }
                    }
                    // model.contentType = message.messageType;
                }
                [weakSelf.dataSource addObjectsFromArray:(NSMutableArray *)[[msgArray reverseObjectEnumerator] allObjects]];
                if (weakSelf.dataSource.count > 200) {
                    NSArray *data = [weakSelf.dataSource subarrayWithRange:NSMakeRange(weakSelf.dataSource.count -200, 200)];
                    weakSelf.dataSource = [NSMutableArray arrayWithArray:data];
                }
                NSMutableArray *tmpAry = [NSMutableArray new];
                NSMutableArray *tmpDataSource = [NSMutableArray arrayWithCapacity:1000];
                for (int i=0; i<weakSelf.dataSource.count; i++) {
                    [tmpDataSource addObject:weakSelf.dataSource[i]];
                }
                for (int i=0; i<tmpDataSource.count; i++) {
                    // [tmpAry addObject: tmpDataSource[i]];
                    if (i % 10 == 0 && tmpDataSource.count > 2 && self.hasQrcodeData == YES) {
                        [weakSelf.dataSource insertObject:weakSelf.dataSource[i] atIndex:i];
                    }
                }
                for (int i=0; i<tmpDataSource.count; i++) {
                    [tmpAry addObject: tmpDataSource[i]];
                }
                [weakSelf.dataSource removeAllObjects];
                [weakSelf.dataSource addObjectsFromArray:(NSMutableArray *)tmpAry];
                [weakSelf.messageTableView reloadData];
                [weakSelf scrollToBottom:YES];
            }];
        }];
    }else {
        //没有登录就去登录
        [self loginYXAccount];
    } 
}

//云信接收到消息
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages {
    for (int i = 0; i < messages.count; i++) {
        NIMMessage *message = messages[i];
        JCHATChatModel *model = [[JCHATChatModel alloc]init];
        model.msgId = message.messageId;
        NIMMessageChatroomExtension *messageExt = (NIMMessageChatroomExtension *)message.messageExt;
        model.fromName = messageExt.roomNickname;
        model.level = [message.remoteExt[@"level"] intValue];
        if (message.messageType == NIMMessageTypeText) {
            model.contentType = 0;
            model.text = message.text;
            if (message.remoteExt[@"giftName"] == nil) {
                [self.dataSource addObject:model];
            } else if (message.remoteExt[@"bubbleUrl"] != nil) {
                model.contentType = 3;
                model.bubbleAndroidUrl = message.remoteExt[@"bobbleBackgroundAndroidUrl"];
                model.bubbleFrontColor = message.remoteExt[@"bobbleFrontColor"];
                model.text = message.text;
                UILabel *l = [[UILabel alloc]init];
                l.numberOfLines = 0;
                l.text = message.text;
                int w = [l calculateSizeForWidth:SCREEN_WIDTH].width;
                if (w >= SCREEN_WIDTH - 120) {
                    model.contentType = 4;
                }
                [self.dataSource addObject:model];
            }
            else {
                model.contentType = 1;
                model.fromName = message.remoteExt[@"nickName"];
                model.text = [NSString stringWithFormat:@"%@%@ %@ %@", @"送了一个", message.remoteExt[@"giftName"], message.remoteExt[@"giftTrendsUrl"], @""];
                [self.dataSource addObject:model];
            }
            if (self.dataSource.count % 10 == 0 && self.dataSource.count > 2 && self.hasQrcodeData == YES) {
                [self.dataSource addObject:model];
            }
            if (self.canShowDanMu() && model.text.length > 0) {
                self.checkDanMu();
                [[BarrageManager shareManager] addAttrBarrage:[self barrageAttributedString:model.text] delay:1*i];
            }
        }else if (message.messageType == NIMMessageTypeNotification) {
            //网易自己通知加入聊天室
            NIMNotificationObject *notification = (NIMNotificationObject *)message.messageObject;
            NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notification.content;
            if (content.eventType == NIMChatroomEventTypeEnter) {
                model.contentType = 1;
                model.fromName = content.source.nick;
                //在线人数大于maxOnlineCount人后 不在添加 欢迎加入聊天室
                if (self.countOnline < maxOnlineCount) {
                    [self.dataSource addObject:model];
                }
            }
        } 
    }
    if (self.dataSource.count > 200) {
        NSArray *data = [self.dataSource subarrayWithRange:NSMakeRange(self.dataSource.count -200, 200)];
        self.dataSource = [NSMutableArray arrayWithArray:data];
    }
    [self.messageTableView reloadData];
    //证明有新消息
    if (self.isHaveDraggTop) {
        self.newsBtn.hidden = NO;
    }else {
        [self scrollToBottom:YES];
    }

}
    
//云信自己发送消息回调
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(nullable NSError *)error {
    
}

// 1:禮物 2:等級 3:氣泡
-(void)talkToolBar:(ChatBottomToolBar*)toolBar giftType:(NSInteger)giftType giftID:(NSString *)giftID sendGift:(NSString*)text withGifUrl:(NSString*)gifUrl imageUrl:(NSString *)imageUrl {
    if (giftType == 1 || giftType == 2) {        // 1:禮物 // 2:等級
        [self talkToolBar:toolBar sendText:[NSString stringWithFormat:@"%@%@ %@ %@ %@ %@", @"送了一个", text, gifUrl, imageUrl, giftID, text] giftType:1];
    }
}

#pragma mark  ChatToolBarDelegate
//点击发送按钮
-(void)talkToolBar:(ChatBottomToolBar *)toolBar sendText:(NSString *)content giftType:(NSInteger)giftType {
    if (content.length == 0) {
        return;
    }
    LoginUserModel *loginModel = [UserModelTool loginModel];
    NSString *accid = [[NSUserDefaults standardUserDefaults] objectForKey:K_WANGYI_ACCID];
    NSDictionary *dic;
    NSInteger level = (NSInteger)[[loginModel.userinfo valueForKey:@"level"]integerValue];
    NSString *username = [self getNickName];
    if (!username) {
        return;
    }
    if (self.liveUserName == nil || [self.liveUserName isEqualToString:@""]) {
        self.liveUserName = @"";
    }
    if (loginModel) {
        if (giftType == 1 || giftType == 2) {
            NSArray *seg = [content componentsSeparatedByString:@" "];
            dic = @{
                @"mobile": loginModel.userinfo.mobile,
                @"uid":loginModel.uid,
                @"txt":seg[0],
                @"accid": accid ? accid : @"",
                @"deivceid": [KKKeyChain getDeviceIDInKeychain],
                @"username": username,
                @"pid" :@"4",
                @"live_username": self.liveUserName
            };
        } else {
            dic = @{
                @"mobile": loginModel.userinfo.mobile,
                @"uid":loginModel.uid,
                @"txt":content,
                @"accid": accid ? accid : @"",
                @"deivceid": [KKKeyChain getDeviceIDInKeychain],
                @"username": username,
                @"pid" :@"4",
                @"live_username": self.liveUserName
            };
        }
    } else {
        dic = @{
            @"txt":content,
            @"accid": accid ? accid : @"",
            @"deivceid": [KKKeyChain getDeviceIDInKeychain],
            @"username": username,
            @"pid" :@"4",
            @"live_username": self.liveUserName
        };
    }
    [KYApiHttpTool GET:URL_CheckTxt withParams:dic success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 0) {
            // 构造出具体会话
            NIMSession *session = [NIMSession session:self.roomID type:NIMSessionTypeChatroom];
            // 构造出具体消息
            NIMMessage *message = [[NIMMessage alloc] init];
            message.remoteExt = [NSMutableDictionary new];
            message.text = response[@"data"];

            if ([self.df objectForKey:@"9fileBg"] != nil && giftType != 1 && giftType != 2) {
                if (loginModel && level > 0) {
                    NSString *bubbleFrontColor = loginModel.userinfo.bobbleFrontColor;
                    if (bubbleFrontColor == nil || [bubbleFrontColor isEqualToString:@""]) {
                        bubbleFrontColor = @"#000000";
                    }
                    message.remoteExt = @{@"level" : @(level),
                                          @"bubbleUrl" : [self.df objectForKey:@"9fileBg"],
                                          @"bobbleId" : [self.df objectForKey:@"9fileId"],
                                          @"bobbleBackgroundAndroidUrl" : [self.df objectForKey:@"9file"],
                                          @"bobbleFrontColor" : bubbleFrontColor,
                                          @"idFlag" : loginModel.userinfo.atype == 1 ? @1 : @0,
                                          @"subType" : @1000};
                } else {
                    message.remoteExt = @{@"level" : @(0)};
                }
            } else {
                if (loginModel && level > 0) {
                    message.remoteExt = @{@"level" : @(level)};
                } else {
                    message.remoteExt = @{@"level" : @(0)};
                }
            }

            // 错误反馈对象
            NSError *error = nil;
            // 发送消息
            if (giftType != 1 && giftType != 2) {
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
                [self addSelfSendMSG:message giftType:giftType];
            }
        }else {
            if (giftType != 1 && giftType != 2) {
                NIMMessage *message = [[NIMMessage alloc] init];
                message.text = content;
                [self addSelfSendMSG:message giftType:giftType];
            }
        }
    } failure:^(NSError * _Nullable error) {
        
    }];

    // 送出禮物
    if (giftType == 1 || giftType == 2) {
        NSArray *gift = [content componentsSeparatedByString:@" "];
        NSDictionary *param = @{
            @"uid":loginModel.uid,
            @"giftId": gift[3],
            @"anchorName": gift[4],
            @"roomid": self.roomID,
            @"level": [NSString stringWithFormat:@"%ld", (long)level]
        };
        [KYApiHttpTool GET:URL_SendGift withParams:param success:^(NSDictionary * _Nonnull response) {
            NSLog(@"[Adam: %@]", response);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self scrollToBottom:YES];
            });
        } failure:^(NSError * _Nonnull error) {

        }];
    }
}

//横屏发送弹幕的通知
- (void)sendMSG:(NSNotification *)notification {
    NSDictionary *userinfo = [notification userInfo];
    NSString *msg = [userinfo objectForKey:@"msg"];
    if (msg == nil || msg.length <= 0) {
        return;
    }
    LoginUserModel *loginModel = [UserModelTool loginModel];
    NSString *accid = [[NSUserDefaults standardUserDefaults] objectForKey:K_WANGYI_ACCID];
    NSDictionary *dic;
    NSString *username = [self getNickName];
    if (!username) {
        return;
    }
    if (self.liveUserName == nil || [self.liveUserName isEqualToString:@""]) {
        self.liveUserName = @"";
    }
    if (loginModel) {
        dic = @{
            @"mobile": loginModel.userinfo.mobile,
            @"uid":loginModel.uid,
            @"txt":msg,
            @"accid": accid ? accid : @"",
            @"deivceid": [KKKeyChain getDeviceIDInKeychain],
            @"username": username,
            @"pid": @4,
            @"live_username": self.liveUserName
        };
    } else {
        dic = @{
            @"txt":msg,
            @"accid": accid ? accid : @"",
            @"deivceid": [KKKeyChain getDeviceIDInKeychain],
            @"username": username,
            @"pid": @4,
            @"live_username": self.liveUserName
        };
    }
    [KYApiHttpTool GETNoHud1:URL_CheckTxt withParams:dic success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 0) {
            // 构造出具体会话
            NIMSession *session = [NIMSession session:self.roomID type:NIMSessionTypeChatroom];
            // 构造出具体消息
            NIMMessage *message = [[NIMMessage alloc] init];
            message.text = response[@"data"];
            // 错误反馈对象
            NSError *error = nil;
            // 发送消息
            [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
            [self addSelfSendMSG:message giftType:-1];
        }else {
            NIMMessage *message = [[NIMMessage alloc] init];
            message.text = msg;
            [self addSelfSendMSG:message giftType:-1];
        }
        
    } failure:^(NSError * _Nullable error) {
        [MBProgressHUD showError:@"发送失败" toView:nil];
    }];
}

//发送消息
// 1:禮物 2:等級 3:氣泡
- (void)addSelfSendMSG:(NIMMessage *)message giftType:(NSInteger)giftType {
    JCHATChatModel *model = [[JCHATChatModel alloc]init];
    model.msgId = message.messageId;
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (giftType == 1 || giftType == 2) {
        model.contentType = 1;
    } else if (loginModel && [df objectForKey:@"9file"] != nil) {
        model.contentType = 3;
        model.bubbleAndroidUrl = [df objectForKey:@"9file"];
        model.bubbleFrontColor = loginModel.userinfo.bobbleFrontColor;
        UILabel *l = [[UILabel alloc]init];
        l.numberOfLines = 0;
        l.text = message.text;
        int w = [l calculateSizeForWidth:SCREEN_WIDTH].width;
        if (w >= SCREEN_WIDTH - 120) {
            model.contentType = 4;
        }
    }
    else {
        model.contentType = 0;
        [self.view endEditing:YES];
    }
    model.text = message.text;
    if (self.canShowDanMu() && model.text.length > 0) {
        self.checkDanMu();
        [[BarrageManager shareManager] addAttrBarrage:[self barrageAttributedString:model.text] delay:0];
    }
    if (loginModel) {
        model.level = loginModel.userinfo.level;
    } else {
        model.level = 0;     // 未登入
    }
    model.fromName = [self getNickName];
    [self.dataSource addObject:model];
    if (self.dataSource.count % 10 == 0 && self.dataSource.count > 2 && self.hasQrcodeData == YES) {
        [self.dataSource addObject:model];
    }
    [self.messageTableView reloadData];
    [self scrollToBottom:YES];
}

//登录成功的通知
- (void)loginSuccessNotifa:(NSNotification *)notification {
    self.loginBtn.hidden = YES;
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView).offset(-12.5);
    }];
    [self.scrollLabel setContentOffset:CGPointMake(0,0) animated:NO];
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if(loginModel){
        //主播才显示在线人数
        if (loginModel.userinfo.atype == 1) {
            self.countLabel.text = [NSString stringWithFormat:@"    %ld人在线",self.countOnline];
            CGFloat w = [self evaluteWidth:self.countLabel];
            [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(w);
            }];
        }
        WeakSelf
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:self.roomID completion:^(NSError * _Nullable error) {
            [weakSelf initTimer];
            [weakSelf enterYXChatRoom:self.roomID];
        }];
    }
    if (self.playStatus == PlayingStatusLive) {
        [SNGlobalShared initVideoTimer];
    }
    
}

- (void)isLoginOut {
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if(!loginModel){
        self.loginBtn.hidden = NO;
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topView).offset(-(12.5 + 60));
        }];
    }
}

//设置顶部的文字的滚动 和登录按钮
- (void)setupScrollView {
    self.countOnline = self.model.online_num;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    self.topView = topView;
    [self.view addSubview:topView];
    
    UILabel *countLabel = [[UILabel alloc] init];
    self.countLabel = countLabel;
    countLabel.text = @"";
    LoginUserModel *loginModel = [UserModelTool loginModel]; 
    if(loginModel){
        //主播才显示在线人数
        if (loginModel.userinfo.atype == 1) {
            countLabel.text = [NSString stringWithFormat:@"    %ld人在线",self.model.online_num];
        }
    }
    countLabel.textColor = Blue_Color;
    countLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    [topView addSubview:countLabel];
    CGFloat w = [self evaluteWidth:self.countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(topView);
        make.left.equalTo(topView).offset(0);
        make.width.mas_equalTo(w);
    }];
    
    
    UIButton *loginBtn = [[UIButton alloc] init];
    self.loginBtn = loginBtn;
    
    CGFloat scrollW = kScreenWidth-35.5-12.5-25-w-60;
    CGFloat right = 12.5 + 60;
    if (loginModel) {
        scrollW = kScreenWidth-35.5-12.5-25-w;
        right = 12.5;
        loginBtn.hidden = YES;
    }
    
    [topView addSubview:loginBtn];
    [loginBtn setTitle:@"去登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:Blue_Color forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = Font(14);
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(topView);
        make.width.mas_equalTo(right);
    }];
     
    UIView *backView = [[UIView alloc] init];
    self.backView = backView;
    backView.backgroundColor = RGBA(255, 222, 150, 0.1);
    backView.layer.cornerRadius = 5;
    [topView addSubview:backView];
    CGFloat right1 = 12.5;
    if ([self.model.type intValue] == 3) {
        right1 = 0;
    }
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).offset(3);
        make.bottom.equalTo(topView).offset(-3);
        make.left.equalTo(countLabel.mas_right).offset(right1);
        make.right.equalTo(topView).offset(-right);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 14.5, 12)];
    imageView.image = [UIImage imageNamed:@"喇叭"];
    [backView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(11);
        make.left.equalTo(backView).offset(10);
        make.width.mas_equalTo(14.5);
        make.height.mas_equalTo(12);
    }];
     
    self.scrollLabel = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(35.5, 0, scrollW, 34)];
    self.scrollLabel.textColor = [UIColor colorWithHexString:@"#E6B95E"];
    self.scrollLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollLabel setText:@"禁止任何形式的广告、违规者封号！"];
    [self.scrollLabel readjustLabels];
    [backView addSubview:self.scrollLabel];
    [self.scrollLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(35.5);
        make.top.bottom.equalTo(backView);
        make.right.equalTo(backView).offset(-12.5);
    }];
    
}

- (void)newsBtnAction {
    self.newsBtn.hidden = YES;
    self.isHaveDraggTop = NO;
    [self scrollToBottom:YES];
}

- (void)loginBtnAction {
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if(!loginModel){
        LoginViewController *loginVc = [LoginViewController new]; 
        [self.navigationController pushViewController:loginVc animated:YES];
    }
}

- (CGFloat)evaluteWidth:(UILabel *)label {
    NSDictionary *textAtt = @{NSFontAttributeName : label.font};
    CGSize evaluteLabelSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGFloat evaluteW = evaluteLabelSize.width + 1;
    return evaluteW;
}

//设置输入框和底部有新消息
- (void)setupComponentView {
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.view addGestureRecognizer:gesture];
    [self.view addSubview:self.messageTableView];
    [self.messageTableView reloadData];
    
    self.chatToolBar = [[ChatBottomToolBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.chatToolBar.parentVC = self;
    self.chatToolBar.delegate = self;
    [self.view addSubview:self.chatToolBar];
    
    [self.chatToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(emojiHeight);
        make.height.mas_equalTo(56+xBottomHeight+emojiHeight);
    }];
    
    UIButton *newsBtn = [[UIButton alloc] init];
    self.newsBtn = newsBtn;
    [self.view addSubview:newsBtn];
    [newsBtn setTitle:@"底部有新消息" forState:UIControlStateNormal];
    newsBtn.backgroundColor = RGBA(0, 0, 0, 0.6);
    [newsBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [newsBtn addTarget:self action:@selector(newsBtnAction) forControlEvents:UIControlEventTouchUpInside];
    newsBtn.titleLabel.font = Font(12);
    [newsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.chatToolBar.mas_top).offset(-12.5);
        make.width.mas_equalTo(99);
        make.height.mas_equalTo(30);
    }];
    newsBtn.layer.cornerRadius = 15;
    newsBtn.clipsToBounds = YES;
    newsBtn.hidden = YES;
    
}

//更新tableview的高度
- (void)updateScrollViewHeight:(PlayingStatus)playStatus {
    _playStatus = playStatus;
    CGFloat height = 0;
    if (playStatus == PlayingStatusLive) {
        height = kScreenHeight-kContentHeight - 56- xBottomHeight - 40 - 41 - kBottomHeight;
    }else {
        height = kScreenHeight-kContentHeight - 56- xBottomHeight - 40 - 41;
    }
    self.messageTableView.height = height;

//    if (playStatus != PlayingStatusLive) {
//        height = kScreenHeight-kContentHeight - 56- xBottomHeight - 40 - 41 - 80;
//        self.messageTableView.height = height;
//        self.bannerImageView.frame = CGRectMake(0, self.messageTableView.height+30, SCREEN_WIDTH, 114);
//    }
}

- (void)tapClick:(UITapGestureRecognizer *)tap { 
    [self.chatToolBar dismissKeyBoard];
}

//更新在线人数
- (void)updateOnlineCount:(NSString *)count {
    self.countOnline = [count integerValue];
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if(loginModel){
        //主播才显示在线人数
        if (loginModel.userinfo.atype == 1) {
            self.countLabel.text = [NSString stringWithFormat:@"    %@人在线",count];
            CGFloat w = [self evaluteWidth:self.countLabel];
            [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(w);
            }];
        }
    }else {
        self.countLabel.text = @"";
        [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}
   
//比赛是否开始了
- (void)isGameStart:(BOOL)start gameStatus:(NSInteger)gameStatus {
    [self.chatToolBar isCanSend:start gameStatus:gameStatus];
}

//弹幕的AttributedString
- (NSMutableAttributedString *)barrageAttributedString:(NSString *)text {
    NSMutableAttributedString *attr = [NSMutableAttributedString new];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 1;//模糊度
    shadow.shadowColor = UIColor.whiteColor;
    shadow.shadowOffset=CGSizeMake(0.5, 0.5);
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", text] attributes:@{
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSStrokeWidthAttributeName: @(-2),
        NSStrokeColorAttributeName: SRGB(220),
        NSShadowAttributeName : shadow,
        NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]}]];
    
    return attr;
}

//获取昵称
- (NSString *)getNickName {
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:K_TouristsNickName];
    if (!nickName) {
        //在这里还没获取到 游客昵称的话就随机弄个
        nickName = [NSString stringWithFormat:@"快直播游客%@",[CommonTools getRandomStringWithNum:4]];
        [[NSUserDefaults standardUserDefaults] setValue:nickName forKey:K_TouristsNickName];
    }
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        nickName = loginModel.userinfo.nickname;
    }
    return nickName;
}

  
-(void)talkToolBar:(ChatBottomToolBar *)toolBar changeHeight:(float)height{
    [self scrollToBottom:YES];
}


//滚到底部
- (void)scrollToBottom:(BOOL)animated {
  if (self.dataSource.count == 0) {
      return;
  }
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      if (self.messageTableView.contentSize.height <= (kScreenHeight-kContentHeight - 56-xBottomHeight)) {
          return;
      }
      CGPoint point = CGPointMake(0, self.messageTableView.contentSize.height-self.messageTableView.height);
      [self.messageTableView setContentOffset:point animated:animated];
  });
}

#pragma mark -- TableViewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 10 == 0 && indexPath.row > 2 && self.hasQrcodeData == YES) {
        static NSString *cellIdentifier = @"SimpleTableItem";

        QrcodeCell *cell = (QrcodeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        if (cell == nil){
            cell = [[QrcodeCell alloc] init];
        }
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;;
        // cell.qrImageView.frame = CGRectMake(8, cell.qrImageView.frame.origin.y, 80, 80);
        // cell.labTitle.frame = CGRectMake(88, cell.labTitle.frame.origin.y, SCREEN_WIDTH-60, 20);
        cell.labTitle.font = [UIFont boldSystemFontOfSize:14.0];
        cell.labTitle.numberOfLines = 1;
        // cell.labContent.frame = CGRectMake(88, cell.labContent.frame.origin.y, SCREEN_WIDTH-100, 40);
        cell.labContent.font = [UIFont systemFontOfSize:12.0];
        cell.labContent.numberOfLines = 0;
        // cell.labTitle.textColor = UIColor.orangeColor;
        // cell.labContent.textColor = UIColor.orangeColor;
        cell.labTitle.text = self.labTitle.text;
        cell.labContent.text = self.labContent.text;
        cell.qrImageView.image = self.imgQr;
        cell.labAddressIos.text = self.labAddressIos.text;
        return cell;
    } else {
        JCHATChatModel *message = [self.dataSource objectAtIndex:indexPath.row];
        if (message.contentType == 0) {
            SNMessageCell *cell = (SNMessageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[SNMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            NSLog(@"[Adam] level: %ld, %@", (long)message.level, message.text);
            cell.selectionStyle = 0;
            cell.level = message.level;
//            if (message.level == 0 ) {
                cell.hexColorFromName = [self getMessageColor:51];
//            } else {
//                cell.hexColorFromName = [self getMessageColor:message.level];
//            }
            cell.hexColorBody = [self getMessageColor:message.level];
            cell.message = message;
            //cell.message.text
            return cell;
        } else if (message.contentType == 1 || message.contentType == 2) {
            static NSString *cellIdentifier = @"GiftMsgCell";

            GiftMsgCell *cell = (GiftMsgCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

            if (cell == nil){
                cell = [[GiftMsgCell alloc] init];
            }

            NSLog(@"[Adam] level: %ld, %@", (long)message.level, message.text);
            cell.selectionStyle = 0;
            cell.level = message.level;
            cell.hexColorFromName = [self getMessageColor:51];
            cell.hexColorBody = [self getMessageColor:message.level];

            cell.message = message;

            return cell;
        } else if (message.contentType == 3) {
            static NSString *cellIdentifier = @"GiftBubbleCell";

            GiftBubbleCell *cell = (GiftBubbleCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

            if (cell == nil){
                cell = [[GiftBubbleCell alloc] init];
            }

//            LoginUserModel *loginModel = [UserModelTool loginModel];
//            NSString *bubbleFrontColor = loginModel.userinfo.bobbleFrontColor;
//
//            if (bubbleFrontColor == nil || [bubbleFrontColor isEqualToString:@""]) {
//                bubbleFrontColor = @"#000000";
//            }

            NSLog(@"[Adam] level: %ld, %@", (long)message.level, message.text);
            cell.selectionStyle = 0;
            cell.level = message.level;
            cell.hexColorFromName = [self getMessageColor:51];
            cell.hexColorBody = message.bubbleFrontColor;

            cell.message = message;

            return cell;
        } else if (message.contentType == 4) {
            static NSString *cellIdentifier = @"GiftBubble2Cell";

            GiftBubble2Cell *cell = (GiftBubble2Cell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

            if (cell == nil){
                cell = [[GiftBubble2Cell alloc] init];
            }

//            LoginUserModel *loginModel = [UserModelTool loginModel];
//            NSString *bubbleFrontColor = loginModel.userinfo.bobbleFrontColor;
//
//            if (bubbleFrontColor == nil || [bubbleFrontColor isEqualToString:@""]) {
//                bubbleFrontColor = @"#000000";
//            }

            NSLog(@"[Adam] level: %ld, %@", (long)message.level, message.text);
            cell.selectionStyle = 0;
            cell.level = message.level;
            cell.hexColorFromName = [self getMessageColor:51];
            cell.hexColorBody = message.bubbleFrontColor;

            cell.message = message;

            return cell;
        } else if (message.contentType == 10) {
            SNMessageEnterTableViewCell *cell = [SNMessageEnterTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = 0;
            cell.message = self.dataSource[indexPath.row];
            return cell;
        }else {
            SNMessageEnterTableViewCell *cell = [SNMessageEnterTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = 0;
            cell.message = self.dataSource[indexPath.row];
            return cell;
        }
    }
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JCHATChatModel *message = [self.dataSource objectAtIndex:indexPath.row];
    if (indexPath.row % 10 == 0 && indexPath.row > 2 && self.hasQrcodeData == YES) {
        return UITableViewAutomaticDimension;
    } else if (message.contentType == 0) {
        return message.contentHeight;
    } else if (message.contentType == 1 || message.contentType == 2) {
        return 56-4;
    } else if (message.contentType == 3) {
        return 42-2;
    } else if (message.contentType == 4) {
        JCHATChatModel *message = [self.dataSource objectAtIndex:indexPath.row];
        UILabel *lab = [[UILabel alloc]init];
        lab.numberOfLines = 0;
        lab.text = message.text;
        MLExpression *expression = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"faceMap_ch" bundleName:@"Expression"];
        NSMutableAttributedString *attribute = [[lab.text expressionAttributedStringWithExpression:expression] mutableCopy];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3;
        [attribute addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lab.text.length)];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.attributedText = attribute;
        NSInteger w = [lab calculateSizeForWidth:SCREEN_WIDTH].width + 62;
        if (w > SCREEN_WIDTH - 40) {
            return 88-2;    // 二行高
        } else {
            return 88-15;
        }
    }
    else {
        return 40;
    }
}

/*
- (void) createQrComponent:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    UIImageView *imgQr = [[UIImageView alloc]initWithFrame:CGRectMake(8, self.messageTableView.height+38, 80, 80)];
    UILabel *labTitle = [[UILabel alloc]initWithFrame:CGRectMake(88, self.messageTableView.height+44, SCREEN_WIDTH - 60, 20)];
    labTitle.font = [UIFont boldSystemFontOfSize:14.0];
    labTitle.numberOfLines = 1;
    UILabel *labContent = [[UILabel alloc]initWithFrame:CGRectMake(88, self.messageTableView.height+42+28, SCREEN_WIDTH - 100, 40)];
    labContent.font = [UIFont systemFontOfSize:12.0];
    labContent.numberOfLines = 2;
    imgQr.tag = indexPath.row;
    labTitle.tag = indexPath.row+1;
    labContent.tag = indexPath.row+2;
    [cell.contentView addSubview:imgQr];
    [cell.contentView addSubview:labTitle];
    [cell.contentView addSubview:labContent];
}

- (void)addQrCodeForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    UIImageView *imgQr = (UIImageView *)[cell viewWithTag:indexPath.row];
    UILabel *labTitle = (UILabel *)[cell viewWithTag:indexPath.row + 1];
    UILabel *labContent = (UILabel *)[cell viewWithTag:indexPath.row + 2];
    imgQr.image = [self.imgQr copy];
    labTitle.text = self.labTitle.text;
    labContent.text = self.labContent.text;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row % 10 == 0 && indexPath.row > 2) {
//        qrcodeCell *cell = (qrcodeCell *)[_messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
//        if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:cell.labAddressIos.text]]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cell.labAddressIos.text] options:@{} completionHandler:nil];
//        }
//    }
}

- (IBAction)tapQrCodeCellAction:(UITapGestureRecognizer *)sender {

}

#pragma mark - scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.chatToolBar.showKeyboard) {
        [self.chatToolBar dismissKeyBoard];
    }
}

#pragma mark - JXPagerViewListViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat y = scrollView.contentOffset.y;
    NSInteger currentY = floorInPixel(y);
    NSInteger pointY = floorInPixel(self.messageTableView.contentSize.height-self.messageTableView.height);
    if (currentY >= pointY) {
        self.newsBtn.hidden = YES;
        self.isHaveDraggTop = NO;
    }else {
        self.isHaveDraggTop = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y > 0) {
        self.scrollCallback(scrollView);
    }
    NSInteger currentY = floorInPixel(y);
    NSInteger pointY = floorInPixel(self.messageTableView.contentSize.height-self.messageTableView.height);
    if (currentY >= pointY ) {
        self.newsBtn.hidden = YES;
        self.isHaveDraggTop = NO;
    }
}

- (UIScrollView *)listScrollView {
    return self.messageTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}
 
#pragma mark -- getter 懒加载
- (UITableView *)messageTableView {
    if (!_messageTableView) {
       CGFloat height = 0;
       if (self.playStatus == PlayingStatusLive) {
           // height = kScreenHeight-kContentHeight - 56- xBottomHeight - 40 - 41 - kBottomHeight - 80;
           height = kScreenHeight-kContentHeight - 56- xBottomHeight - 40 - 41 - kBottomHeight;
       }else {
           height = kScreenHeight-kContentHeight - 56- xBottomHeight - 40 - 41;
       }
        //44是page的高度
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, height) style:UITableViewStylePlain];
        _messageTableView.backgroundColor =UIColor.whiteColor;
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        //设置预估行高
        _messageTableView.estimatedRowHeight = 45;
        _messageTableView.allowsSelection = YES;
        _messageTableView.showsVerticalScrollIndicator = NO;
        [_messageTableView registerNib:[UINib nibWithNibName:@"SNMessageEnterTableViewCell" bundle:nil] forCellReuseIdentifier:@"SNMessageEnterTableViewCell"];
        if (@available(iOS 11.0, *)) {
            _messageTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        CGRect frame = _messageTableView.bounds;
        frame.size.height += 82+28;
        self.talkBaseView.frame = frame;
    }
    return _messageTableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)deallocChatVc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:self.roomID completion:^(NSError * _Nullable error) {
            
    }];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendMSG" object:nil];
}


- (void)dealloc {
    
}

- (NSString *) getMessageColor:(NSInteger)type {
    switch (type) {
        case 0:
            return @"#333333";
            break;
        case 1:
            return @"#298C91";
            break;
        case 2:
            return @"#298C91";
            break;
        case 3:
            return @"#298C91";
            break;
        case 4:
            return @"#298C91";
            break;
        case 5:
            return @"#298C91";
            break;
        case 6:
            return @"#298C91";
            break;
        case 7:
            return @"#298C91";
            break;
        case 8:
            return @"#298C91";
            break;
        case 9:
            return @"#298C91";
            break;
        case 10:
            return @"#F38E28";
            break;
        case 11:
            return @"#F38E28";
            break;
        case 12:
            return @"#F38E28";
            break;
        case 13:
            return @"#F38E28";
            break;
        case 14:
            return @"#F38E28";
            break;
        case 15:
            return @"#F38E28";
            break;
        case 16:
            return @"#F38E28";
            break;
        case 17:
            return @"#F38E28";
            break;
        case 18:
            return @"#F38E28";
            break;
        case 19:
            return @"#B74929";
            break;
        case 20:
            return @"#B74929";
            break;
        case 21:
            return @"#B74929";
            break;
        case 22:
            return @"#B74929";
            break;
        case 23:
            return @"#B74929";
            break;
        case 24:
            return @"#B74929";
            break;
        case 25:
            return @"#B74929";
            break;
        case 26:
            return @"#B74929";
            break;
        case 27:
            return @"#B74929";
            break;
        case 28:
            return @"#780D96";
            break;
        case 29:
            return @"#780D96";
            break;
        case 30:
            return @"#780D96";
            break;
        case 31:
            return @"#780D96";
            break;
        case 32:
            return @"#780D96";
            break;
        case 33:
            return @"#780D96";
            break;
        case 34:
            return @"#780D96";
            break;
        case 35:
            return @"#780D96";
            break;
        case 36:
            return @"#780D96";
            break;
        case 37:
            return @"#780D96";
            break;
        case 38:
            return @"#780D96";
            break;
        case 39:
            return @"#780D96";
            break;
        case 40:
            return @"#780D96";
            break;
        case 41:
            return @"#780D96";
            break;
        case 42:
            return @"#780D96";
            break;
        case 43:
            return @"#780D96";
            break;
        case 44:
            return @"#780D96";
            break;
        case 45:
            return @"#780D96";
            break;
        case 46:
            return @"#780D96";
            break;
        case 47:
            return @"#780D96";
            break;
        case 48:
            return @"#780D96";
            break;
        case 49:
            return @"#780D96";
            break;
        case 50:
            return @"#780D96";
            break;
        case 51:        // 游客的fromName
            return @"264A89";
        default:
            break;
    }
    return @"#FFB587";
}

@end
