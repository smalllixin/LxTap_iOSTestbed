//
//  PullDownViewController.h
//  PullDown
//
//  Created by lixin on 3/27/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

enum PulldownState {
    kPulldownStateOff = 1,// when the backend entirely closed
    kPulldownStateOn,//when the backend entirely Show
    kPulldownStateDragging
};

typedef void (^PullDownCompleteShowHideBlock)(BOOL isHiden);
typedef void (^PullDownStateBlock)(enum PulldownState state);

typedef BOOL (^PullDownScrollViewReachEdgeBlock)();
typedef BOOL (^PullDownScrollViewDraggingBlock)();
//TBD need STOP

//

@interface PullDownViewController : UIViewController

-(id)initWithRootController:(UIViewController*)rootController backViewController:(UIViewController*)backViewController;


@property (nonatomic, strong) UIViewController *root;
@property (nonatomic, strong) UIViewController *backVC;
@property (nonatomic, assign) CGFloat pullMaxHeight;
@property (nonatomic, assign) BOOL enableShadow;

@property (nonatomic, copy) PullDownCompleteShowHideBlock showHideBlock;
@property (nonatomic, copy) PullDownScrollViewReachEdgeBlock scrollViewReachEdge;
@property (nonatomic, copy) PullDownScrollViewDraggingBlock scrollViewDragging;
@property (nonatomic, copy) PullDownStateBlock stateChangeBlock;
@property (nonatomic, assign, readonly) BOOL isPulling;
@end
