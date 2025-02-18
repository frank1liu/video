//
//  SNDatasBasketModel.m
//  SportNews
//
//  Created by kkk on 2021/2/4.
//

#import "SNDatasBasketModel.h"



@implementation SNDatasBasketHistoryRecordModel


- (void)reviseDescribeRang:(NSString *)teamName {
    self.isHome = [teamName isEqualToString:self.hName];
    NSArray *results = [self.scoreQuan componentsSeparatedByString:@"-"];
    double home = [results.firstObject doubleValue] - self.scoreRang.doubleValue;
    double away = [results.lastObject doubleValue];
    if (home < away) {
        if ([teamName isEqualToString:self.hName]) {
            if (self.describeRang.length == 1) {
                self.describeRang = @"输";
            }
        } else {
            if (self.describeRang.length == 1) {
                self.describeRang = @"赢";
            }
        }
    } else {
        if ([teamName isEqualToString:self.hName]) {
            if (self.describeRang.length == 1) {
                self.describeRang = @"赢";
            }
        } else {
            if (self.describeRang.length == 1) {
                self.describeRang = @"输";
            }
        }
    }
}

+ (NSMutableAttributedString *)getRecentResultsString:(NSArray *)array isHome:(BOOL)isHome homeName:(NSString *)homeName isHistory:(BOOL)isHistory {
    NSDictionary *red = @{NSForegroundColorAttributeName: red_Color};
    NSDictionary *green = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#73D9D8"]};
    NSMutableAttributedString *result = [NSMutableAttributedString new];
    NSInteger win = 0;
    NSInteger lost = 0;
    NSInteger single = 0;
    NSInteger dual = 0;
    NSInteger s100 = 0;
    NSInteger yValue = 0;
    NSInteger y100 = 0;
    NSInteger dValue = 0;
    NSInteger d100 = 0;
    for (SNDatasBasketHistoryRecordModel *model in array) {
        if ([[CommonTools getScoreResult:model.scoreQuan isHome:[model.hName isEqualToString:homeName]] isEqualToString:@"赢"]) {
            win += 1;
        } else {
            lost += 1;
        }
        if (model.totalScoreQuan.integerValue % 2 == 0) {
            dual += 1;
        } else {
            single += 1;
        }
        if ([model.describeRang isEqualToString:@"赢"]) {
            yValue += 1;
        }
        if ([model.describeZong isEqualToString:@"大"]) {
            dValue += 1;
        }
    }
    float total = (float)(array.count == 0 ? 1 : array.count);
    s100 = (NSInteger)(((float)win/total)*100);
    y100 = (NSInteger)(((float)yValue/total)*100);
    d100 = (NSInteger)(((float)dValue/total)*100);
    if (!isHistory) {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:isHome ? @"主队" : @"客队"]];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" 近%ld场", array.count]]];
    } else {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"近%ld场", array.count]]];
    }
    if (!isHistory) {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %ld", win] attributes:red]];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"胜"]];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", lost] attributes:green]];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"负"]];
    } else {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"交锋"]];
    }
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %ld", single] attributes:red]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"单"]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", dual] attributes:green]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"双"]];
    if (isHistory) {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", homeName]]];
    }
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@" 胜率"]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%%", s100] attributes:red]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@" 赢率"]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%%", y100] attributes:red]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@" 大率"]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%%", d100] attributes:red]];
    return result;
}

@end


 
