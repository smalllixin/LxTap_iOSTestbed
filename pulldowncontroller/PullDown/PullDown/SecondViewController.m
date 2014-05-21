//
//  SecondViewController.m
//  PullDown
//
//  Created by lixin on 3/27/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
    [self.view addGestureRecognizer:g];
}

- (void)taptap:(id)g
{
    UIViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"poptest"];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
