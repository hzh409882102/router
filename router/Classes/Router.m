//
//  UCSRouter.m
//  UCSRouter
//
//  Created by hzh on 2018/11/13.
//  Copyright © 2018年 hzh. All rights reserved.
//

#import "Router.h"
#import <objc/runtime.h>

@interface Router()
@property (nonatomic, strong) NSMutableDictionary *cachedTarget;
@property (nonatomic, strong) NSRecursiveLock *lockCache;

@end

@implementation Router

+ (void)loadInterfaceClass:(Class)kclass
{
    NSString *targetName = NSStringFromClass(kclass);
    NSObject *targetObject = [[kclass alloc] init];
    if (targetObject == nil) {
        return;
    }

    [[Router shared] addTarget:targetObject name:targetName];
}

+(BOOL)canRouteURL:(nonnull NSString *)URL{
    return NO;
}

+( id)routeURL:(nonnull NSString *)URL{
    return [self routeURL:URL params:nil completion:nil];
}

+ (id)routeURL:(nonnull NSString *)URL params:(NSDictionary *)params{
    return [self routeURL:URL params:params completion:nil];
}

+ (id)routeURL:(nonnull NSString *)URL params:(NSDictionary *)params completion:(void (^)(id data))completion{
    NSURL *url = [NSURL URLWithString:URL];
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSArray<NSURLQueryItem *> *queryItems = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:false].queryItems;
    for (NSURLQueryItem *item in queryItems) {
        allParams[item.name] = item.value;
    }
    
//    if ([actionName hasPrefix:@"native"]) {
//        return @(NO);
//    }
//    NSString *targetName = [NSString stringWithFormat:@"UCS%@%@",
//                            [url.host substringToIndex:1].uppercaseString, [url.host substringFromIndex:1]];
    
    NSString *targetName = url.host;
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return [[Router shared] performTarget:targetName
                                      action:actionName
                                      params:allParams
                                  completion:completion];
}

+ (instancetype)shared {
    static Router *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!router) {
            router = [[Router alloc] init];
        }
    });
    return router;
}

- (id)init{
    if (self = [super init]) {
        _lockCache = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (void)addTarget:(NSObject *)target name:(NSString *)targetName
{
    
    [_lockCache lock];
    self.cachedTarget[targetName] = target;
    [_lockCache unlock];
}

- (NSObject *)targetWithName:(NSString *)targetName
{
    NSObject *targetObject = nil;
    [_lockCache lock];
    targetObject = [self.cachedTarget objectForKey:targetName];
    [_lockCache unlock];
    if (targetObject) {
        return targetObject;
    }

    Class targetClass = NSClassFromString(targetName);
    targetObject = [[targetClass alloc] init];
    if (targetObject == nil) {
        return nil;
    }
    [self addTarget:targetObject name:targetName];
    return targetObject;
}

- (id)performTarget:(NSString *)targetName
             action:(NSString *)actionName
             params:(NSDictionary *)params
         completion:(void (^)(id data))completion {
    
    NSObject *target = [self targetWithName:targetName];
    if (target == nil) {
        return nil;
    }
    
    NSString *actionString = [NSString stringWithFormat:@"%@:completion:", actionName];
    SEL action = NSSelectorFromString(actionString);
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action
                                target:target
                                params:params
                            completion:completion];
    } else {
        [self NoTargetActionResponseWithTargetString:targetName
                                      selectorString:actionString originParams:params];
        [self.cachedTarget removeObjectForKey:target];
        return nil;
    }
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params completion:(void (^)(id data))completion {
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    
    const char* retType = [methodSig methodReturnType];
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setArgument:&completion atIndex:3];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setArgument:&completion atIndex:3];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setArgument:&completion atIndex:3];

        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setArgument:&completion atIndex:3];

        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setArgument:&completion atIndex:3];

        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params withObject:completion];
#pragma clang diagnostic pop
}
    
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName{
    [self.cachedTarget removeObjectForKey:targetName];
}
    
#pragma mark - private methods
- (void)NoTargetActionResponseWithTargetString:(NSString *)targetString
                                selectorString:(NSString *)selectorString
                                  originParams:(NSDictionary *)originParams{
    SEL action = NSSelectorFromString(@"Action_response:");
    NSObject *target = [[NSClassFromString(@"Target_NoTargetAction") alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"originParams"] = originParams;
    params[@"targetString"] = targetString;
    params[@"selectorString"] = selectorString;
    [self safePerformAction:action target:target params:params completion:nil];
}

#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTarget{
    if (_cachedTarget == nil) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}
@end
