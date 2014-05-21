//
//  EdgeGestureScrollView.m
//  PullDown
//
//  Created by lixin on 3/27/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "EdgeGestureScrollView.h"
@interface EdgeGestureScrollView()<UIGestureRecognizerDelegate>
@end
@implementation EdgeGestureScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    //    BOOL shouldRecv = NO;
//    
//    NSLog(@"");
//    return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
//}
// called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    
//    BOOL r = [super gestureRecognizerShouldBegin:gestureRecognizer];
//    NSLog(@"[Scroll]gestureRecognizerShouldBegin:%d",r );
//    return r;
//}

- (void)setPreventScroll:(BOOL)preventScroll
{
    _preventScroll = preventScroll;
}

- (void)setContentOffset:(CGPoint)contentOffset
{
//    if (!_preventScroll) {
        [super setContentOffset:contentOffset];
//    } else {
    
//    }
}
@end
