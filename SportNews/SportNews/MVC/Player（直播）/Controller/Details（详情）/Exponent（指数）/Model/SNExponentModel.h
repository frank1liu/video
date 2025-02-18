//
//  SNExponentModel.h
//  SportNews
//
//  Created by kkk on 2021/2/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNExponentContent : NSObject

// 公司名称
@property(nonatomic, copy) NSString *company_name;
// 真实值
@property(nonatomic, copy) NSString *realtime;
// 公司ID
@property(nonatomic, assign) NSInteger company_id;
// 初始值
@property(nonatomic, copy) NSString *initial;

@end

@interface SNExponentModel : NSObject

// 角球
@property(nonatomic, strong) NSArray *jiaoqiu;
// 欧指
@property(nonatomic, strong) NSArray *ouzhi;
// 大小
@property(nonatomic, strong) NSArray *daxiao;
// 亚指
@property(nonatomic, strong) NSArray *yazhi;

@end

NS_ASSUME_NONNULL_END
