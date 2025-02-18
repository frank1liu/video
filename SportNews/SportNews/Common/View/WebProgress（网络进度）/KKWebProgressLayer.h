//
//  KKWebProgressLayer.h
//  Community
//
//  Created by K哥 on 2020/5/1.
//  Copyright © 2020 K哥. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKWebProgressLayer : CAShapeLayer

// 开始加载
- (void)startLoad;
// 完成加载
- (void)finishedLoadWithError:(NSError * __nullable)error;
// 关闭时间
- (void)closeTimer;

- (void)wkWebViewPathChanged:(CGFloat)estimatedProgress;



@end

NS_ASSUME_NONNULL_END
