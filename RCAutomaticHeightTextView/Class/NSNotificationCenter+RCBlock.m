//
//  NSNotificationCenter+RCBlock.m
//  RCAutomaticHeightTextView
//
//  Created by Roy on 2017/3/26.
//  Copyright © 2017年 Roy CHANG. All rights reserved.
//

#import "NSNotificationCenter+RCBlock.h"
#import <objc/runtime.h>

NSString *const kRCNotificationInfosObserver = @"_rc_notify_observer_key_";
NSString *const kRCNotificationInfosCallBack = @"_rc_notify_callback_key_";
NSString *const kRCNotificationInfosName = @"_rc_notify_name_key_";

NSString *const kRCNotificationInfos = @"_rc_notificationinfos_key_";

@interface RCNotificationInfos : NSObject

@property (nonatomic, weak) id anObserver;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, copy) RCNotificationCallBack callBack;

@property (nonatomic, strong) id anObject;

@end

@implementation RCNotificationInfos

- (void)dealloc
{
    _anObserver = nil;
    _name = nil;
    _callBack = nil;
    _anObject = nil;
    NSLog(@"\n%p: %s", self, __FUNCTION__);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, Observer: %@, Name: %@, CallBack: %@, Object: %@>", [self class], self, [_anObserver class], _name, _callBack, [_anObject class]];
}

@end

@interface NSNotificationCenter ()

@property (nonatomic, readonly) NSMutableDictionary *rc_NotificationInfos;

@end

@implementation NSNotificationCenter (RCBlock)

#pragma mark - dealloc

- (void)dealloc
{
    [self.rc_NotificationInfos removeAllObjects];
    NSLog(@"\n%p: %s", self, __FUNCTION__);
}

#pragma mark - property

- (NSMutableDictionary *)rc_NotificationInfos
{
    NSMutableDictionary *_dic = objc_getAssociatedObject(self, &kRCNotificationInfos);
    if(!_dic)
    {
        _dic = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &kRCNotificationInfos, _dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _dic;
}

- (void)rc_addObserver:(id)observer name:(NSNotificationName)aName object:(id)anObject callBack:(RCNotificationCallBack)callBack
{
    if(!observer || !aName || !callBack)
    {
        return;
    }
    
    RCNotificationInfos *_info = nil;
    
    NSMutableArray *_array = self.rc_NotificationInfos[observer];
    if(_array)
    {
        NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"name == %@", aName];
        NSArray *infos = [_array filteredArrayUsingPredicate:_predicate];
        if(0 == [infos count])
        {
            _info = [RCNotificationInfos new];
            _info.anObserver = observer;
            _info.name = aName;
            _info.callBack = callBack;
            _info.anObject = anObject;
            
            [_array addObject:_info];
        }
        else
        {
            _info = infos[0];
            _info.anObserver = observer;
            _info.name = aName;
            _info.callBack = callBack;
            _info.anObject = anObject;
        }
    }
    else
    {
        _array = [NSMutableArray new];
        
        _info = [RCNotificationInfos new];
        _info.anObserver = observer;
        _info.name = aName;
        _info.callBack = callBack;
        _info.anObject = anObject;
        
        [_array addObject:_info];
        
        [self.rc_NotificationInfos setObject:_array forKey:observer];
    }
    
    [self addObserver:self selector:@selector(rc_innerSelector:) name:aName object:nil];
}

- (void)rc_removeObserver:(id)observer name:(NSNotificationName)aName;
{
    if(!observer || !aName)
    {
        return;
    }
    
    NSMutableArray *_array = self.rc_NotificationInfos[observer];
    if(0 == [_array count])
    {
        return;
    }
    
    NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"name == %@", aName];
    NSArray *infos = [_array filteredArrayUsingPredicate:_predicate];
    if(1 == [infos count])
    {
        RCNotificationInfos *_info = infos[0];
        [self removeObserver:observer name:aName object:infos];
        [_array removeObject:_info];
    }
#if DEBUG
    else
    {
        NSLog(@"\nRemove %@ for %@ Failed.", aName, [observer class]);
    }
#endif
}

- (void)rc_removeObserver:(id)observer
{
    if(!observer)
    {
        return;
    }
    
    [self removeObserver:observer];
    NSMutableArray *_array = self.rc_NotificationInfos[observer];
    [_array removeAllObjects];
    [self.rc_NotificationInfos removeObjectForKey:observer];
}

#pragma mark - internal notification selector

- (void)rc_innerSelector:(NSNotification *)notify
{
    NSLog(@"\n%@.", [notify.object description]);
    
    if([notify.object isKindOfClass:[RCNotificationInfos class]])
    {
        RCNotificationInfos *_info = (RCNotificationInfos*)notify.object;
        if(_info.callBack)
        {
            _info.callBack(_info.anObject);
        }
    }
}

@end
