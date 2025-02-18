//
//  OtherLiveDetailVC.m
//  SportNews
//
//  Created by yuhua on 2021/5/6.
//

#import "OtherLiveDetailVC.h"
#import "LiveContentBottomView.h"
#import "SNLiveDetailNaviView.h"

@interface OtherLiveDetailVC ()

@end

@implementation OtherLiveDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
     
     
    [self setupSubViews];
    
}

- (void)setupSubViews {
    [self setupCategoryView];
    self.tBackgroundView.hidden = YES;
    
    [self.naviView hideOtherNoNeedView];
    WeakSelf;
    self.naviView.navBackBlock = ^(NSInteger tag) {
        if (tag == 1) { 
            weakSelf.isClickPop = YES;
            /// 这里怎么操作，直接返回上一页？还是和足球篮球一样，有待确定。
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            //分享
            [weakSelf shareMethod];
        }
    };
    //self.bottomView.otherBackView.hidden = NO;
    //self.bottomView.otherTitleLabel.text = [NSString stringWithFormat:@"%@\n%@",self.model.cname, self.model.otherTitle];
}

//点击分享
- (void)shareMethod {
    
}

- (void)getDatas {
   NSMutableDictionary *param = @{
       @"mid" : self.model.ID,
       @"sporttype" : self.model.type
   }.mutableCopy;
   LoginUserModel *loginModel = [UserModelTool loginModel];
   if (loginModel) {
       [param setValue:loginModel.uid forKey:@"uid"];
       [param setValue:loginModel.token forKey:@"token"];
   }
   [KYRemindView show];
   WeakSelf
   [KYApiHttpTool GET:URL_OTHER_MATCH_DETAIL withParams:param success:^(NSDictionary * _Nonnull response) {
        
         
   } failure:^(NSError * _Nonnull error) {
       [MBProgressHUD hideHUDForView:weakSelf.view];  
   }];
}

- (void)dealloc {
    NSLog(@"%@被释放了", [self class]);
}

@end
