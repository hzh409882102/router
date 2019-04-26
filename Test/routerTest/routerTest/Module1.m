//
//  UCSModule1.m
//  UCSRouter_Example
//
//  Created by hzh on 2018/11/18.
//  Copyright © 2018年 hzh. All rights reserved.
//

#import "Module1.h"
#import "Router+ViewController.h"
#import "Module1ViewController.h"
@implementation Module1

- (UIViewController *)viewControllerForModule1:(NSDictionary *)param completion:(void (^)(id data))completion{
    UIViewController *ctr = [[Module1ViewController alloc] init];
    return ctr;
}


@end
