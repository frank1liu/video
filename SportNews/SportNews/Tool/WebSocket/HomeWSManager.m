//
//  HomeWSManager.m
//  SportNews
//
//  Created by yuhua on 2021/3/18.
//

#import "HomeWSManager.h"
#import "MSNetwork.h"

#define dispatch_main_async_safes(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

@interface HomeWSManager()<SRWebSocketDelegate>
{
    int _index;
    NSTimer * heartBeat;
    NSTimeInterval reConnectTime;
}

@property (nonatomic,strong) SRWebSocket *socket;

@property (nonatomic,copy) NSString *urlString;

@property (nonatomic, strong) NSMutableDictionary *datas;

@property (nonatomic, strong) NSMutableDictionary *datasNewStateDic;

@end

@implementation HomeWSManager

+ (HomeWSManager *)instance {
    static HomeWSManager *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[HomeWSManager alloc] init];
        Instance.datas = [NSMutableDictionary new];
        Instance.datasNewStateDic = [NSMutableDictionary new];
        [Instance repeatSend];
    });
    return Instance;
}

#pragma mark - **************** public methods
-(void)SRWebSocketOpenWithURLString:(NSString *)urlString {
     
    NSLog(@"连接地址:%@", urlString);
    if (!urlString) {
        return;
    }
    if ([urlString isEqualToString:self.urlString] && self.socket) {
        return;
    }
    //这个比较特殊 首页只要socket是连接的 就不需要重新连 请求一次 token就会变
    if (self.socket.readyState == SR_OPEN) {
        return;
    }
    //已经有了 socket 并且地址还不相同 就关闭socket 重新新建
    if (self.socket) {
        [self SRWebSocketClose];
    }
    self.urlString = urlString;
    
    self.socket = [[SRWebSocket alloc] initWithURLRequest:
                   [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    //SRWebSocketDelegate 协议
    self.socket.delegate = self;
    
    //开始连接
    [self.socket open];
    
    [MSNetwork networkStatusWithBlock:^(MSNetworkStatusType status) {
        [self reConnectSocket];
    }];
}

- (void)SRWebSocketClose {
    if (self.socket){
        [self.socket close];
        self.socket = nil;
        //断开连接时销毁心跳
        [self destoryHeartBeat];
    }
}


- (void)sendData:(id)data {
    WeakSelf
    dispatch_queue_t queue =  dispatch_queue_create("zy", NULL);
    dispatch_async(queue, ^{
        if (weakSelf.socket != nil) {
            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
            if (weakSelf.socket.readyState == SR_OPEN) {
                [weakSelf.socket send:data];    // 发送数据
                
            } else if (weakSelf.socket.readyState == SR_CONNECTING) {
                [self reConnect];
                
            } else if (weakSelf.socket.readyState == SR_CLOSING || weakSelf.socket.readyState == SR_CLOSED) {
                // websocket 断开了，调用 reConnect 方法重连
                [self reConnect];
            }
        } else {
            self->reConnectTime = 0;
            [self reConnect];
        }
    });
}


- (void)reConnectSocket {
    if (reConnectTime > 64) {
        reConnectTime = 0;
        [self reConnect];
    }
    
}
#pragma mark - **************** private mothodes
//重连机制
- (void)reConnect {
    [self SRWebSocketClose];
    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (reConnectTime > 64) {
        //您的网络状况不是很好，请检查网络后重试
        reConnectTime = 0;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self SRWebSocketOpenWithURLString:self.urlString];
        KKLog(@"重连");
    });
    
    //重连时间2的指数级增长
    if (reConnectTime == 0) {
        reConnectTime = 3;
    } else {
//        reConnectTime *= 2;
    }
}


//取消心跳
- (void)destoryHeartBeat {
    dispatch_main_async_safes(^{
        if (self->heartBeat) {
            if ([self->heartBeat respondsToSelector:@selector(isValid)]){
                if ([self->heartBeat isValid]){
                    [self->heartBeat invalidate];
                    self->heartBeat = nil;
                }
            }
        }
    })
}

//初始化心跳
- (void)initHeartBeat {
    dispatch_main_async_safes(^{
        [self destoryHeartBeat];
        //心跳设置为3分钟，NAT超时一般为5分钟
        self->heartBeat = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(sendHeart) userInfo:nil repeats:YES];
        //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
        [[NSRunLoop currentRunLoop] addTimer:self->heartBeat forMode:NSRunLoopCommonModes];
    })
}

- (void)sendHeart {
    //发送心跳 和后台可以约定发送什么内容  一般可以调用ping  我这里根据后台的要求 发送了data给他
    NSDictionary *dic = @{@"type":@"pong"};
    NSString *jsonString = [CommonTools convertToJsonData:dic];
    [self sendData:jsonString];
}


//pingPong
- (void)ping {
    if (self.socket.readyState == SR_OPEN) {
        [self.socket sendPing:nil];
    }
}

/// 重复发送首页指数获取，延时3秒
- (void)repeatSend {
    //type = -1 全部 1 足球  2 篮球
    //
    if (self.type == 1) {
        [self sendData:@"1-1"];
    }else if (self.type == 2) {
        [self sendData:@"1-2"];
    }else {
        [self sendData:@"1-0"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self repeatSend];
    });
}

/// 获得比赛类型+比赛ID，返回[比赛类型+比赛ID, 分开后数据]
- (NSArray *)getMSG:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"~"];
    if (arr.count <= 2) {
        return nil;
    }
    return @[[NSString stringWithFormat:@"%@-%@", arr[0], arr[1]], arr];
}

- (NSString *)getGameId:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"~"];
    if (arr.count <= 1) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@", arr[1]];
}

- (NSArray *)getInfo:(NSString *)msgID {
    return self.datas[msgID];
}

- (void)cleaDatas {
    [self.datas removeAllObjects];
    [self.datasNewStateDic removeAllObjects];
}

- (ChangeModel *)getChangeModel:(NSString *)msgID {
    ChangeModel *model = self.datasNewStateDic[msgID];
    if (model == nil) {
        model = [ChangeModel new];
    }
    return model;
}

/// 整理新的和老的数据
- (NSArray *)checkFootballOld:(NSArray *)old toNew:(NSArray *)newArr withChangeModel:(ChangeModel *)changeModel {
    NSMutableArray *result = [newArr mutableCopy];
    NSInteger count = result.count;
    if (count >= 11) {
        NSString *o1 = old[10];
        NSString *o2 = old[9];
        NSString *o3 = old[8];
        NSString *n1 = result[10];
        NSString *n2 = result[9];
        NSString *n3 = result[8];
        changeModel.fyz = true;
        changeModel.foz = true;
        changeModel.fsz = true;
        if ([n1 isEqualToString:@"no"]) {
            n1 = o1;
            changeModel.fsz = false;
        } else if ([n1 isEqualToString:o1]) {
            changeModel.fsz = false;
        }
        if ([n2 isEqualToString:@"no"]) {
            n2 = o2;
            changeModel.foz = false;
        } else if ([n2 isEqualToString:o2]) {
            changeModel.foz = false;
        }
        if ([n3 isEqualToString:@"no"]) {
            n3 = o3;
            changeModel.fyz = false;
        } else if ([n3 isEqualToString:o3]) {
            changeModel.fyz = false;
        }
        result[10] = n1;
        result[9] = n2;
        result[8] = n3;
    }
    return result;
}

- (NSArray *)checkLQOld:(NSArray *)old toNew:(NSArray *)newArr withChangeModel:(ChangeModel *)changeModel {
    NSMutableArray *result = [newArr mutableCopy];
    NSInteger count = result.count;
    if (count >= 10) {
        NSString *o1 = old[6];
        NSString *n1 = result[6];
        NSString *o2 = old[9];
        NSString *o3 = old[8];
        NSString *n2 = result[9];
        NSString *n3 = result[8];
        changeModel.bt1 = true;
        changeModel.bt2 = true;
        changeModel.bf = true;
        if ([n1 isEqualToString:@"no"]) {
            n1 = o1;
            changeModel.bf = false;
        } else if ([n1 isEqualToString:o1]) {
            changeModel.bf = false;
        }
        if ([n2 isEqualToString:@"no"]) {
            n2 = o2;
            changeModel.bt2 = false;
        } else if ([n2 isEqualToString:o2]) {
            changeModel.bt2 = false;
        }
        if ([n3 isEqualToString:@"no"]) {
            n3 = o3;
            changeModel.bt1 = false;
        } else if ([n3 isEqualToString:o3]) {
            changeModel.bt1 = false;
        }
        result[6] = n1;
        result[9] = n2;
        result[8] = n3;
    }
    return result;
}

#pragma mark - **************** SRWebSocketDelegate
/************************** socket 连接成功**************************/
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"socket 连接成功");
    //每次正常连接的时候清零重连时间
    reConnectTime = 0;
    //开启心跳
//    [self initHeartBeat];
}

/************************** socket 连接失败**************************/
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"socket 连接失败");
//    if (webSocket == self.socket) {
//        _socket = nil;
//        //连接失败就重连
//        [self reConnect];
//    }
}

/************************** socket连接断开**************************/
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"socket 断开");
    if (webSocket == self.socket) {
        [self SRWebSocketClose];
        
    }
}

/*
 该函数是接收服务器发送的pong消息，其中最后一个是接受pong消息的，
 在这里就要提一下心跳包，一般情况下建立长连接都会建立一个心跳包，
 用于每隔一段时间通知一次服务端，客户端还是在线，这个心跳包其实就是一个ping消息，
 我的理解就是建立一个定时器，每隔十秒或者十五秒向服务端发送一个ping消息，这个消息可是是空的
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    KKLog(@"reply===%@",reply);
}

//接受到消息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    //NSLog(@"socket 收到消息:%@", message);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[(NSString *)message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    NSArray *liveList = [(NSDictionary *)[dic objectForKey:@"data"] objectForKey:@"liveList"];
    NSArray *finishList = [(NSDictionary *)[dic objectForKey:@"data"] objectForKey:@"finishList"];
    for (NSString *string in liveList) {
        NSArray *arr = [self getMSG:string];
        NSArray *old = self.datas[arr.firstObject];
        NSArray *newV = arr.lastObject;
        if (old == nil) {
            self.datas[arr.firstObject] = arr.lastObject;
            self.datasNewStateDic[arr.firstObject] = [ChangeModel new];
        } else {
            if ([(NSString *)newV.firstObject isEqualToString:@"1"]) {
                self.datas[arr.firstObject] = [self checkFootballOld:old toNew:newV withChangeModel:self.datasNewStateDic[arr.firstObject]];
            } else {
                self.datas[arr.firstObject] = [self checkLQOld:old toNew:newV withChangeModel:self.datasNewStateDic[arr.firstObject]];
            }
        }
    }
    
    if (finishList.count > 0) {
        NSMutableArray *finish = [NSMutableArray array];
        for (NSString *string in finishList) {
            NSString *idStr = [self getGameId:string];
            if ([CommonTools isBlankString:idStr]) {
                [finish addObject:idStr];
            }
        }
        if (finish.count > 0) {
            self.finishiIdArray = finish;
            [[NSNotificationCenter defaultCenter] postNotificationName:RecieveFinishListData object:nil];
        }
    }
     
}

#pragma mark - **************** setter getter
- (SRReadyState)socketReadyState {
    return self.socket.readyState;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
