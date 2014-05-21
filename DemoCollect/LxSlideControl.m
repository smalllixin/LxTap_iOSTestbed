//
//  LxSlideControl.m
//  DemoCollect
//
//  Created by lixin on 3/18/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "LxSlideControl.h"
#import "LightingLabel.h"
#import <QuartzCore/QuartzCore.h>
@interface LxSlideControl()
{
    float cornerRad;
    CALayer *trackLayer;
    CALayer *thumbLayer;
    UIImageView *thumbView;
    CGPoint handPos;
    LightingLabel *textLabel;
    
    float labelAlphaBeginX;
    float labelAlphaEndX;
    float labelNotResponseDistance;
}
@end
@implementation LxSlideControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
//        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [textLabel stopTimer];
}

- (void)setTitle:(NSString *)t
{
    _title = t;
    CGSize labelSize = [_title sizeWithFont:textLabel.font];
    textLabel.frame = CGRectMake(0.0, 0.0, labelSize.width, labelSize.height);
    textLabel.center = CGPointMake( CGRectGetWidth(self.frame)/2+CGRectGetWidth(thumbView.frame)/2, CGRectGetHeight(self.frame)/2);
    textLabel.text = _title;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    cornerRad = 5.0f;
    labelNotResponseDistance = 20.0f;
    
    CGRect viewRect = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    //track image
    self.trackImg = [self generateTrackImg:self.frame];
    trackLayer = [CALayer layer];
    trackLayer.frame = viewRect;
    trackLayer.contents = (__bridge id)(self.trackImg.CGImage);
    [self.layer addSublayer:trackLayer];

    //textLabel
    // Set other label attributes and add it to the view
    UIFont *labelFont = [UIFont systemFontOfSize:24];
    textLabel = [[LightingLabel alloc] initWithFrame:CGRectZero];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
	textLabel.backgroundColor = [UIColor clearColor];
	textLabel.font = labelFont;
    
    self.isAnimateLabel = YES;

    [self addSubview:textLabel];
    if (self.isAnimateLabel)
        [textLabel startTimer];
    
    //thumb image
    self.thumbImg = [UIImage imageNamed:@"sliderThumb"];
    thumbView = [[UIImageView alloc] initWithImage:self.thumbImg];
    thumbView.frame = CGRectMake(0,0,self.thumbImg.size.width, self.thumbImg.size.height);
    thumbView.clearsContextBeforeDrawing = YES;
    [self addSubview:thumbView];
    
    
    labelAlphaBeginX = labelNotResponseDistance;
    labelAlphaEndX = CGRectGetMaxX(trackLayer.frame)/2-CGRectGetWidth(thumbView.frame);
}

- (UIImage*)generateTrackImg:(CGRect)rect {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// Color Declarations
    UIColor* gradientColor = [UIColor colorWithRed: 0.217 green: 0.217 blue: 0.217 alpha: 1];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)[UIColor blackColor].CGColor,
                               (id)[UIColor colorWithRed: 0.109 green: 0.109 blue: 0.109 alpha: 1].CGColor,
                               (id)gradientColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 0.58, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRad, cornerRad)];
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient,
                                CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame)),
                                CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame)),
                                0);
    CGContextRestoreGState(context);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    /* Save to the photo album */
//    UIImageWriteToSavedPhotosAlbum(result , nil, nil, nil);
    
    return result;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    CGRect frame = rect;
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [self.thumbImg drawInRect:CGRectMake(handPos.x,0,100, 100)];
//    [self.thumbImg drawAtPoint:handPos];
//}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    CALayer *presLayer = [thumbView.layer presentationLayer];
    thumbView.layer.position = presLayer.position;
    [thumbView.layer removeAllAnimations];
    
    [textLabel.layer removeAllAnimations];
    float refX = presLayer.frame.origin.x;
    [self updateLabelAlpha:refX];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint lastPoint = [touch locationInView:self];
//    CGPoint prevPoint = [touch previousLocationInView:self];
    handPos = lastPoint;
    CGPoint p = thumbView.center;
    CGRect f = thumbView.frame;
    CGFloat distance = sqrtf((lastPoint.x - p.x)*(lastPoint.x - p.x) + (lastPoint.y - p.y)*(lastPoint.y - p.y));
    if (distance > 120) {
        [self sendThumbBackToBegin];
        return NO;
    }
    
    //maintain thumb position
    if ((lastPoint.x-CGRectGetWidth(f)/2) < 0 ) {
        f.origin.x = 0;
        thumbView.frame = f;
    } else if ((lastPoint.x+CGRectGetWidth(f)/2)>CGRectGetMaxX(trackLayer.bounds)) {
        f.origin.x = CGRectGetMaxX(trackLayer.bounds) - CGRectGetWidth(f);
        thumbView.frame = f;
    } else {
        p.x = lastPoint.x;
        thumbView.center = p;
    }
    
    //maintain label alpha
    float refX = thumbView.frame.origin.x;
    [self updateLabelAlpha:refX];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    [self sendThumbBackToBegin];
}
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [super cancelTrackingWithEvent:event];
    [self sendThumbBackToBegin];
}

- (void)updateLabelAlpha:(CGFloat)refX
{
    float alpha = 1;
    if (refX < labelAlphaBeginX) {
        alpha = 1;
    } else if (refX < labelAlphaEndX) {
        alpha = 1-(refX-labelAlphaBeginX)/(labelAlphaEndX-labelAlphaBeginX);
        [textLabel stopTimer];
    } else {
        alpha = 0;
    }
    textLabel.alpha = alpha;
}

- (void)sendThumbBackToBegin {
    CALayer *presLayer = [thumbView.layer presentationLayer];
    CGPoint p = presLayer.position;
    p.x = CGRectGetWidth(thumbView.frame)/2;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 0.2f;

    animation.fromValue = [NSValue valueWithCGPoint:thumbView.layer.position];
    animation.toValue = [NSValue valueWithCGPoint:p];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = YES;
    thumbView.center = p;
    [thumbView.layer addAnimation:animation forKey:@"slide"];
    
    CABasicAnimation *labelAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    labelAnim.duration = 0.2f;
    labelAnim.fromValue = [NSNumber numberWithFloat:textLabel.layer.opacity];
    labelAnim.toValue = [NSNumber numberWithFloat:1.0f];
    labelAnim.removedOnCompletion = YES;
    labelAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [textLabel.layer addAnimation:labelAnim forKey:@"labelAlpha"];
    textLabel.alpha = 1;
    if (self.isAnimateLabel)
        [textLabel startTimer];
//    [CATransaction setDisableActions:NO];
//    thumbView.layer.position = p;
}

@end
