//
//  ChangeGenderViewController.h
//  SportNews
//
//  Created by kkk on 2020/12/5.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangeGenderViewController : BaseViewController

@property (nonatomic, copy) void(^changeSuccess)(void);

@end

NS_ASSUME_NONNULL_END
