//
//  UIImage+Extension.h
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright © 2020 Talk2all (HK) Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  根据图片名自动加载适配iOS6\7的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;
/**
 *  UIColor转化成UIImage对象
 */
+(UIImage*) createImageWithColor:(UIColor*) color;

//图片拼接 类似微信群聊头像
+ (UIImage *)groupIconWith:(NSArray *)array bgColor:(UIColor *)bgColor;
+ (UIImage *)groupIconWithURLArray:(NSArray *)URLArray bgColor:(UIColor *)bgColor;

- (UIImage *)resizableImage;

- (UIImage *)resizeImageToSize:(CGSize)size;

@end
