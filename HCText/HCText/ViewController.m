//
//  ViewController.m
//  HCText
//
//  Created by 衡前进 on 2018/12/11.
//  Copyright © 2018 HelloC. All rights reserved.
//

#import "ViewController.h"
#import "HCTextField.h"
#import "UIView+WidthHeight.h"
/**
 * RGB 颜色
 */
#define kColor(R,G,B,A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A] 
#define KAPP_COLOR kColor(8, 189, 145, 1)
#define k_TextColor170 kColor(170, 170, 170, 1)
/**
 * 屏幕宽高
 */
#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView * alphaLine;
@end

@implementation ViewController

- (UIView *)alphaLine {
    if (_alphaLine == nil) {
        _alphaLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 21)];
        _alphaLine.backgroundColor = KAPP_COLOR;
        
        CALayer *layer = _alphaLine.layer;
        [layer removeAnimationForKey:@"kFlickerAnimation"];
        [layer addAnimation:[self alphaAnimation] forKey:@"kFlickerAnimation"];
    }
    return _alphaLine;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat space = (KScreenWidth - 106 - 43*4)/3;
    for (int i = 0; i < 4; i ++) {
        UITextField * inputTF = [[UITextField alloc] initWithFrame:CGRectMake(i*(space + 43) + 53, 300, 43, 43)];
        inputTF.tag = 200 + i;
        inputTF.textAlignment = NSTextAlignmentCenter;
        inputTF.layer.borderWidth = 1;
        inputTF.layer.borderColor = k_TextColor170.CGColor;
        inputTF.userInteractionEnabled = NO;
        inputTF.layer.cornerRadius = 5;
        [self.view addSubview:inputTF];
    }
    self.alphaLine.x = 53 + 21;
    self.alphaLine.y = 300 + 11;
    [self.view addSubview:self.alphaLine];
    
    UITextField * textTF = [[HCTextField alloc]initWithFrame:CGRectMake(53, 300 + 37, KScreenWidth - 106, 43)];
    textTF.keyboardType = UIKeyboardTypeNumberPad;
    textTF.delegate = self;
    textTF.tintColor = [UIColor clearColor];
    textTF.textColor = [UIColor clearColor];
    textTF.tag = 300;
    [textTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [textTF becomeFirstResponder];
    
    [self.view addSubview:textTF];
}

#pragma mark - 输入判断
/**
 *  输入判断
 */
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.tag == 300) {
        NSInteger count = textField.text.length;
        CGFloat space = (KScreenWidth - 106 - 43*4)/3;
        self.alphaLine.x = 53 + 21 + (space + 43)*count;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 300) {
        NSLog(@"text:%@", textField.text);
        NSLog(@"location:%ld  length:%ld", range.location, range.length);
        NSLog(@"string:%@", string);
 
        NSInteger count = textField.text.length;
        if (count + string.length > 4) {  //达到4位验证码
            [self.view endEditing:YES];
            [self hideAnimation];
            return NO;
        }
        if (textField.text.length == 4 && range.length > 0) { //4位验证码时候删除
            [self displayAnimation];
        }
        if (string.length > 0) { //输入验证码
            UITextField * text = [self.view viewWithTag:200 + count];
            text.text = string;
        }
        if (range.length > 0) { //删除验证码
            UITextField * text = [self.view viewWithTag:199 + count];
            text.text = @"";
        }
    }
    return YES;
}
/**
 * 闪动光标动画
 */
- (CABasicAnimation *)alphaAnimation{
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @(1.0);
    alpha.toValue = @(0.0);
    alpha.duration = 1.0;
    alpha.repeatCount = CGFLOAT_MAX;
    alpha.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return alpha;
}
/**
 * 隐藏光标动画
 */
- (void)hideAnimation {
    CALayer *layer = self.alphaLine.layer;
    layer.hidden = YES;
    [layer removeAnimationForKey:@"kFlickerAnimation"];
}
//x重新显示光标
- (void)displayAnimation {
    CALayer *layer = self.alphaLine.layer;
    layer.hidden = NO;
    [layer addAnimation:[self alphaAnimation] forKey:@"kFlickerAnimation"];
}

@end
