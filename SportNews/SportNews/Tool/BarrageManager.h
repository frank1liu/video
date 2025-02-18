//
//  BarrageManager.h
//  SportNews
//
//  Created by yuhua on 2021/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BarrageManager : NSObject

+ (instancetype)shareManager;
 
/// 移除弹幕view
- (void)removeBarrage;

/// 是否停止并清空弹幕
- (void)stopBarrage:(BOOL)stop;

///清空弹幕
- (void)clearBarrage;

/// 创建弹幕view
- (void)buildBarrageTo:(UIView *)superView;

/// 获取弹幕view
- (UIView *)getBarrageView;

/// 添加富文本弹幕
- (void)addAttrBarrage:(NSAttributedString *)content delay:(CGFloat)delay;

/// 将弹幕开启关闭状态记录下来
- (void)saveDanMu:(BOOL)open;

/// 获得弹幕开启关闭状态，on开 off关 nil未设置
- (NSString *)getDanMu;

@end

NS_ASSUME_NONNULL_END
