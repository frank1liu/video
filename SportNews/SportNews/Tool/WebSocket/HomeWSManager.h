//
//  HomeWSManager.h
//  SportNews
//
//  Created by yuhua on 2021/3/18.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>
#import "SportNews-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeWSManager : NSObject

/** 获取连接状态 */
@property (nonatomic,assign,readonly) SRReadyState socketReadyState;

@property(nonatomic, strong, nullable) NSArray *finishiIdArray;

@property(nonatomic, assign) NSInteger type;
 

/** 开始连接*/
- (void)SRWebSocketOpenWithURLString:(NSString *)urlString;

/** 发送数据 */
- (void)sendData:(id)data;
   
/** 关闭连接 */
- (void)SRWebSocketClose;

/** 重新连接 */
- (void)reConnectSocket;

- (void)cleaDatas;

/// 获得数据变化信息
- (NSArray *)getInfo:(NSString *)msgID;

/// 获得改变model
- (ChangeModel *)getChangeModel:(NSString *)msgID;

+ (HomeWSManager *)instance;

@end

NS_ASSUME_NONNULL_END
