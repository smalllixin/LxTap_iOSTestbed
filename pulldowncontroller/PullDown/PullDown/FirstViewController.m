//
//  FirstViewController.m
//  PullDown
//
//  Created by lixin on 3/27/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "FirstViewController.h"
#import "EdgeGestureScrollView.h"
@interface FirstViewController ()<UIScrollViewDelegate>
{
    UIEdgeInsets scrollBeginInset;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) PullDownViewController *pullVC;
@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.scroll.contentSize = CGSizeMake(320, 1200);
    self.scroll.bounces = NO;
    self.scroll.delegate = self;
    self.pullVC = self.pullDownController;
    self.pullVC.showHideBlock = ^(BOOL isHiden) {
        if (isHiden && self.scroll.scrollEnabled == NO) {
            self.scroll.scrollEnabled = YES;
            NSLog(@"scrollEnabled = YES;");
//            self.scroll.preventScroll = YES;
        }
        else if (!isHiden && self.scroll.scrollEnabled == YES){
            self.scroll.scrollEnabled = NO;
//            self.scroll.preventScroll = NO;
            NSLog(@"scrollEnabled = NO;");
        }
    };
//    self.pullVC.stateChangeBlock = ^(enum PulldownState state) {
//        if (state == kPulldownStateOff) {
//            self.scroll.scrollEnabled = YES;
//        } else if (state == kPulldownStateOn) {
//            self.scroll.scrollEnabled = NO;
//        } else {
//            self.scroll.scrollEnabled = NO;
//        }
//    };
    self.pullVC.scrollViewReachEdge = ^BOOL() {
        if (self.scroll.contentOffset.y <= -self.scroll.contentInset.top)
            return YES;
        return NO;
    };
    self.pullVC.scrollViewDragging = ^BOOL(){
        return self.scroll.isDragging;
    };
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    scrollBeginInset = self.scroll.contentInset;
//    CGSize s = self.scroll.contentSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.pullVC isPulling] && scrollView.scrollEnabled == YES) {
        scrollView.scrollEnabled = NO;
//        self.scroll.preventScroll = NO;
        NSLog(@"scrollEnabled = NO;");
//        UIEdge scrollBeginInset;
//        scrollView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    }
}

@end
