//
//  PullDownViewController.m
//  PullDown
//
//  Created by lixin on 3/27/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "PullDownViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PullDownViewController ()<UIGestureRecognizerDelegate>
{
    CGPoint panGestureOrigin;
    UIPanGestureRecognizer *panGesture;
    BOOL lastIsReachScrollEdge;
}
@end

@implementation PullDownViewController

#pragma mark - Consts
static const CGFloat kDefaultShadowOpacity = 1.0f;
static UIColor *kDefaultShadowColor;
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self commonSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonSetup];
    }
    return self;
}

-(id)initWithRootController:(UIViewController*)rootController backViewController:(UIViewController*)backViewController{
    self = [super init];
    if (self) {
        [self commonSetup];
        self.root = rootController;
        self.backVC = backViewController;
    }
    return self;
}

-(void)commonSetup
{
    _pullMaxHeight = 200;
    kDefaultShadowColor = [UIColor blackColor];
}

#pragma mark - Getters & Setters
-(void)setPullMaxHeight:(CGFloat)pullMaxHeight
{
    _pullMaxHeight = pullMaxHeight;
}
-(void)setEnableShadow:(BOOL)enableShadow
{
    _enableShadow = enableShadow;
    CALayer *layer = self.root.view.layer;
    if (_enableShadow) {
        layer.masksToBounds = NO;
        layer.shadowColor = kDefaultShadowColor.CGColor;
        layer.shadowOffset = CGSizeMake(0, -0.2f);
        layer.shadowRadius = 10.0f;
        layer.shadowOpacity = kDefaultShadowOpacity;
        layer.shadowPath =  [UIBezierPath bezierPathWithRect:self.tabBarController.view.bounds].CGPath;
    } else {
        layer.shadowColor = nil;
        layer.shadowRadius = 0;
        layer.shadowOpacity = 0;
    }
}
-(BOOL)isPulling
{
    CGFloat minOffsetY = self.view.center.y;
    CGFloat maxOffsetY = minOffsetY + self.pullMaxHeight;
    if (self.root.view.center.y == minOffsetY || self.root.view.center.y == maxOffsetY) {
        return NO;
    } else {
        return YES;
    }
}
#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.root.view.frame = self.view.bounds;
    if (self.backVC) {
        [self addChildViewController:self.backVC];
        [self.backVC didMoveToParentViewController:self];
    }
    
    [self addChildViewController:self.root];
    [self.view bringSubviewToFront:self.root.view];
    [self.root didMoveToParentViewController:self];
    
    [self addChild:self.backVC];
    [self addChild:self.root];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
    panGesture.delegate = self;
    [self.root.view addGestureRecognizer:panGesture];
}

- (void)addChild:(UIViewController*)childTooAdd
{
    [self.view addSubview:childTooAdd.view];
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
#pragma mark - Gesture Delegates
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    BOOL shouldRecv = NO;
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if ([touch.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scroll = (UIScrollView*)touch.view;
            if (!scroll.scrollEnabled) {
                return YES;
            }
//            UIPanGestureRecognizer *panGes = gestureRecognizer;
////            CGPoint tv = [panGes translationInView:self.root.view];
//            CGPoint tv = [panGes velocityInView:self.root.view];
//            NSLog(@"begin translationInView:%f,%f",tv.x,tv.y);
//            if (scroll.contentOffset.y == -scroll.contentInset.top &&  tv.y > 0){
//                NSLog(@"scrollview with pan");
//                return YES;
//            }
//            NSLog(@"scroll.contentOffset.y:%f  | inset:%f",scroll.contentOffset.y, scroll.contentInset.top);
//            
//            if (self.scrollViewReachEdge && self.scrollViewReachEdge() && tv.y < 0){
//                //如果设置了判断边界的block，那么就全部接收事件
//                return YES;
//            }
//            else {
//                return NO;
//            }
        }
    }
    return YES;
}
// called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"gestureRecognizerShouldBegin");

    UIPanGestureRecognizer *pan = gestureRecognizer;
    CGPoint t = [pan translationInView:self.root.view];
    NSLog(@"t:%f,%f",t.x,t.y);
//    if (ABS(t.x) > 0.5f) {

    if (t.x != 0 /*|| (t.y > 12 && !self.scrollViewReachEdge())*/){
        return NO;
    }
    
//    gestureRecognizer.
    return YES;
}

// called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
// return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
//
// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == panGesture && [otherGestureRecognizer.view isKindOfClass:[UIScrollView class]])
        return YES;
    return NO;
}

#pragma mark - Gestures
- (void)panHandle:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        panGestureOrigin = self.root.view.center;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (!lastIsReachScrollEdge && self.scrollViewReachEdge()){
            //如果刚刚好reach了
            panGestureOrigin.y -= [recognizer translationInView:self.root.view].y;
        }
        if ([recognizer.view isKindOfClass:[UIScrollView class]]) {
            //如果是tcouh scrollview,并且没有到边
            if (!self.scrollViewReachEdge()) {
                return;
            }
        }
        lastIsReachScrollEdge = self.scrollViewReachEdge();
        [self calAndMoveRoot:recognizer isEnd:NO];
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        [self calAndMoveRoot:recognizer isEnd:YES];
    }
    else {
        NSLog(@"failed");
    }
}

- (void)calAndMoveRoot:(UIPanGestureRecognizer*)recognizer isEnd:(BOOL)isEnd
{
    CGFloat minOffsetY = self.view.center.y;
    CGFloat maxOffsetY = minOffsetY + self.pullMaxHeight;
    
    CGPoint translatedPoint = [recognizer translationInView:self.root.view];
    CGFloat yOffset = translatedPoint.y;
    CGPoint centerNow = panGestureOrigin;
    if (!isEnd) {
        if (centerNow.y + yOffset <= minOffsetY) {
            centerNow.y = minOffsetY;
            self.root.view.center = centerNow;
            if (self.showHideBlock) {
                self.showHideBlock(YES);
            }
            if (self.stateChangeBlock) {
                self.stateChangeBlock(kPulldownStateOff);
            }
            return;
        } else if (centerNow.y + yOffset >= maxOffsetY) {
            centerNow.y = maxOffsetY;
            self.root.view.center = centerNow;
            if (self.showHideBlock) {
                self.showHideBlock(NO);
            }
            if (self.stateChangeBlock) {
                self.stateChangeBlock(kPulldownStateOn);
            }
            return;
        }
        
        centerNow.y += yOffset;
        //如果正在dragging，那么根据边界判断是否需要移动
        //else 正常处理
        if (self.scrollViewDragging && self.scrollViewDragging()) {
            if (self.scrollViewReachEdge()){
                self.root.view.center = centerNow;
            }
        } else {
            self.root.view.center = centerNow;
        }
        if (self.stateChangeBlock) {
            self.stateChangeBlock(kPulldownStateDragging);
        }
        
    } else {
        //End pan
        //I need do animation if it is necessary
        //判断位置和速度，是否
        CGPoint vcenter = self.root.view.center;
        if (vcenter.y != minOffsetY && vcenter.y != maxOffsetY) {
            CGPoint velocity = [recognizer velocityInView:self.root.view];
            NSLog(@"velocity:%f,%f", velocity.x, velocity.y);
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            animation.removedOnCompletion = YES;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animation.duration = 0.25f;//need calculate here
            animation.fromValue = [NSValue valueWithCGPoint:vcenter];
            
            BOOL directionDown = velocity.y>0?YES:NO;
            
            CGFloat distanceMin = ABS(vcenter.y - minOffsetY);
            CGFloat distanceMax = ABS(maxOffsetY - vcenter.y);
            
            BOOL nearCloseState = distanceMin/(maxOffsetY - minOffsetY) < 0.20f && !directionDown;
            BOOL nearFullOpenState = distanceMax/(maxOffsetY-minOffsetY) < 0.20f && directionDown;
            
            
            BOOL actualDirectionDown;
            if (ABS(velocity.y) > 100 || nearCloseState || nearFullOpenState) {
                //do with the same direction
                if (directionDown){
                    vcenter.y = maxOffsetY;
                    actualDirectionDown = YES;
                }
                else {
                    vcenter.y = minOffsetY;
                    actualDirectionDown = NO;
                }
            } else {
                //do with the opposite direction
                //if already transition for a long distance, could make it same direction
                
                if (directionDown) {
                    vcenter.y = minOffsetY;
                    actualDirectionDown = NO;
                }
                else {
                    vcenter.y = maxOffsetY;
                    actualDirectionDown = YES;
                }
            }
            animation.toValue = [NSValue valueWithCGPoint:vcenter];
            [self.root.view.layer addAnimation:animation forKey:@"drag over"];
            self.root.view.center = vcenter;
            if (self.showHideBlock) {
                self.showHideBlock(!actualDirectionDown);
            }
        }
    }
}
@end
