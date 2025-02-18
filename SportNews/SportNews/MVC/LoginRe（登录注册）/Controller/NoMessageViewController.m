//
//  NoMessageViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/4.
//

#import "NoMessageViewController.h"

@interface NoMessageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *knowBtn;

@end

@implementation NoMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}

- (void)setupSubViews {
    
    self.titleString = @"收不到信息";
    self.backView.layer.cornerRadius = 8;
    self.backView.layer.borderColor = lineViewColor.CGColor;
    self.backView.layer.borderWidth =1;
    
    self.addressLabel.textColor = Blue_Color;
    self.knowBtn.layer.cornerRadius = 5;
    self.knowBtn.backgroundColor = Blue_Color;
    
    self.contentTextView.text = @"·1231\n·1231\n·1231";
}

- (IBAction)knowBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
