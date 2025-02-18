//
//  LoginCodeView.m
//  SportNews
//
//  Created by kkk on 2020/12/4.
//

#import "LoginCodeView.h"

#define WIDTH         self.setFrame.size.width
#define K_H  self.setFrame.size.height
#define PADDING 10

@interface LoginCodeView ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSMutableArray *lines;

@property (nonatomic, strong) NSMutableArray *labels;

@property(nonatomic, strong) CAShapeLayer *lastLine;

@property (nonatomic, assign) NSInteger inputT;

@property (nonatomic, assign) CGRect setFrame;

@end

@implementation LoginCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /// 配置颜色
        _inputT = 4;
        self.setFrame = frame;
    }
    return self;
}

- (void)setInputType:(NSInteger)inputType {
    _inputT = inputType;
}

- (void)initSubviews {
    /// 优先初始化textView
    [self addSubview:self.textView];
    _textView.frame = CGRectMake(0, 0, WIDTH, self.setFrame.size.height);
    /// 初始化一个输入框
    for (int i = 0; i < _inputT; i ++) {
        /// 1 背景
        UIView *subView = [UIView new];
        float sizeW = (WIDTH - 20 - (_inputT-1) * PADDING) / _inputT;
        subView.frame = CGRectMake((sizeW + PADDING) * i, 0, sizeW, K_H);
        subView.userInteractionEnabled = NO;
        [self addSubview:subView];
        
        /// 2 Label
        UILabel *label = [UILabel new];
        label.textColor = UIColor.blackColor;
        label.frame = CGRectMake(0, K_H-25, sizeW, 25);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        [subView addSubview:label];
        
        /// 3 下划线
        UIView *lineView = [UIView new];
        lineView.frame = CGRectMake(0, K_H-1, sizeW, 1);
        lineView.backgroundColor = UIColor.lightGrayColor;
        [subView addSubview:lineView];
        
        /// 4 光标
        UIColor *lineColor = UIColor.blackColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(sizeW / 2, K_H-20, 2, 15)];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path = path.CGPath;
        line.fillColor =  lineColor.CGColor;
        [subView.layer addSublayer:line];
        line.hidden = YES;
        
        if (i == _inputT-1) {
            /// 5 最后光标
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(sizeW/2+10, K_H-20, 2, 15)];
            CAShapeLayer *line = [CAShapeLayer layer];
            self.lastLine = line;
            line.path = path.CGPath;
            line.fillColor = lineColor.CGColor;
            [subView.layer addSublayer:line];
            line.hidden = YES;
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
        }
        /// 把光标对象和label对象装进数组
        [self.lines addObject:line];
        [self.labels addObject:label];
    }
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self textViewDidChange:textView];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.lastLine.hidden = YES;
    for (int i = 0; i < self.lines.count; i++) {
        CAShapeLayer *line = self.lines[i];
        line.hidden = YES;
    }
}

/// textView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    NSString *verStr = textView.text;
    
    if (verStr.length > _inputT) {
        textView.text = [textView.text substringToIndex:_inputT];
        return;
    }
    if (self.codeBlock) {
        self.codeBlock(textView.text);
    }
    self.lastLine.hidden = YES;
    for (int i = 0; i < _labels.count; i ++) {
        UILabel *bgLabel = _labels[i];
        if (i < verStr.length) {
            [self changeViewLayerIndex:i linesHidden:YES];
            bgLabel.text = [verStr substringWithRange:NSMakeRange(i, 1)];
            if (i == verStr.length-1&&verStr.length == _inputT) {
                self.lastLine.hidden = NO;
            }
        }else {
            [self changeViewLayerIndex:i linesHidden:i == verStr.length ? NO : YES];
            /// textView的text为空的时候
            if (!verStr && verStr.length == 0) {
                [self changeViewLayerIndex:0 linesHidden:NO];
            }
            bgLabel.text = @"";
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [self validateNumber:text];
}

- (BOOL)validateNumber:(NSString*)number {
    
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


/// 光标 和 背景 显示或者隐藏
- (void)changeViewLayerIndex:(NSInteger)index linesHidden:(BOOL)hidden {
    CAShapeLayer *line = self.lines[index];

    if (hidden) {
        [line removeAnimationForKey:@"kOpacityAnimation"];
    }else{
        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }
    [UIView animateWithDuration:0.25 animations:^{
        line.hidden = hidden;
    }];
    
}
/// 闪动动画
- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 1;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}
/// 对象初始化
- (NSMutableArray *)lines {
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}
- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.tintColor = [UIColor clearColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textView;
}

 


@end
