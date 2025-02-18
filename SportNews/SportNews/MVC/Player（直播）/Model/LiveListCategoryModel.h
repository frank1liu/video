//
//  LiveListCategoryModel.h
//  SportNews
//
//  Created by pangchong on 2020/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveListCategoryModel : NSObject

@property(nonatomic, strong) NSNumber *ID;

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) NSString *name_zh;

@property(nonatomic, strong) NSNumber *type;

@end

NS_ASSUME_NONNULL_END
