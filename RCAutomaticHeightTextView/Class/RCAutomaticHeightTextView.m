//
//  RCAutomaticHeightTextView.m
//  RCAutomaticHeightTextView
//
//  Created by Roy on 2017/3/26.
//  Copyright © 2017年 Roy CHANG. All rights reserved.
//

#import "RCAutomaticHeightTextView.h"

#ifdef DEBUG
#define RC_LOG(...) NSLog(__VA_ARGS__);
#define RC_LOG2(fmt,...) NSLog((@"\n%s, Line: %d, " fmt), __func__, __LINE__, ##__VA_ARGS__);
#else
#define RC_LOG(...)
#define RC_LOG2(fmt,...)
#endif

const CGFloat RCTextViewHeightDeviation = 5;
const CGFloat RCTextViewSugesstionHeight = 120;
const CGFloat RCTextViewHeightNoLimit = -1;

@interface RCAutomaticHeightTextView ()
{
    BOOL _bOnceFrame;
    BOOL _bSetText;
    CGRect _onceFrame;
}

@property (atomic, assign) BOOL rcStoreEnableScroll;

@property (atomic, assign) BOOL rcEditable;

@end

@implementation RCAutomaticHeightTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_6_1

- (instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer
{
    if(self = [super initWithFrame:frame textContainer:textContainer])
    {
        [self rc_initializer];
        [self rc_kvoAndNotifications:YES];
    }
    
    return self;
}

#else

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self rc_initializer];
        [self rc_kvoAndNotifications:YES];
    }
    
    return self;
}

#endif

#pragma mark - dealloc

- (void)dealloc
{
    _frameChangedBlock = nil;
    [_placeHolderLabel removeFromSuperview];
    _placeHolderLabel = nil;
    
    RC_LOG(@"\n%s.", __func__);
}

#pragma mark - 一些初始化设置

- (void)rc_initializer
{
    self.font = [UIFont systemFontOfSize:16];
    _placeHolderLabel = [[UILabel alloc] init];
    _placeHolderLabel.text = @"空空如也...";
    _placeHolderLabel.backgroundColor = [UIColor clearColor];
    _placeHolderLabel.font = [UIFont systemFontOfSize:15];
    _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    _placeHolderLabel.textColor = [UIColor grayColor];
    _placeHolderLabel.numberOfLines = 0;
    _placeHolderLabel.minimumScaleFactor = .6f;
    _placeHolderLabel.adjustsFontSizeToFitWidth = YES;
    _placeHolderLabel.userInteractionEnabled = NO;
    [_placeHolderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_placeHolderLabel];
    
    CGFloat top = 5;//self.textContainerInset.top;
    CGFloat left = 5;//self.textContainerInset.left;
    
    NSString *h = @"H:|-left-[_placeHolderLabel]-2-|";
    NSString *v = @"V:|-top-[_placeHolderLabel(==24)]";
    NSArray *ah = [NSLayoutConstraint constraintsWithVisualFormat:h options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"left" : @(left)} views:NSDictionaryOfVariableBindings(_placeHolderLabel)];
    NSArray *av = [NSLayoutConstraint constraintsWithVisualFormat:v options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"top" : @(top)} views:NSDictionaryOfVariableBindings(_placeHolderLabel)];
    [self addConstraints:ah];
    [self addConstraints:av];
    
    //变量初始化
    _maxHeight = RCTextViewHeightNoLimit;
    _bOnceFrame = NO;
}

#pragma mark - override hittest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if(!CGRectContainsPoint(self.bounds, point))
    {
        [self resignFirstResponder];
    }
    
    return [super hitTest:point withEvent:event];
}

#pragma mark - override super layoutSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(!_bOnceFrame && !CGRectIsEmpty(self.frame))
    {
        _bOnceFrame = YES;
        _onceFrame = self.frame;
        _maxHeight = _maxHeight < 0 ? RCTextViewHeightNoLimit : MAX(_maxHeight, CGRectGetHeight(self.frame));
        RC_LOG(@"\nOnce Frame Call: %s", __func__);
        
        if(_bSetText)
        {
            _placeHolderLabel.hidden = 0 != self.text.length;
            CGSize size = [self rc_textSize];
            [self rc_updateSize:size];
            self.contentSize = size;
        }
    }//*/
}

#pragma mark - override super text property

- (void)setText:(NSString *)text
{
    [super setText:text];
    _bSetText = YES;
}

- (NSString *)text
{
    NSString *text_t = [super text];
    return text_t ?: @"";
}

#pragma mark - property maxHeight;

- (void)setMaxHeight:(CGFloat)maxHeight
{
    _maxHeight = maxHeight < 0 ? RCTextViewHeightNoLimit : (CGRectIsEmpty(self.frame) ? maxHeight : MAX(maxHeight, CGRectGetHeight(self.frame)));
    RC_LOG(@"\nmaxHeight: %f. _maxHeight: %f.", maxHeight, _maxHeight);
}

#pragma mark - kvo/notifications add or remove

- (void)rc_kvoAndNotifications:(BOOL)add
{
    if(add)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rc_textChangedNotification:) name:UITextViewTextDidChangeNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    }
}

#pragma mark - rc_textChangedNotification selector

- (void)rc_textChangedNotification:(NSNotification *)notify
{
    if(self != notify.object)
    {
        return;
    }
    
    _placeHolderLabel.hidden = 0 != self.text.length;
    [self rc_updateSize:[self rc_textSize]];
}

- (void)rc_textBeginEditingNotification:(NSNotification *)notify
{
    if(self != notify.object)
    {
        return;
    }
}

#pragma mark - calculate text size

- (CGSize)rc_textSize
{
    self.rcStoreEnableScroll = self.scrollEnabled;
    self.scrollEnabled = YES;
    [self.layoutManager ensureLayoutForTextContainer:self.textContainer];
    CGSize textSize = [self.layoutManager usedRectForTextContainer:self.textContainer].size;
    textSize.height += self.textContainerInset.top + self.textContainerInset.bottom;
    self.scrollEnabled = self.rcStoreEnableScroll;
    
    return textSize;
}

#pragma mark - update height

- (void)rc_updateSize:(CGSize)size
{
    CGRect frame = self.frame;
    if((int)size.height <= (int)_onceFrame.size.height || (int)size.height == (int)frame.size.height)
    {
        return;
    }
    
    BOOL _bcallback = NO;
    
    frame.size.height = (RCTextViewHeightNoLimit == _maxHeight) ? size.height : MIN(_maxHeight, size.height);
    if(RCTextViewHeightDeviation > ABS(frame.size.height - _onceFrame.size.height))
    {//计算误差
        frame = _onceFrame;
    }
    
    if(frame.size.height == CGRectGetHeight(self.frame))
    {
        return;
    }
    
    if(self.translatesAutoresizingMaskIntoConstraints)
    {
        self.frame = frame;
        _bcallback = YES;
    }
    else
    {
        NSArray *constraints = [self.superview constraints];
        for(NSLayoutConstraint *constraint in constraints)
        {
            if(self == constraint.firstItem && NSLayoutAttributeHeight == constraint.firstAttribute)
            {
                constraint.constant = frame.size.height;
                _bcallback = YES;
                break;
            }
        }
    }
    
    if(!_bcallback)
    {
        return;
    }
    
    RC_LOG(@"\nBegin Change Height: %f.", frame.size.height);
    if(_frameChangedBlock)
    {
        _frameChangedBlock(frame);
    }
}

@end

