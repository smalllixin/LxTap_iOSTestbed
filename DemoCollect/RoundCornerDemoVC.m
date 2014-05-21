//
//  RoundCornerDemoVC.m
//  DemoCollect
//
//  Created by lixin on 3/18/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "RoundCornerDemoVC.h"
#import <QuartzCore/QuartzCore.h>
#import "LxUI.h"
#import "RoundCornerView.h"
@interface RoundCornerDemoVC ()
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UIView *semiView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnCover;
@property (weak, nonatomic) IBOutlet RoundCornerView *customRoundView;
@end

@implementation RoundCornerDemoVC

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
    float cornerRad = 10.0f;
//    _customRoundView.fillColor = UIColorFromRGB(0xFF0000);
    _customRoundView.cornerRadius = 7;
    [_customRoundView setRoundCornerWithTl:NO tr:YES bl:YES br:YES];
    ///make semi-transparent view round corner
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.semiView.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(cornerRad, cornerRad)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.mImageView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.semiView.layer.mask = maskLayer;
    
    
    //button corner
    UIImage *m = [LxUI imageWithColor:UIColorFromRGBA(0x000000, 0.5f)];
    [self.btnCover setBackgroundImage:m forState:UIControlStateHighlighted];
    self.btnCover.layer.cornerRadius = cornerRad;
    self.btnCover.layer.masksToBounds = YES;
    
    
    //make image rounded corner
    CALayer *imgLayer = self.mImageView.layer;
    imgLayer.cornerRadius = cornerRad;
    imgLayer.masksToBounds = YES;

    UIView *shadowView = [[UIView alloc] initWithFrame:self.mImageView.frame];
    CALayer *sublayer = shadowView.layer;
    sublayer.backgroundColor = [UIColor blackColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(1, 1);
    sublayer.shadowRadius = 2.0;
    sublayer.shadowColor = [UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 0.8;
    sublayer.cornerRadius = cornerRad;
    shadowView.tag = 999;
    [self.view addSubview:shadowView];
    [self.view sendSubviewToBack:shadowView];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.view viewWithTag:999].frame = self.mImageView.frame;
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
- (IBAction)btn1Tap:(id)sender {
    static float pingpong = 100;
    CGPoint nowP = _customRoundView.layer.position;
    CGFloat nowY = nowP.y;
    NSLog(@"move to:%f", nowY+pingpong);
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.duration = 0.3f;
    anim.fromValue = [NSValue valueWithCGPoint:nowP];
    nowP.y += pingpong;
    anim.toValue = [NSValue valueWithCGPoint:nowP];
    anim.removedOnCompletion = YES;
    
    pingpong = -pingpong;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.customRoundView.layer addAnimation:anim forKey:@"12313"];
    self.customRoundView.layer.position = nowP;
}

@end
