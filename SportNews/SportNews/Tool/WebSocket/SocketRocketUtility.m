//
//  SocketRocketUtility.m
//  SUN
//
//  Created by 孙俊 on 17/2/16.
//  Copyright © 2017年 SUN. All rights reserved.
//

#import "SocketRocketUtility.h"
#import "MSNetwork.h"

#define dispatch_main_async_safes(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

NSString * const kNeedPayOrderNote               = @"kNeedPayOrderNote";
NSString * const kWebSocketDidOpenNote           = @"kWebSocketDidOpenNote";
NSString * const kWebSocketDidCloseNote          = @"kWebSocketDidCloseNote";
NSString * const kWebSocketdidReceiveMessageNote = @"kWebSocketdidReceiveMessageNote";

@interface SocketRocketUtility()<SRWebSocketDelegate>
{
    int _index;
    NSTimer * heartBeat;
    NSTimeInterval reConnectTime;
}

@property (nonatomic,strong) SRWebSocket *socket;

@property (nonatomic,copy) NSString *urlString;

@property(nonatomic, assign) BOOL isClosed;

@end

@implementation SocketRocketUtility

+ (SocketRocketUtility *)instance {
    static SocketRocketUtility *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[SocketRocketUtility alloc] init];
    });
    return Instance;
}

#pragma mark - **************** public methods
-(void)SRWebSocketOpenWithURLString:(NSString *)urlString {
    
    //如果是同一个url return
//    if (self.socket) {
//        return;
//    }
    
    if (!urlString) {
        return;
    }
    if ([urlString isEqualToString:self.urlString] && self.socket) {
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

- (void)qiangzhiSRWebSocketClose {
    self.urlString = nil;
   [self SRWebSocketClose];
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

#pragma mark - **************** SRWebSocketDelegate
/************************** socket 连接成功**************************/
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    //每次正常连接的时候清零重连时间
    reConnectTime = 0;
    //开启心跳
//    [self initHeartBeat];
    if (webSocket == self.socket) {
        if ([self.delegate respondsToSelector:@selector(webSocketDidOpen:)]) {
            [self.delegate webSocketDidOpen:webSocket];
        }
    }
}

/************************** socket 连接失败**************************/
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
//    if (webSocket == self.socket) {
//        _socket = nil;
//        //连接失败就重连
//        [self reConnect];
//    }
}

/************************** socket连接断开**************************/
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (webSocket == self.socket) {
        [self SRWebSocketClose];
        if ([self.delegate respondsToSelector:@selector(webSocket:didCloseWithCode:reason:wasClean:)]) {
            [self.delegate webSocket:webSocket didCloseWithCode:code reason:reason wasClean:wasClean];
        }
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
    if (webSocket == self.socket) {
        if(!message){
            return;
        }
        if ([self.delegate respondsToSelector:@selector(webSocket:didReceiveMessage:)]) {
            [self.delegate webSocket:webSocket didReceiveMessage:message];
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
