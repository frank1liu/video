//
//  ChangeNameAndSignController.h
//  SportNews
//
//  Created by kkk on 2020/12/5.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangeNameAndSignController : BaseViewController

@property (nonatomic, copy) void(^changeSuccess)(void);
//1 改名名字 2更改签名
@property(nonatomic, assign) NSInteger whichOne;

@end

NS_ASSUME_NONNULL_END
