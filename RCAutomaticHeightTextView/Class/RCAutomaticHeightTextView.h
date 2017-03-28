//
//  RCAutomaticHeightTextView.h
//  RCAutomaticHeightTextView
//
//  Created by Roy on 2017/3/26.
//  Copyright © 2017年 Roy CHANG. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^RCTextViewFrameDidChagnedCallBack)(CGRect frame);

///建议（扯蛋...）的高度
UIKIT_EXTERN const CGFloat RCTextViewSugesstionHeight;

///高度没限制
UIKIT_EXTERN const CGFloat RCTextViewHeightNoLimit;

/**
 * @discussion 适用于手动计算Frame和自动‘Height’布局的情况
 * @author Roy CHANG
 */
NS_CLASS_AVAILABLE_IOS(7_0) @interface RCAutomaticHeightTextView : UITextView

@property (nonatomic, readonly) UILabel *placeHolderLabel;

///最大高度( >= frame.size.height). default is ‘RCTextViewHeightNoLimit’.
@property (nonatomic, assign) CGFloat maxHeight;

///高度改变回调....
@property (nonatomic, copy) RCTextViewFrameDidChagnedCallBack frameChangedBlock;

@end
