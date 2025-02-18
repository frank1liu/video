//
//  NSString+Extension.h
//  ScenicNav
//
//  Created by laoK on 2019/1/21.
//  Copyright © 2020 Talk2all (HK) Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

/*
 ** 判断字符串是否为空 是为空
 */
- (BOOL)isBlankString;

+ (BOOL)isChinaLanguage;

- (NSString *)localized;

@end

NS_ASSUME_NONNULL_END
