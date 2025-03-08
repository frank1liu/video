//
//  SNUserWebViewController.h
//  SportNews
//
//  Created by kkk on 2021/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNUserWebViewController : BaseViewController

//请求链接加载H5
@property (nonatomic , copy) NSString *url;

- (void)setWebViewSize:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
