//
//  RightSlideDown.m
//  DemoCollect
//
//  Created by lixin on 3/24/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "RightSlideDown.h"

@implementation RightSlideDown

-(id)initWithTarget:(id)target action:(SEL)action{
    if ((self = [super initWithTarget:target action:action])){
        // so simple there's no setup
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    UIWindow *win = [[self view] window];
    CGPoint winLoc = [touch locationInView:win];
    [win convertPoint:winLoc fromWindow:nil];
    if ([touch locationInView:self.view].x < CGRectGetMidX(self.view.bounds)) self.state = UIGestureRecognizerStateFailed;
    else if ([touch locationInView:self.view].y > CGRectGetMidY(self.view.bounds)) self.state = UIGestureRecognizerStateFailed;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if([touch locationInView:self.view].x < CGRectGetMidX(self.view.bounds)) self.state = UIGestureRecognizerStateFailed;
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if ([touch locationInView:self.view].x < CGRectGetMidX(self.view.bounds)) self.state = UIGestureRecognizerStateFailed;
    else if ([touch locationInView:self.view].y < CGRectGetMidY(self.view.bounds)) self.state = UIGestureRecognizerStateFailed;
    else {
        // setting the state to recognized fires the target/action pair of the recognizer
        self.state = UIGestureRecognizerStateRecognized;
    }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateCancelled;
}
-(void)reset{
    // so simple there's no reset
    [super reset];
}
@end
