//
//  BaseViewController.h
//  V-talk
//
//  Created by K哥 on 2020/4/1.
//  Copyright © 2020 K哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic , strong) NSString  *titleString;

@property (nonatomic , strong) UIColor *titleColor;

@property (nonatomic , strong) BaseNavView *navView;

@end

NS_ASSUME_NONNULL_END
