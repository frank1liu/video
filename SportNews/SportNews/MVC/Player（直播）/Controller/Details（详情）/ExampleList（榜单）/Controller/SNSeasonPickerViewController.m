//
//  SNSeasonPickerViewController.m
//  SportNews
//
//  Created by 根哥 on 2021/3/17.
//

#import "SNSeasonPickerViewController.h"

@interface SNSeasonPickerViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIPickerView *pickerVIew;
@property(nonatomic,strong)NSArray *seasonArray;
@property(nonatomic,copy)NSString *selectedSeason;
@property(nonatomic,strong)NSDictionary *dictionary;

@property (nonatomic, strong) UIView                   *toolBar;
@property (nonatomic, strong) UITextField              *textField;

@end

@implementation SNSeasonPickerViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    [self setupSubviews];
    
}

- (void)setupSubviews{
    self.seasonArray = @[@"20-21常规赛",
                           @"19-20常规赛",
                           @"18-19常规赛",
                           @"17-18常规赛"];
    
    self.selectedSeason = [self.selectStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    textField.inputView = self.pickerVIew;
    textField.inputAccessoryView = self.toolBar;
    textField.alpha = 0;
    self.textField = textField;
    [self.view addSubview:textField];
     
    NSInteger index = 0;
    for (int i = 0; i < self.seasonArray.count; i++) {
        if ([self.selectStr isEqualToString:self.seasonArray[i]]) {
            index = i;
            break;
        }
    }
    [self.pickerVIew selectRow:index inComponent:0 animated:YES]; 
}

- (void)sureClickedEvent{
    [self.textField resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.selectSeasonBlock) {
        self.selectSeasonBlock(self.selectedSeason);
    }
}

- (void)cancleClickedEvent{
    [self.textField resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}

//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//设置指定列包含的项数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.seasonArray.count;
}

//设置每个选项显示的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
       
    return self.seasonArray[row];
}

//用户进行选择
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
        
    self.selectedSeason = self.seasonArray[row];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}

//懒加载
- (UIPickerView *)pickerVIew{
    if (_pickerVIew == nil) {
        self.pickerVIew = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
        _pickerVIew.backgroundColor = UIColor.whiteColor;
        _pickerVIew.delegate = self;
        _pickerVIew.dataSource = self;
    }
    
    return _pickerVIew;
}

- (UIView *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _toolBar.backgroundColor = UIColor.whiteColor;
        UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 10, 40, 20)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        cancleBtn.titleLabel.font  = [UIFont systemFontOfSize:14];
        [cancleBtn addTarget:self action:@selector(cancleClickedEvent) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 52, 10, 40, 20)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:Blue_Color forState:UIControlStateNormal];
        sureBtn.titleLabel.font  = [UIFont systemFontOfSize:14];
        [sureBtn addTarget:self action:@selector(sureClickedEvent) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 0.5)];
        lineView.backgroundColor = lineViewColor;
        [_toolBar addSubview:lineView];
        [_toolBar addSubview:cancleBtn];
        [_toolBar addSubview:sureBtn];
        

    }
    return _toolBar;
}

@end
