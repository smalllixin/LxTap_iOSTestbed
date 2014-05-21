//
//  CustomGesViewController.m
//  DemoCollect
//
//  Created by lixin on 3/24/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "CustomGesViewController.h"
#import "RightSlideDown.h"
@interface CustomGesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelTest;
@end

@implementation CustomGesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    RightSlideDown *gest1 = [[RightSlideDown alloc] initWithTarget:self action:@selector(rightSlideDownHappen:)];
//    gest11.delegate=
    [self.view addGestureRecognizer:gest1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)rightSlideDownHappen:(RightSlideDown*)recognizer
{
    self.labelTest.text = @"rightSlideDown";
}
@end
