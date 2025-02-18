//
//  SNExampleBaseHeaderView.m
//  SportNews
//
//  Created by 根哥 on 2021/3/10.
//

#import "SNExampleBaseHeaderView.h"
#import "SNTeamRankHeaderView.h"
#import "SNFenQuRankHeaderView.h"
#import "SNPlayerDefenHeaderView.h"

@implementation SNExampleBaseHeaderView

+ (instancetype)headerWithTableView:(UITableView *)tableView exampleModel:(SNBasketTeamRankResult *)model{
    NSString *reuseHeaderId = model.reuseSectionHeaderType;
    SNExampleBaseHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderId];
    
    if (header == nil) {
        Class cls = NSClassFromString(reuseHeaderId);
        header = [[cls alloc]initWithReuseIdentifier:reuseHeaderId];
    }
    return header;
}

- (void)setModel:(SNBasketTeamRankResult *)model{
    _model = model;
    
}

 

@end
