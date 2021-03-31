//
//  UCSRouter.h
//  UCSRouter
//
//  Created by hzh on 2018/11/13.
//  Copyright © 2018年 hzh. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^UCSRouterCompletion)(id data);
NS_ASSUME_NONNULL_BEGIN

@interface Router : NSObject

/**
 *URL 规则 scheme://[target]/[action]?[params]
 *target对应接口类名，action为方法名
 *eg: ucs://targetA/actionB?id=333
 */

/**
 * 初始化接口类， 只有初始化过的接口类才能调用
 */
+ (void)loadInterfaceClass:(Class)kclass;

+ (BOOL)canRouteURL:(NSString *)URL;

+ (id)routeURL:(NSString *)URL;
+ (id)routeURL:(NSString *)URL params:(nullable NSDictionary *)params;
+ (id)routeURL:(NSString *)URL params:(nullable NSDictionary *)params completion:(nullable void (^)(id data))completion;

////通过URL获取viewController实例
//+(nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL;
//+(nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL withParameters:(nullable NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
