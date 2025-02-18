//
//  LiveMembersViewController.m
//  SportNews
//
//  Created by kkk on 2021/1/16.
//

#import "LiveMembersViewController.h"

@interface LiveMembersViewController ()

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LiveMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavHeight-41);
    [self.view addSubview:self.tableView];
    
}

 

#pragma mark - JXPagerViewListViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y > 0) {
        self.scrollCallback(scrollView);
    }
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

@end
