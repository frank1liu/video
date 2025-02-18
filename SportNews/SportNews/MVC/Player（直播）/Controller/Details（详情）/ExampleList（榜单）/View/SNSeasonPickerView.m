//
//  SNSeasonPickerView.m
//  SportNews
//
//  Created by 根哥 on 2021/3/17.
//

#import "SNSeasonPickerView.h"

@interface SNSeasonPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIPickerView *pickerVIew;
@property(nonatomic,strong)NSArray *provinceArray;
@property(nonatomic,copy)NSString *selectedProvince;
@property(nonatomic,strong)NSDictionary *dictionary;

@end
@implementation SNSeasonPickerView

#pragma mark ------- dateSource&&Delegate --------

- (instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.dictionary = @{@"江苏":@[@"南京",@"徐州",@"镇江",@"无锡",@"常州"],@"河北":@[@"石家庄",@"保定",@"承德",@"沧州",@"秦皇岛"]};
    //获取字典中所有的省份并排序保存
    self.provinceArray = [[self.dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    self.selectedProvince = self.provinceArray[0];
    [self addSubview:self.pickerVIew];
}
//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//设置指定列包含的项数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArray.count;
    }
    return [self.dictionary[self.selectedProvince] count];
}

//设置每个选项显示的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArray[row];
    }
    return [self.dictionary[self.selectedProvince] objectAtIndex:row];
}

//用户进行选择
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.selectedProvince = self.provinceArray[row];
        [self.pickerVIew reloadComponent:1];
        //设置第二列首选的始终是第一个
        [self.pickerVIew selectRow:0 inComponent:1 animated:YES];
    }
}



//懒加载
- (UIPickerView *)pickerVIew{
    if (_pickerVIew == nil) {
        self.pickerVIew = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, self.frame.size.width, 400)];
        _pickerVIew.layer.masksToBounds = YES;
        _pickerVIew.layer.borderWidth = 1;
        _pickerVIew.delegate = self;
        _pickerVIew.dataSource = self;
    }
    
    return _pickerVIew;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
