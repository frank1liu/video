//
//  CommonWebViewController.h
//  StockExchange
//
//  Created by K哥 on 2020/12/15.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonWebViewController : BaseViewController

//请求链接加载H5
@property (nonatomic , copy) NSString *url;

//加载html标签
@property (nonatomic , copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
