//
//  NSString+Extension.m
//  ScenicNav
//
//  Created by laoK on 2019/1/21.
//  Copyright © 2020 Talk2all (HK) Company Limited. All rights reserved.
//

#import "NSString+Extension.h"
  
@implementation NSString (Extension)

- (BOOL)isBlankString {
    
    if (!self) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!self.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [self stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

- (NSString *)localized {
    return NSLocalizedString(self, @"");
}

+ (BOOL)isChinaLanguage {
    NSString *languageStr = [self getPreferredLanguage];
    if ([languageStr isEqualToString:@"zh-Hans"] ||
        [languageStr isEqualToString:@"zh-Hans-US"] ||
        [languageStr isEqualToString:@"zh-Hans-HK"] ||
        [languageStr isEqualToString:@"zh-Hans-CN"] ||
        [languageStr isEqualToString:@"zh-Hans-IN"])  {
        return YES;
    } else  {
        return NO;
    }
}

+ (NSString*)getPreferredLanguage {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    return preferredLang;
}


@end
