//
//  SNGoalNewsAlertView.m
//  SportNews
//
//  Created by kkk on 2021/4/6.
//

#import "SNGoalNewsAlertView.h" 
#import "SNGoalNewsTableViewCell.h"



@interface SNGoalNewsAlertView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *datasArray;

@property(nonatomic, strong) NSTimer *timer;

@end

@implementation SNGoalNewsAlertView

- (NSMutableArray *)datasArray {
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}
 
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    [window addSubview:self];
}


- (void)setupSubviews {
    self.tableView.frame = CGRectMake(0, self.height, self.width, 0);
    [self addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.lightGrayColor;
 
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:true block:^(NSTimer * _Nonnull timer) {
        if (weakSelf.datasArray.count > 0) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                [weakSelf.datasArray removeLastObject];
                [weakSelf.tableView beginUpdates];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datasArray.count inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
                [weakSelf.tableView endUpdates];
            });
            dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC);
            dispatch_after(popTime1, dispatch_get_main_queue(), ^(void) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.tableView.height = 44*self.datasArray.count;
                    weakSelf.tableView.y = self.height-44*self.datasArray.count;
                }];
            });
        }
    }];
}

- (void)setAddModelArray:(NSArray *)addModelArray {
    _addModelArray = addModelArray;
    for (int i = 0; i < addModelArray.count; i++) {
        [self.datasArray insertObject:addModelArray[i] atIndex:0];
    }
    self.tableView.height = 44*self.datasArray.count;
    self.tableView.y = self.height-44*self.datasArray.count;
    [self.tableView reloadData];
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    SNGoalNewsTableViewCell *cell = [SNGoalNewsTableViewCell cellWithTableView:tableView];
    cell.goalModel = self.datasArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableView *)tableView {
    if (!_tableView) {
        //44是page的高度
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor =UIColor.clearColor;
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //设置自动计算行号模式
        _tableView.rowHeight = UITableViewAutomaticDimension;
        //设置预估行高
        _tableView.estimatedRowHeight = 200;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}



@end
