//
//  PopButton.m
//  DemoCollect
//
//  Created by lixin on 5/20/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "PopButton.h"
#import <POP/POP.h>

@implementation PopButton
{
    CGFloat currentScale;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.adjustsImageWhenHighlighted = NO;
        self.maxScale = 2.0f;
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
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"begin");
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(_maxScale, _maxScale)];
    anim.springBounciness = 14;
    [self.layer pop_addAnimation:anim forKey:@"big"];
    return [super beginTrackingWithTouch:touch withEvent:event];
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return [super continueTrackingWithTouch:touch withEvent:event];
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"end");
    [self.layer pop_removeAnimationForKey:@"big"];
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.springBounciness = 14;
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    [self.layer pop_addAnimation:anim forKey:@"sm"];
    return [super endTrackingWithTouch:touch withEvent:event];
}
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    NSLog(@"cancel");
    [self.layer pop_removeAnimationForKey:@"big"];
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.springBounciness = 14;
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    [self.layer pop_addAnimation:anim forKey:@"sm"];
    return [super cancelTrackingWithEvent:event];
}

@end
