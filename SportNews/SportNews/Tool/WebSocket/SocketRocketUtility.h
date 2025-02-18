//
//  SocketRocketUtility.h
//  SUN
//
//  Created by 孙俊 on 17/2/16.
//  Copyright © 2017年 SUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>

extern NSString * const kNeedPayOrderNote;
extern NSString * const kWebSocketDidOpenNote;
extern NSString * const kWebSocketDidCloseNote;
extern NSString * const kWebSocketdidReceiveMessageNote;

@protocol SocketRocketUtilityDelegate <NSObject>

//接受到信息 直播的
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message; 

//已经打开
- (void)webSocketDidOpen:(SRWebSocket *)webSocket ;

//已经断开
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

@end


@interface SocketRocketUtility : NSObject

/** 获取连接状态 */
@property (nonatomic,assign,readonly) SRReadyState socketReadyState; 

@property (nonatomic, weak) id <SocketRocketUtilityDelegate> delegate;


/** 开始连接 直播的*/
- (void)SRWebSocketOpenWithURLString:(NSString *)urlString;

/** 发送数据 */
- (void)sendData:(id)data;
   
/** 关闭连接 不重连 */
- (void)SRWebSocketClose;

/** 关闭连接 */
- (void)qiangzhiSRWebSocketClose;


/** 重新连接 */
- (void)reConnectSocket;


+ (SocketRocketUtility *)instance;


@end


