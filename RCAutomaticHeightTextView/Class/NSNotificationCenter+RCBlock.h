//
//  NSNotificationCenter+RCBlock.h
//  RCAutomaticHeightTextView
//
//  Created by Roy on 2017/3/26.
//  Copyright © 2017年 Roy CHANG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RCNotificationCallBack)(id anObject);

/*!
 *
 * @author Roy CHANG
 */
@interface NSNotificationCenter (RCBlock)

- (void)rc_addObserver:(id)observer name:(NSNotificationName)aName object:(id)anObject callBack:(RCNotificationCallBack)callBack;

- (void)rc_removeObserver:(id)observer name:(NSNotificationName)aName;

- (void)rc_removeObserver:(id)observer;

@end
