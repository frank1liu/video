//
//  LiveCartoonModel.h
//  SportNews
//
//  Created by pangchong on 2020/12/28.
//

#import <Foundation/Foundation.h>
#import "MacroOthers.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveCartoonModel : NSObject

//当前主播对应的数字 获取 聊天室
@property(nonatomic, assign) NSInteger room_num;

@property (nonatomic , assign) NSInteger status;

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) NSString *url;

//index=0 主播信号，1 中文高清 2 高清 3中文标清 4 标清
@property (nonatomic , assign) NSInteger index;
 

@end

NS_ASSUME_NONNULL_END
