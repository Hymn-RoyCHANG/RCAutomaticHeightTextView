//
//  TextViewInTableViewCell.m
//  RCAutomaticHeightTextView
//
//  Created by Roy on 2017/3/28.
//  Copyright © 2017年 Roy CHANG. All rights reserved.
//

#import "TextViewInTableViewCell.h"
#import "RCAutomaticHeightTextView.h"

///布局方式开关
#define  RC_CELL_FRAME  1

const CGFloat g_Cell_Margin = 10.f;

static NSString *g_Normal_Cell = @"normal_cell";
static NSString *g_TextView_Cell = @"text_view_cell";

@interface TextViewInTableViewCell ()
{
    RCAutomaticHeightTextView *_textView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) CGFloat textViewHeight;

@end

@implementation TextViewInTableViewCell

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _textViewHeight = 120;
    _tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    ///释放
    [_textView removeFromSuperview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 50;
    if(1 == indexPath.row)
    {
        rowHeight = _textViewHeight + 2 * g_Cell_Margin;
    }
    
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = 1 == indexPath.row ? g_TextView_Cell : g_Normal_Cell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(1 == indexPath.row && 0 == [cell.contentView.subviews count])
    {//这个只是演示初始化的操作
        
#if !RC_CELL_FRAME
        _textView = [[RCAutomaticHeightTextView alloc] initWithFrame:CGRectMake(g_Cell_Margin, g_Cell_Margin, [UIScreen mainScreen].bounds.size.width - 2 * g_Cell_Margin, _textViewHeight)];
        [cell.contentView  addSubview:_textView];
#else
        _textView = [[RCAutomaticHeightTextView alloc] init];
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:_textView];
        
        NSString *h = @"H:|-g_Cell_Margin-[_textView]-g_Cell_Margin-|";
        NSString *v = @"V:|-g_Cell_Margin-[_textView(==_textViewHeight)]";
        NSArray *ah = [NSLayoutConstraint constraintsWithVisualFormat:h options:kNilOptions metrics:@{@"g_Cell_Margin" : @(g_Cell_Margin)} views:NSDictionaryOfVariableBindings(_textView)];
        NSArray *av = [NSLayoutConstraint constraintsWithVisualFormat:v options:kNilOptions metrics:@{@"g_Cell_Margin" : @(g_Cell_Margin), @"_textViewHeight" : @(_textViewHeight)} views:NSDictionaryOfVariableBindings(_textView)];
        
        [cell.contentView addConstraints:av];
        [cell.contentView addConstraints:ah];
#endif
        
        _textView.layer.borderColor = [[UIColor blackColor] CGColor];
        _textView.layer.borderWidth = 1.0f;
        _textView.layer.cornerRadius = 8.f;
        _textView.layer.masksToBounds = YES;
        _textView.maxHeight = 250.f;
        //_textView.text = @"4.1 安装doxygen\
        　　doxygen支持源码编译安装与dmg安装。想省事的话，可以选择dmg安装。去doxygen官网（http://www.stack.nl/~dimitri/doxygen/download.html）下载最新的dmg。\
        　　dmg下载下来后，双击加载dmg，然后把.app文件拖入应用程序文件夹，便完成了安装。\
        \
        4.2 生成html\
        　　doxygen有图形界面，可通过Launchpad打开。\
        \
        　　在step 1中选择好项目的路径。\
        　　step 2默认是Wizard->Project页面，在其中——\
        1) 在“Project name”中填写项目名。\
        2) 勾选“Sacn recursively”，扫描所有的子文件夹。\
        3) 在“Destination directory”中填写好文档的输出目录。这里我填的是“docs”。";
        
        typeof(&*self) __weak weakSelf = self;
        _textView.frameChangedBlock = ^(CGRect frame)
        {
            weakSelf.textViewHeight = frame.size.height;
            
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView endUpdates];
        };
    }
    
    return cell;
}

@end
