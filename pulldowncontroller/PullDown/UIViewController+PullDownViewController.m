//
//  UIViewController+PullDownViewController.m
//  PullDown
//
//  Created by lixin on 3/27/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "UIViewController+PullDownViewController.h"

@implementation UIViewController (PullDownViewController)

-(PullDownViewController*)pullDownController {
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController != nil) {
        if([parentViewController isKindOfClass:[PullDownViewController class]]){
            return (PullDownViewController *)parentViewController;
        }
        parentViewController = parentViewController.parentViewController;
    }
    return nil;
}
@end
