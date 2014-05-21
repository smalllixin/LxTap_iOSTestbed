//
//  MoveTabbarViewController.m
//  DemoCollect
//
//  Created by lixin on 3/27/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "MoveTabbarViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface MoveTabbarViewController ()<UIGestureRecognizerDelegate>
{
    CGPoint panGestureOrigin;
    CGPoint originCenter;
}
@property (weak, nonatomic) IBOutlet UIView *blockView;

@property (weak, nonatomic) UIWindow *win;
@end

@implementation MoveTabbarViewController

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
    self.win = [[UIApplication sharedApplication].windows lastObject];
//    self.win.backgroundColor = [UIColor yellowColor];
//    self.win.layer.backgroundColor = [UIColor greenColor].CGColor;
    
//    UIView *v = [[UIView alloc] initWithFrame:self.win.bounds];
//    v.backgroundColor = [UIColor redColor];
//    [self.win addSubview:v];
//    [self.win sendSubviewToBack:v];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Hi" style:UIBarButtonItemStyleBordered target:self action:@selector(hiTap:)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
    originCenter = self.tabBarController.view.center;
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    recognizer.delegate = self;
    [self.tabBarController.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL shouldRecv = NO;
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (touch.view == self.blockView) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Events
- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        panGestureOrigin = self.tabBarController.view.center;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translatedPoint = [recognizer translationInView:self.view];
        CGFloat yOffset = translatedPoint.y;
        CGPoint centerNow = panGestureOrigin;
        centerNow.y += yOffset;
        self.tabBarController.view.center = centerNow;
    }
}

- (void)hiTap:(id)sender
{
    NSLog(@"hihi");
    [[UIApplication sharedApplication].delegate window].backgroundColor = [UIColor orangeColor];
    CALayer *layer = self.tabBarController.view.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, -0.2f);
    layer.shadowRadius = 10.0f;
    layer.shadowOpacity = 1.0f;
//    layer.masksToBounds = NO;
    layer.shadowPath =  [UIBezierPath bezierPathWithRect:self.tabBarController.view.bounds].CGPath;
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
- (IBAction)goBottomPress:(id)sender {
    CGPoint center = self.navigationController.view.center;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 0.2f;
    animation.fromValue = [NSValue valueWithCGPoint:center];
    center.y += 100;
    animation.toValue = [NSValue valueWithCGPoint:center];
//    CGPoint center = self.view.center;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = YES;
    [self.tabBarController.view.layer addAnimation:animation forKey:@"gbp"];
    
//    self.navigationController.view.center = center;
    self.tabBarController.view.center = center;
}

@end
