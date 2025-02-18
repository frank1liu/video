//
//  SNGoalNewsAlertView.m
//  SportNews
//
//  Created by kiss on 2021/4/6.
//

#import "SNGoalNewsAlertView.h"

@interface SNGoalNewsAlertView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *datasArray;

@end

@implementation SNGoalNewsAlertView

- (NSMutableArray *)datasArray {
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}
 

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (void)setAddModelArray:(NSArray *)addModelArray {
    _addModelArray = addModelArray;
    for (int i = 0; i < addModelArray.count; i++) {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    }
    [self.datasArray addObjectsFromArray:addModelArray];
}

- (UITableView *)tableView {
    if (!_tableView) {
        //44是page的高度
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor =UIColor.clearColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, xBottomHeight + 10, 0);
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
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
