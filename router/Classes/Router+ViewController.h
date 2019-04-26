//
//  UCSRouter+ViewController.h
//  UCS-IM-Personnal
//
//  Created by hzh on 2018/11/15.
//  Copyright © 2018年 simba.pro. All rights reserved.
//

#import "Router.h"

//NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, UCSRouterViewControllerPopType) {
    UCSRouterViewControllerPopTypePresent = 1,
    UCSRouterViewControllerPopTypePush = 2,
};

extern NSString *const UCSRouterFromViewControllerKey;
extern NSString *const UCSRouterViewControllerPopTypeKey;

@interface Router (ViewController)

+ (UIViewController *)viewControllerWithURL:(NSString *)URL;
+ (UIViewController *)viewControllerWithURL:(NSString *)URL params:(NSDictionary *)params;
+ (UIViewController *)viewControllerWithURL:(NSString *)URL params:(NSDictionary *)params completion:(void (^)(id data))completion;

+ (void)pushViewControllerWithURL:(NSString *)URL fromVc:(UIViewController *)fromVc;
+ (void)pushViewControllerWithURL:(NSString *)URL fromVc:(UIViewController *)fromVc params:(NSDictionary *)params;
+ (void)pushViewControllerWithURL:(NSString *)URL fromVc:(UIViewController *)fromVc params:(NSDictionary *)params completion:(void (^)(id data))completion;

+ (void)presentViewControllerWithURL:(NSString *)URL fromVc:(UIViewController *)fromVc;
+ (void)presentViewControllerWithURL:(NSString *)URL fromVc:(UIViewController *)fromVc params:(NSDictionary *)params;
+ (void)presentViewControllerWithURL:(NSString *)URL fromVc:(UIViewController *)fromVc params:(NSDictionary *)params completion:(void (^)(id data))completion;
@end

//NS_ASSUME_NONNULL_END
