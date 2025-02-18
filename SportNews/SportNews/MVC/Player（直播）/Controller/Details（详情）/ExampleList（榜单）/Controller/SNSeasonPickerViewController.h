//
//  SNSeasonPickerViewController.h
//  SportNews
//
//  Created by 根哥 on 2021/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNSeasonPickerViewController : UIViewController

@property(nonatomic, copy) NSString *selectStr;

@property (nonatomic, copy) void(^selectSeasonBlock)(NSString *string);

@end

NS_ASSUME_NONNULL_END
