//
//  ViewController.m
//  routerTest
//
//  Created by huangzh on 2019/4/26.
//  Copyright © 2019 huangzh. All rights reserved.
//

#import "ViewController.h"
#import "Router+ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button1Action:(id)sender{
    NSLog(@"click button1");
    
    [Router pushViewControllerWithURL:@"ucs://Module1/viewControllerForModule1" fromVc:self params:nil];
}


- (IBAction)button2Action:(id)sender{
    [Router presentViewControllerWithURL:@"ucs://Module1/viewControllerForModule1" fromVc:self params:nil];
}

- (IBAction)button3Action:(id)sender{
    NSLog(@"click button3");
}


@end
