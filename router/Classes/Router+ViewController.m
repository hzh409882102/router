//
//  router+ViewController.m
//  UCS-IM-Personnal
//
//  Created by hzh on 2018/11/15.
//  Copyright © 2018年 hzh. All rights reserved.
//

#import "router+ViewController.h"

NSString *const UCSRouterFromViewControllerKey = @"UCSRouterFromViewControllerKey";
NSString *const UCSRouterViewControllerPopTypeKey = @"popType";

@implementation Router (ViewController)
+ (UIViewController *)viewControllerWithURL:(NSString *)URL
{
    return [self viewControllerWithURL:URL params:nil];
}

+ (UIViewController *)viewControllerWithURL:(NSString *)URL
                                     params:(NSDictionary *)params
{
    return [self viewControllerWithURL:URL params:params completion:nil];

}

+ (UIViewController *)viewControllerWithURL:(NSString *)URL
                                     params:(NSDictionary *)params
                                 completion:(void (^)(id data))completion
{
    id result = [self routeURL:URL params:params completion:completion];
    if (result && [result isKindOfClass:[UIViewController class]]) {
        UIViewController *ctr = (UIViewController *)result;
        return ctr;
    } else {
        CGSize sz = [UIScreen mainScreen].bounds.size;
        UIViewController *ctr = [[UIViewController alloc] init];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, sz.height/2 - 60, sz.width, 60);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = [NSString stringWithFormat:@"%@ Not Found!", URL];
        [ctr.view addSubview:label];
        return ctr;  /// 可以统一返回一个错误提示的viewcontroller
    }
}

+ (void)pushViewControllerWithURL:(NSString *)URL
                           fromVc:(UIViewController *)fromVc{
    [self pushViewControllerWithURL:URL fromVc:fromVc params:nil];
}

+ (void)pushViewControllerWithURL:(NSString *)URL
                           fromVc:(UIViewController *)fromVc
                           params:(NSDictionary *)params{
    [self pushViewControllerWithURL:URL fromVc:fromVc params:params completion:nil];
}

+ (void)pushViewControllerWithURL:(NSString *)URL
                           fromVc:(UIViewController *)fromVc
                           params:(NSDictionary *)params
                       completion:(void (^)(id data))completion
{
    UIViewController *ctr = [self viewControllerWithURL:URL params:params completion:completion];
    if (fromVc) {
        if (fromVc.navigationController) {
            [fromVc.navigationController pushViewController:ctr animated:YES];
        } else {
            
            UINavigationController *nav =[self routeURL:@"ucs://UCSAppMain/navControllerWithPresentRootVc" params:@{@"rootViewController":ctr}];
            if (!nav) {
                nav = [[UINavigationController alloc] initWithRootViewController:ctr];
            }
            [fromVc presentViewController:nav animated:YES completion:nil];
        }
    } else {
        NSLog(@"fromVc is erro");
    }
}

+ (void)presentViewControllerWithURL:(NSString *)URL
                              fromVc:(UIViewController *)fromVc
{
    [self presentViewControllerWithURL:URL fromVc:fromVc params:nil];
}

+ (void)presentViewControllerWithURL:(NSString *)URL
                              fromVc:(UIViewController *)fromVc
                              params:(NSDictionary *)params
{
    [self presentViewControllerWithURL:URL fromVc:fromVc params:params  completion:nil];
}

+ (void)presentViewControllerWithURL:(NSString *)URL
                              fromVc:(UIViewController *)fromVc
                              params:(NSDictionary *)params
                          completion:(void (^)(id data))completion
{
    UIViewController *ctr = [self viewControllerWithURL:URL params:params completion:completion];
    UINavigationController *nav =[self routeURL:@"ucs://UCSAppMain/navControllerWithPresentRootVc" params:@{@"rootViewController":ctr}];
    if (!nav) {
        nav = [[UINavigationController alloc] initWithRootViewController:ctr];
    }
    if (fromVc) {
        [fromVc presentViewController:nav animated:YES completion:nil];
    } else {
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:nav animated:YES completion:nil];
    }
}



@end
