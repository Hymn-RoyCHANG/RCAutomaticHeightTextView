//
//  ViewController.m
//  RCAutomaticHeightTextView
//
//  Created by Roy on 2017/3/26.
//  Copyright © 2017年 Roy CHANG. All rights reserved.
//

#import "ViewController.h"

#import "Class/RCAutomaticHeightTextView.h"

///布局方式开关
#define RC_FRAME    1

@interface ViewController ()
{
    RCAutomaticHeightTextView *_textView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(138, 160, 80, 10)];
    line.backgroundColor = [UIColor redColor];
    [self.view addSubview:line];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(40, 175, 80, 80);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"不跟随" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
#if !RC_FRAME
    _textView = [[RCAutomaticHeightTextView alloc] initWithFrame:CGRectMake(20, 80, 120, 90)];
    [self.view addSubview:_textView];
#else
    _textView = [[RCAutomaticHeightTextView alloc] init];
    _textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_textView];
    
    NSString *h = @"H:|-20-[_textView(==120)]";
    NSString *v = @"V:|-80-[_textView(==90)]";
    NSArray *ah = [NSLayoutConstraint constraintsWithVisualFormat:h options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_textView)];
    NSArray *av = [NSLayoutConstraint constraintsWithVisualFormat:v options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_textView)];
    
    [self.view addConstraints:av];
    [self.view addConstraints:ah];
    
#endif
    
    _textView.layer.borderColor = [[UIColor blackColor] CGColor];
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.cornerRadius = 8.f;
    _textView.layer.masksToBounds = YES;
    //_textView.text = @"安装doxygen \
    doxygen支持源码编译安装与dmg安装。想省事的话，可以选择dmg安装。去doxygen官网（http://www.stack.nl/~dimitri/doxygen/ download.html）下载最新的dmg。";
    _textView.maxHeight = 180;
    //*/
    _textView.frameChangedBlock = ^(CGRect frame)
    {
        CGRect frame_t = btn.frame;
        frame_t.origin.y = CGRectGetMaxY(frame) + 5;
        btn.frame = frame_t;
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
