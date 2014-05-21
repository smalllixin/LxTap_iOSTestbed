//
//  LightingLabel.m
//  DemoCollect
//
//  Created by lixin on 3/19/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "LightingLabel.h"
#import <QuartzCore/QuartzCore.h>
@interface LightingLabel()
{
    //label animation
    CADisplayLink *animationTimer;
    CGFloat gradientLocations[3];
	int animationTimerCount;
    UIImage *textMask;
}
@end
@implementation LightingLabel

static const CGFloat gradientWidth = 0.2;
static const CGFloat gradientDimAlpha = 0.5;
static const int animationFramesPerSec = 12;//8;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup
{
    //label animation
    textMask = [UIImage imageNamed:@"maskText"];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //    [[UIColor redColor] setFill];
    //    [self.text drawAtPoint:CGPointMake(0,0) forWidth:CGRectGetWidth(self.frame) withFont:self.font fontSize:22 lineBreakMode:NSLineBreakByClipping baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    // Set the font
    
    //方法二 ，画一个带gradient矩形，然后用文字去blend裁剪
//    UIBezierPath *textPath = [self getTextPath:rect];
    
	// Calculate text width
    //	CGPoint textEnd = CGContextGetTextPosition(theContext);
    
	
	// Get the foreground text color from the UILabel.
	// Note: UIColor color space may be either monochrome or RGB.
	// If monochrome, there are 2 components, including alpha.
	// If RGB, there are 4 components, including alpha.
	CGColorRef textColor = self.textColor.CGColor;
	const CGFloat *components = CGColorGetComponents(textColor);
	size_t numberOfComponents = CGColorGetNumberOfComponents(textColor);
	BOOL isRGB = (numberOfComponents == 4);
	CGFloat red = components[0];
	CGFloat green = isRGB ? components[1] : components[0];
	CGFloat blue = isRGB ? components[2] : components[0];
	CGFloat alpha = isRGB ? components[3] : components[1];
    
	// The gradient has 4 sections, whose relative positions are defined by
	// the "gradientLocations" array:
	// 1) from 0.0 to gradientLocations[0] (dim)
	// 2) from gradientLocations[0] to gradientLocations[1] (increasing brightness)
	// 3) from gradientLocations[1] to gradientLocations[2] (decreasing brightness)
	// 4) from gradientLocations[3] to 1.0 (dim)
	size_t num_locations = 3;
	
	// The gradientComponents array is a 4 x 3 matrix. Each row of the matrix
	// defines the R, G, B, and alpha values to be used by the corresponding
	// element of the gradientLocations array
	CGFloat gradientComponents[12];
	for (int row = 0; row < num_locations; row++) {
		int index = 4 * row;
		gradientComponents[index++] = red;
		gradientComponents[index++] = green;
		gradientComponents[index++] = blue;
		gradientComponents[index] = alpha * gradientDimAlpha;
	}
    
	// If animating, set the center of the gradient to be bright (maximum alpha)
	// Otherwise it stays dim (as set above) leaving the text at uniform
	// dim brightness
	if (animationTimer) {
		gradientComponents[7] = alpha;
	}
    
	// Load RGB Colorspace
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	
	// Create Gradient
	CGGradientRef gradient = CGGradientCreateWithColorComponents (colorspace, gradientComponents,
																  gradientLocations, num_locations);
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:rect];
    
    CGContextSaveGState(theContext);
    [rectPath addClip];
    CGContextTranslateCTM(theContext, 0, textMask.size.height);
    CGContextScaleCTM(theContext, 1.0, -1.0);
    CGContextClipToMask(theContext, rect, textMask.CGImage);
//    [[UIColor whiteColor] setFill];
    
    // Draw the gradient (using label text as the clipping path)
	CGContextDrawLinearGradient (theContext, gradient, self.bounds.origin, CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)), 0);
    CGContextRestoreGState(theContext);
//    CGContextSaveGState(theContext);
//    CGContextSetBlendMode(theContext, kCGBlendModeClear);
//    [[UIColor whiteColor] setFill];
//    [self.text drawInRect:rect withAttributes:nil];
//    [self.text drawAtPoint:CGPointMake(0,0) forWidth:CGRectGetWidth(rect) withFont:self.font fontSize:24 lineBreakMode:NSLineBreakByClipping baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
//    CGContextRestoreGState(theContext);
	
    
    
    
	// Cleanup
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorspace);
}


//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
////    CGContextRef context = UIGraphicsGetCurrentContext();
//
////    [[UIColor redColor] setFill];
////    [self.text drawAtPoint:CGPointMake(0,0) forWidth:CGRectGetWidth(self.frame) withFont:self.font fontSize:22 lineBreakMode:NSLineBreakByClipping baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
//    CGContextRef theContext = UIGraphicsGetCurrentContext();
//    // Set the font
//
//    UIBezierPath *textPath = [self getTextPath:rect];
//    
//	// Calculate text width
////	CGPoint textEnd = CGContextGetTextPosition(theContext);
//    
//	
//	// Get the foreground text color from the UILabel.
//	// Note: UIColor color space may be either monochrome or RGB.
//	// If monochrome, there are 2 components, including alpha.
//	// If RGB, there are 4 components, including alpha.
//	CGColorRef textColor = self.textColor.CGColor;
//	const CGFloat *components = CGColorGetComponents(textColor);
//	size_t numberOfComponents = CGColorGetNumberOfComponents(textColor);
//	BOOL isRGB = (numberOfComponents == 4);
//	CGFloat red = components[0];
//	CGFloat green = isRGB ? components[1] : components[0];
//	CGFloat blue = isRGB ? components[2] : components[0];
//	CGFloat alpha = isRGB ? components[3] : components[1];
//    
//	// The gradient has 4 sections, whose relative positions are defined by
//	// the "gradientLocations" array:
//	// 1) from 0.0 to gradientLocations[0] (dim)
//	// 2) from gradientLocations[0] to gradientLocations[1] (increasing brightness)
//	// 3) from gradientLocations[1] to gradientLocations[2] (decreasing brightness)
//	// 4) from gradientLocations[3] to 1.0 (dim)
//	size_t num_locations = 3;
//	
//	// The gradientComponents array is a 4 x 3 matrix. Each row of the matrix
//	// defines the R, G, B, and alpha values to be used by the corresponding
//	// element of the gradientLocations array
//	CGFloat gradientComponents[12];
//	for (int row = 0; row < num_locations; row++) {
//		int index = 4 * row;
//		gradientComponents[index++] = red;
//		gradientComponents[index++] = green;
//		gradientComponents[index++] = blue;
//		gradientComponents[index] = alpha * gradientDimAlpha;
//	}
//    
//	// If animating, set the center of the gradient to be bright (maximum alpha)
//	// Otherwise it stays dim (as set above) leaving the text at uniform
//	// dim brightness
//	if (animationTimer) {
//		gradientComponents[7] = alpha;
//	}
//    
//	// Load RGB Colorspace
//	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
//	
//	// Create Gradient
//	CGGradientRef gradient = CGGradientCreateWithColorComponents (colorspace, gradientComponents,
//																  gradientLocations, num_locations);
//    
//    CGContextSaveGState(theContext);
//    [textPath addClip];
//	// Draw the gradient (using label text as the clipping path)
//	CGContextDrawLinearGradient (theContext, gradient, self.bounds.origin, CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)), 0);
//
//    CGContextRestoreGState(theContext);
//	// Cleanup
//	CGGradientRelease(gradient);
//	CGColorSpaceRelease(colorspace);
//}
#pragma mark - Label Animation

// animationTimer methods
- (void)animationTimerFired:(NSTimer*)theTimer {
	// Let the timer run for 2 * FPS rate before resetting.
	// This gives one second of sliding the highlight off to the right, plus one
	// additional second of uniform dimness
	if (++animationTimerCount == (2 * animationFramesPerSec)) {
		animationTimerCount = 0;
	}
	
	// Update the gradient for the next frame
	[self setGradientLocations:((CGFloat)animationTimerCount/(CGFloat)animationFramesPerSec)];
}

- (void) startTimer {
	if (!animationTimer) {
		animationTimerCount = 0;
		[self setGradientLocations:0];
//        animationTimer = [NSTimer
//                          scheduledTimerWithTimeInterval:1.0/animationFramesPerSec
//                          target:self
//                          selector:@selector(animationTimerFired:)
//                          userInfo:nil
//                          repeats:YES];
        animationTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationTimerFired:)];
        animationTimer.frameInterval = 60.0/animationFramesPerSec;
        [animationTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	}
}

- (void) stopTimer {
	if (animationTimer) {
        animationTimerCount = 0;
        [self setNeedsDisplay];
		[animationTimer invalidate];
		animationTimer = nil;
	}
}
//
//// label's layer delegate method
//- (void)drawLayer:(CALayer *)theLayer
//        inContext:(CGContextRef)theContext
//{
//    if (theLayer != textLabel.layer)
//        return;
//}

- (void) setGradientLocations:(CGFloat) leftEdge {
	// Subtract the gradient width to start the animation with the brightest
	// part (center) of the gradient at left edge of the label text
	leftEdge -= gradientWidth;
	
	//position the bright segment of the gradient, keeping all segments within the range 0..1
	gradientLocations[0] = leftEdge < 0.0 ? 0.0 : (leftEdge > 1.0 ? 1.0 : leftEdge);
	gradientLocations[1] = MIN(leftEdge + gradientWidth, 1.0);
	gradientLocations[2] = MIN(gradientLocations[1] + gradientWidth, 1.0);
	
	// Re-render the label text
	[self setNeedsDisplay];
}


- (UIBezierPath*)getTextPath:(CGRect)frame
{
    //// Frames
    static UIBezierPath *pc = nil;
    if (pc != nil) {
        return pc;
    }
    
    //// Text Drawing
    UIBezierPath* textPath = [UIBezierPath bezierPath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 8.09, CGRectGetMinY(frame) + 15.83)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 6.98, CGRectGetMinY(frame) + 17.44) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 7.75, CGRectGetMinY(frame) + 16.3) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 7.38, CGRectGetMinY(frame) + 16.83)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 5.74, CGRectGetMinY(frame) + 19.4) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 6.58, CGRectGetMinY(frame) + 18.05) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 6.17, CGRectGetMinY(frame) + 18.7)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 4.43, CGRectGetMinY(frame) + 21.56) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 5.3, CGRectGetMinY(frame) + 20.09) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 4.87, CGRectGetMinY(frame) + 20.81)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 3.14, CGRectGetMinY(frame) + 23.78) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 3.99, CGRectGetMinY(frame) + 22.3) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 3.56, CGRectGetMinY(frame) + 23.04)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 2.39, CGRectGetMinY(frame) + 23.15) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 2.87, CGRectGetMinY(frame) + 23.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 2.62, CGRectGetMinY(frame) + 23.3)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 1.61, CGRectGetMinY(frame) + 22.77) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 2.16, CGRectGetMinY(frame) + 23.01) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 1.9, CGRectGetMinY(frame) + 22.88)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 3.06, CGRectGetMinY(frame) + 20.91) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 2.07, CGRectGetMinY(frame) + 22.22) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 2.56, CGRectGetMinY(frame) + 21.6)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 4.52, CGRectGetMinY(frame) + 18.76) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 3.56, CGRectGetMinY(frame) + 20.21) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 4.05, CGRectGetMinY(frame) + 19.5)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 5.83, CGRectGetMinY(frame) + 16.61) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 5, CGRectGetMinY(frame) + 18.02) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 5.43, CGRectGetMinY(frame) + 17.31)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 6.82, CGRectGetMinY(frame) + 14.75) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 6.23, CGRectGetMinY(frame) + 15.92) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 6.56, CGRectGetMinY(frame) + 15.3)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 7.4, CGRectGetMinY(frame) + 15.41) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 7.02, CGRectGetMinY(frame) + 15.04) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 7.22, CGRectGetMinY(frame) + 15.26)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 8.09, CGRectGetMinY(frame) + 15.83) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 7.59, CGRectGetMinY(frame) + 15.56) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 7.82, CGRectGetMinY(frame) + 15.7)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 5.78, CGRectGetMinY(frame) + 13.34)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 3.65, CGRectGetMinY(frame) + 11.8) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 5.18, CGRectGetMinY(frame) + 12.79) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 4.46, CGRectGetMinY(frame) + 12.28)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 1.34, CGRectGetMinY(frame) + 10.62) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 2.83, CGRectGetMinY(frame) + 11.32) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 2.06, CGRectGetMinY(frame) + 10.93)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 2.14, CGRectGetMinY(frame) + 9.26)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 3.24, CGRectGetMinY(frame) + 9.83) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 2.47, CGRectGetMinY(frame) + 9.42) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 2.84, CGRectGetMinY(frame) + 9.61)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 4.46, CGRectGetMinY(frame) + 10.53) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 3.64, CGRectGetMinY(frame) + 10.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 4.05, CGRectGetMinY(frame) + 10.29)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 5.69, CGRectGetMinY(frame) + 11.27) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 4.88, CGRectGetMinY(frame) + 10.77) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 5.29, CGRectGetMinY(frame) + 11.02)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 6.77, CGRectGetMinY(frame) + 11.99) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 6.09, CGRectGetMinY(frame) + 11.53) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 6.45, CGRectGetMinY(frame) + 11.77)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 5.78, CGRectGetMinY(frame) + 13.34)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 7.3, CGRectGetMinY(frame) + 7.55)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 5.38, CGRectGetMinY(frame) + 6.08) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 6.67, CGRectGetMinY(frame) + 7.01) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 6.03, CGRectGetMinY(frame) + 6.52)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 3, CGRectGetMinY(frame) + 4.65) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 4.72, CGRectGetMinY(frame) + 5.64) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 3.93, CGRectGetMinY(frame) + 5.16)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 3.89, CGRectGetMinY(frame) + 3.33)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 6.26, CGRectGetMinY(frame) + 4.77) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 4.72, CGRectGetMinY(frame) + 3.79) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 5.51, CGRectGetMinY(frame) + 4.27)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 8.33, CGRectGetMinY(frame) + 6.21) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 7.02, CGRectGetMinY(frame) + 5.26) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 7.7, CGRectGetMinY(frame) + 5.74)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 7.3, CGRectGetMinY(frame) + 7.55)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 11.62, CGRectGetMinY(frame) + 23.99)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 10.08, CGRectGetMinY(frame) + 23.99)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 10.19, CGRectGetMinY(frame) + 22.6) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 10.13, CGRectGetMinY(frame) + 23.45) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 10.16, CGRectGetMinY(frame) + 22.98)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 10.22, CGRectGetMinY(frame) + 21.33) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 10.21, CGRectGetMinY(frame) + 22.22) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 10.22, CGRectGetMinY(frame) + 21.79)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 10.22, CGRectGetMinY(frame) + 15.5)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 10.19, CGRectGetMinY(frame) + 13.97) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 10.22, CGRectGetMinY(frame) + 14.98) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 10.21, CGRectGetMinY(frame) + 14.48)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 10.1, CGRectGetMinY(frame) + 12.83) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 10.16, CGRectGetMinY(frame) + 13.47) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 10.14, CGRectGetMinY(frame) + 13.09)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 10.92, CGRectGetMinY(frame) + 12.88) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 10.25, CGRectGetMinY(frame) + 12.85) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 10.52, CGRectGetMinY(frame) + 12.86)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 12.26, CGRectGetMinY(frame) + 12.93) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 11.32, CGRectGetMinY(frame) + 12.9) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 11.77, CGRectGetMinY(frame) + 12.91)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 13.82, CGRectGetMinY(frame) + 12.96) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 12.76, CGRectGetMinY(frame) + 12.94) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 13.28, CGRectGetMinY(frame) + 12.96)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 15.29, CGRectGetMinY(frame) + 12.98) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 14.37, CGRectGetMinY(frame) + 12.97) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 14.86, CGRectGetMinY(frame) + 12.98)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 16.81, CGRectGetMinY(frame) + 12.96) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 15.77, CGRectGetMinY(frame) + 12.98) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 16.28, CGRectGetMinY(frame) + 12.97)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 18.36, CGRectGetMinY(frame) + 12.93) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 17.35, CGRectGetMinY(frame) + 12.96) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 17.86, CGRectGetMinY(frame) + 12.94)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 19.67, CGRectGetMinY(frame) + 12.88) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 18.86, CGRectGetMinY(frame) + 12.91) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 19.29, CGRectGetMinY(frame) + 12.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 20.45, CGRectGetMinY(frame) + 12.83) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 20.04, CGRectGetMinY(frame) + 12.86) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 20.3, CGRectGetMinY(frame) + 12.85)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 20.38, CGRectGetMinY(frame) + 14.12) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 20.42, CGRectGetMinY(frame) + 13.3) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 20.39, CGRectGetMinY(frame) + 13.72)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 20.35, CGRectGetMinY(frame) + 15.4) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 20.36, CGRectGetMinY(frame) + 14.51) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 20.35, CGRectGetMinY(frame) + 14.94)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 20.35, CGRectGetMinY(frame) + 21.78)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 20.24, CGRectGetMinY(frame) + 22.74) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 20.35, CGRectGetMinY(frame) + 22.17) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 20.32, CGRectGetMinY(frame) + 22.49)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 19.81, CGRectGetMinY(frame) + 23.36) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 20.17, CGRectGetMinY(frame) + 23) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 20.03, CGRectGetMinY(frame) + 23.2)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 18.85, CGRectGetMinY(frame) + 23.72) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 19.6, CGRectGetMinY(frame) + 23.51) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 19.28, CGRectGetMinY(frame) + 23.63)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 17.18, CGRectGetMinY(frame) + 23.92) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 18.43, CGRectGetMinY(frame) + 23.8) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 17.87, CGRectGetMinY(frame) + 23.87)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 17.1, CGRectGetMinY(frame) + 23.08) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 17.2, CGRectGetMinY(frame) + 23.65) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 17.17, CGRectGetMinY(frame) + 23.37)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 16.66, CGRectGetMinY(frame) + 22.19) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 17.03, CGRectGetMinY(frame) + 22.79) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 16.88, CGRectGetMinY(frame) + 22.5)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 17.88, CGRectGetMinY(frame) + 22.34) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 17.17, CGRectGetMinY(frame) + 22.27) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 17.58, CGRectGetMinY(frame) + 22.32)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 18.56, CGRectGetMinY(frame) + 22.28) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 18.18, CGRectGetMinY(frame) + 22.35) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 18.41, CGRectGetMinY(frame) + 22.33)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 18.86, CGRectGetMinY(frame) + 22) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 18.72, CGRectGetMinY(frame) + 22.22) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 18.82, CGRectGetMinY(frame) + 22.13)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 18.94, CGRectGetMinY(frame) + 21.52) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 18.91, CGRectGetMinY(frame) + 21.87) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 18.94, CGRectGetMinY(frame) + 21.71)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 18.94, CGRectGetMinY(frame) + 19.96)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 11.62, CGRectGetMinY(frame) + 19.96)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 11.62, CGRectGetMinY(frame) + 23.99)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 11.62, CGRectGetMinY(frame) + 17.01)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 11.62, CGRectGetMinY(frame) + 18.9)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 18.94, CGRectGetMinY(frame) + 18.9)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 18.94, CGRectGetMinY(frame) + 17.01)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 11.62, CGRectGetMinY(frame) + 17.01)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 18.94, CGRectGetMinY(frame) + 15.93)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 18.94, CGRectGetMinY(frame) + 14.03)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 11.62, CGRectGetMinY(frame) + 14.03)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 11.62, CGRectGetMinY(frame) + 15.93)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 18.94, CGRectGetMinY(frame) + 15.93)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 11.59, CGRectGetMinY(frame) + 10.26)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 15.02, CGRectGetMinY(frame) + 10.26)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 15.02, CGRectGetMinY(frame) + 7.89)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 11.59, CGRectGetMinY(frame) + 7.89)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 11.59, CGRectGetMinY(frame) + 10.26)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 18.72, CGRectGetMinY(frame) + 5.01)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 11.59, CGRectGetMinY(frame) + 5.01)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 11.59, CGRectGetMinY(frame) + 6.76)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 16.32, CGRectGetMinY(frame) + 6.76)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 16.32, CGRectGetMinY(frame) + 10.26)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 18.72, CGRectGetMinY(frame) + 10.26)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 18.72, CGRectGetMinY(frame) + 5.01)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 10.25, CGRectGetMinY(frame) + 6.09)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 10.21, CGRectGetMinY(frame) + 4.71) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 10.25, CGRectGetMinY(frame) + 5.53) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 10.24, CGRectGetMinY(frame) + 5.07)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 10.08, CGRectGetMinY(frame) + 3.71) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 10.19, CGRectGetMinY(frame) + 4.35) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 10.14, CGRectGetMinY(frame) + 4.02)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 10.94, CGRectGetMinY(frame) + 3.78) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 10.27, CGRectGetMinY(frame) + 3.74) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 10.56, CGRectGetMinY(frame) + 3.77)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 12.23, CGRectGetMinY(frame) + 3.84) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 11.33, CGRectGetMinY(frame) + 3.8) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 11.76, CGRectGetMinY(frame) + 3.82)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 13.72, CGRectGetMinY(frame) + 3.89) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 12.7, CGRectGetMinY(frame) + 3.87) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 13.2, CGRectGetMinY(frame) + 3.88)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 15.22, CGRectGetMinY(frame) + 3.9) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 14.24, CGRectGetMinY(frame) + 3.9) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 14.74, CGRectGetMinY(frame) + 3.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 16.72, CGRectGetMinY(frame) + 3.89) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 15.7, CGRectGetMinY(frame) + 3.9) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 16.2, CGRectGetMinY(frame) + 3.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 18.19, CGRectGetMinY(frame) + 3.86) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 17.24, CGRectGetMinY(frame) + 3.88) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 17.73, CGRectGetMinY(frame) + 3.87)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 19.45, CGRectGetMinY(frame) + 3.8) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 18.66, CGRectGetMinY(frame) + 3.84) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 19.08, CGRectGetMinY(frame) + 3.82)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 20.3, CGRectGetMinY(frame) + 3.71) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 19.83, CGRectGetMinY(frame) + 3.77) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 20.11, CGRectGetMinY(frame) + 3.74)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 20.18, CGRectGetMinY(frame) + 4.8) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 20.24, CGRectGetMinY(frame) + 4.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 20.2, CGRectGetMinY(frame) + 4.43)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 20.16, CGRectGetMinY(frame) + 6.09) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 20.17, CGRectGetMinY(frame) + 5.18) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 20.16, CGRectGetMinY(frame) + 5.61)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 20.16, CGRectGetMinY(frame) + 10.24)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 21.59, CGRectGetMinY(frame) + 10.17) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 20.69, CGRectGetMinY(frame) + 10.22) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 21.16, CGRectGetMinY(frame) + 10.2)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 22.63, CGRectGetMinY(frame) + 10.05) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 22.01, CGRectGetMinY(frame) + 10.14) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 22.36, CGRectGetMinY(frame) + 10.1)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 22.63, CGRectGetMinY(frame) + 13.5)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 21.29, CGRectGetMinY(frame) + 13.5)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 21.29, CGRectGetMinY(frame) + 11.37)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 9.24, CGRectGetMinY(frame) + 11.37)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 9.24, CGRectGetMinY(frame) + 13.58)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 7.87, CGRectGetMinY(frame) + 13.58)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 7.87, CGRectGetMinY(frame) + 10.05)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 8.84, CGRectGetMinY(frame) + 10.17) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 8.08, CGRectGetMinY(frame) + 10.1) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 8.4, CGRectGetMinY(frame) + 10.14)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 10.25, CGRectGetMinY(frame) + 10.24) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 9.28, CGRectGetMinY(frame) + 10.2) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 9.75, CGRectGetMinY(frame) + 10.22)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 10.25, CGRectGetMinY(frame) + 6.09)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 41.52, CGRectGetMinY(frame) + 8.75)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 41.21, CGRectGetMinY(frame) + 14.28) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 41.49, CGRectGetMinY(frame) + 10.88) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 41.38, CGRectGetMinY(frame) + 12.72)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 40.34, CGRectGetMinY(frame) + 18.42) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 41.03, CGRectGetMinY(frame) + 15.84) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 40.74, CGRectGetMinY(frame) + 17.22)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 38.75, CGRectGetMinY(frame) + 21.66) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 39.94, CGRectGetMinY(frame) + 19.62) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 39.41, CGRectGetMinY(frame) + 20.7)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 36.24, CGRectGetMinY(frame) + 24.47) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 38.08, CGRectGetMinY(frame) + 22.62) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 37.25, CGRectGetMinY(frame) + 23.56)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 34.66, CGRectGetMinY(frame) + 23.39) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 35.84, CGRectGetMinY(frame) + 24.07) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 35.31, CGRectGetMinY(frame) + 23.71)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 37.39, CGRectGetMinY(frame) + 20.93) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 35.78, CGRectGetMinY(frame) + 22.62) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 36.69, CGRectGetMinY(frame) + 21.8)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 39.05, CGRectGetMinY(frame) + 17.91) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 38.1, CGRectGetMinY(frame) + 20.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 38.65, CGRectGetMinY(frame) + 19.05)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 39.88, CGRectGetMinY(frame) + 13.97) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 39.45, CGRectGetMinY(frame) + 16.76) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 39.72, CGRectGetMinY(frame) + 15.45)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 40.13, CGRectGetMinY(frame) + 8.75) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 40.03, CGRectGetMinY(frame) + 12.49) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 40.11, CGRectGetMinY(frame) + 10.75)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 38.98, CGRectGetMinY(frame) + 8.76) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 39.76, CGRectGetMinY(frame) + 8.75) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 39.38, CGRectGetMinY(frame) + 8.76)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 37.84, CGRectGetMinY(frame) + 8.81) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 38.58, CGRectGetMinY(frame) + 8.77) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 38.2, CGRectGetMinY(frame) + 8.79)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 36.84, CGRectGetMinY(frame) + 8.88) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 37.48, CGRectGetMinY(frame) + 8.84) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 37.14, CGRectGetMinY(frame) + 8.86)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 36.14, CGRectGetMinY(frame) + 8.94) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 36.54, CGRectGetMinY(frame) + 8.91) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 36.3, CGRectGetMinY(frame) + 8.93)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 36.14, CGRectGetMinY(frame) + 7.29)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 37.7, CGRectGetMinY(frame) + 7.44) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 36.54, CGRectGetMinY(frame) + 7.35) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 37.06, CGRectGetMinY(frame) + 7.4)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 40.13, CGRectGetMinY(frame) + 7.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 38.34, CGRectGetMinY(frame) + 7.48) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 39.15, CGRectGetMinY(frame) + 7.5)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 40.13, CGRectGetMinY(frame) + 5.4) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 40.13, CGRectGetMinY(frame) + 6.67) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 40.13, CGRectGetMinY(frame) + 5.97)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 40.1, CGRectGetMinY(frame) + 3.99) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 40.13, CGRectGetMinY(frame) + 4.84) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 40.12, CGRectGetMinY(frame) + 4.36)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 40.06, CGRectGetMinY(frame) + 3.08) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 40.09, CGRectGetMinY(frame) + 3.61) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 40.07, CGRectGetMinY(frame) + 3.31)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 39.98, CGRectGetMinY(frame) + 2.46) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 40.04, CGRectGetMinY(frame) + 2.84) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 40.02, CGRectGetMinY(frame) + 2.64)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 40.93, CGRectGetMinY(frame) + 2.63) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 40.3, CGRectGetMinY(frame) + 2.54) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 40.62, CGRectGetMinY(frame) + 2.6)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 41.88, CGRectGetMinY(frame) + 2.66) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 41.24, CGRectGetMinY(frame) + 2.66) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 41.56, CGRectGetMinY(frame) + 2.67)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 42.26, CGRectGetMinY(frame) + 2.85) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 42.09, CGRectGetMinY(frame) + 2.66) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 42.22, CGRectGetMinY(frame) + 2.72)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 42, CGRectGetMinY(frame) + 3.3) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 42.31, CGRectGetMinY(frame) + 2.98) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 42.22, CGRectGetMinY(frame) + 3.13)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 41.78, CGRectGetMinY(frame) + 3.58) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 41.92, CGRectGetMinY(frame) + 3.37) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 41.85, CGRectGetMinY(frame) + 3.46)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 41.64, CGRectGetMinY(frame) + 4.19) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 41.72, CGRectGetMinY(frame) + 3.7) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 41.67, CGRectGetMinY(frame) + 3.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 41.56, CGRectGetMinY(frame) + 5.4) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 41.61, CGRectGetMinY(frame) + 4.48) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 41.58, CGRectGetMinY(frame) + 4.88)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 41.52, CGRectGetMinY(frame) + 7.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 41.53, CGRectGetMinY(frame) + 5.92) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 41.52, CGRectGetMinY(frame) + 6.62)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 44.53, CGRectGetMinY(frame) + 7.44) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 42.64, CGRectGetMinY(frame) + 7.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 43.64, CGRectGetMinY(frame) + 7.48)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 46.44, CGRectGetMinY(frame) + 7.29) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 45.42, CGRectGetMinY(frame) + 7.4) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 46.06, CGRectGetMinY(frame) + 7.35)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 46.08, CGRectGetMinY(frame) + 20.44)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 45.9, CGRectGetMinY(frame) + 22.01) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 46.06, CGRectGetMinY(frame) + 21.08) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 46, CGRectGetMinY(frame) + 21.6)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 45.28, CGRectGetMinY(frame) + 23.01) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 45.8, CGRectGetMinY(frame) + 22.42) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 45.59, CGRectGetMinY(frame) + 22.75)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 43.92, CGRectGetMinY(frame) + 23.61) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 44.96, CGRectGetMinY(frame) + 23.26) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 44.51, CGRectGetMinY(frame) + 23.46)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 41.52, CGRectGetMinY(frame) + 23.97) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 43.33, CGRectGetMinY(frame) + 23.75) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 42.53, CGRectGetMinY(frame) + 23.87)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 41.28, CGRectGetMinY(frame) + 22.91) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 41.47, CGRectGetMinY(frame) + 23.55) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 41.39, CGRectGetMinY(frame) + 23.2)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 40.73, CGRectGetMinY(frame) + 21.98) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 41.17, CGRectGetMinY(frame) + 22.62) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 40.98, CGRectGetMinY(frame) + 22.31)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 42.73, CGRectGetMinY(frame) + 22.11) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 41.56, CGRectGetMinY(frame) + 22.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 42.23, CGRectGetMinY(frame) + 22.1)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 43.91, CGRectGetMinY(frame) + 21.94) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 43.24, CGRectGetMinY(frame) + 22.12) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 43.63, CGRectGetMinY(frame) + 22.06)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 44.46, CGRectGetMinY(frame) + 21.34) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 44.19, CGRectGetMinY(frame) + 21.82) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 44.37, CGRectGetMinY(frame) + 21.62)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 44.62, CGRectGetMinY(frame) + 20.2) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 44.55, CGRectGetMinY(frame) + 21.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 44.6, CGRectGetMinY(frame) + 20.68)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 44.95, CGRectGetMinY(frame) + 8.75)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 41.52, CGRectGetMinY(frame) + 8.75)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 29.52, CGRectGetMinY(frame) + 11.7)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 27.29, CGRectGetMinY(frame) + 11.75) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 28.7, CGRectGetMinY(frame) + 11.7) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 27.96, CGRectGetMinY(frame) + 11.72)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 25.58, CGRectGetMinY(frame) + 11.9) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 26.62, CGRectGetMinY(frame) + 11.78) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 26.05, CGRectGetMinY(frame) + 11.83)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 25.58, CGRectGetMinY(frame) + 10.34)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 27.86, CGRectGetMinY(frame) + 10.49) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 26.19, CGRectGetMinY(frame) + 10.42) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 26.95, CGRectGetMinY(frame) + 10.47)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 30.91, CGRectGetMinY(frame) + 10.53) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 28.78, CGRectGetMinY(frame) + 10.52) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 29.79, CGRectGetMinY(frame) + 10.53)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 34.01, CGRectGetMinY(frame) + 10.49) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 32.06, CGRectGetMinY(frame) + 10.53) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 33.1, CGRectGetMinY(frame) + 10.52)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 36.29, CGRectGetMinY(frame) + 10.34) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 34.92, CGRectGetMinY(frame) + 10.47) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 35.68, CGRectGetMinY(frame) + 10.42)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 36.29, CGRectGetMinY(frame) + 11.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 34.08, CGRectGetMinY(frame) + 11.74) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 35.7, CGRectGetMinY(frame) + 11.82) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 34.96, CGRectGetMinY(frame) + 11.76)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 31.13, CGRectGetMinY(frame) + 11.7) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 33.2, CGRectGetMinY(frame) + 11.72) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 32.22, CGRectGetMinY(frame) + 11.7)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 30.41, CGRectGetMinY(frame) + 13.68) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 30.89, CGRectGetMinY(frame) + 12.41) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 30.65, CGRectGetMinY(frame) + 13.07)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 29.68, CGRectGetMinY(frame) + 15.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 30.17, CGRectGetMinY(frame) + 14.3) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 29.92, CGRectGetMinY(frame) + 14.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 28.9, CGRectGetMinY(frame) + 17.27) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 29.43, CGRectGetMinY(frame) + 16.09) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 29.17, CGRectGetMinY(frame) + 16.68)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 28.01, CGRectGetMinY(frame) + 19.17) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 28.62, CGRectGetMinY(frame) + 17.86) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 28.33, CGRectGetMinY(frame) + 18.5)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 34.44, CGRectGetMinY(frame) + 18.33)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 32.02, CGRectGetMinY(frame) + 14.22) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 33.8, CGRectGetMinY(frame) + 16.97) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 32.99, CGRectGetMinY(frame) + 15.6)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 33.22, CGRectGetMinY(frame) + 13.43)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 35.18, CGRectGetMinY(frame) + 16.8) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 33.94, CGRectGetMinY(frame) + 14.55) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 34.59, CGRectGetMinY(frame) + 15.68)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 36.89, CGRectGetMinY(frame) + 20.37) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 35.78, CGRectGetMinY(frame) + 17.93) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 36.34, CGRectGetMinY(frame) + 19.12)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 35.47, CGRectGetMinY(frame) + 21.14)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 35.22, CGRectGetMinY(frame) + 20.31) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 35.39, CGRectGetMinY(frame) + 20.86) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 35.31, CGRectGetMinY(frame) + 20.59)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 34.92, CGRectGetMinY(frame) + 19.48) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 35.13, CGRectGetMinY(frame) + 20.03) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 35.03, CGRectGetMinY(frame) + 19.75)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 30.86, CGRectGetMinY(frame) + 20.08)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 28.16, CGRectGetMinY(frame) + 20.56) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 29.76, CGRectGetMinY(frame) + 20.24) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 28.86, CGRectGetMinY(frame) + 20.4)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 26.3, CGRectGetMinY(frame) + 21.09) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 27.47, CGRectGetMinY(frame) + 20.72) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 26.85, CGRectGetMinY(frame) + 20.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 25.56, CGRectGetMinY(frame) + 19.36) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 26.19, CGRectGetMinY(frame) + 20.38) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 25.94, CGRectGetMinY(frame) + 19.81)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 26.16, CGRectGetMinY(frame) + 19.17) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 25.77, CGRectGetMinY(frame) + 19.34) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 25.97, CGRectGetMinY(frame) + 19.28)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 26.74, CGRectGetMinY(frame) + 18.64) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 26.35, CGRectGetMinY(frame) + 19.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 26.54, CGRectGetMinY(frame) + 18.88)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 27.32, CGRectGetMinY(frame) + 17.66) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 26.93, CGRectGetMinY(frame) + 18.4) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 27.12, CGRectGetMinY(frame) + 18.07)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 28.01, CGRectGetMinY(frame) + 16.07) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 27.52, CGRectGetMinY(frame) + 17.24) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 27.75, CGRectGetMinY(frame) + 16.71)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 28.56, CGRectGetMinY(frame) + 14.62) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 28.22, CGRectGetMinY(frame) + 15.53) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 28.4, CGRectGetMinY(frame) + 15.04)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 28.98, CGRectGetMinY(frame) + 13.47) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 28.72, CGRectGetMinY(frame) + 14.2) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 28.86, CGRectGetMinY(frame) + 13.81)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 29.29, CGRectGetMinY(frame) + 12.53) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 29.1, CGRectGetMinY(frame) + 13.12) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 29.2, CGRectGetMinY(frame) + 12.81)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 29.52, CGRectGetMinY(frame) + 11.7) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 29.38, CGRectGetMinY(frame) + 12.25) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 29.46, CGRectGetMinY(frame) + 11.98)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 35.62, CGRectGetMinY(frame) + 6.54)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 33.71, CGRectGetMinY(frame) + 6.4) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 35.1, CGRectGetMinY(frame) + 6.48) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 34.47, CGRectGetMinY(frame) + 6.43)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 31.2, CGRectGetMinY(frame) + 6.35) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 32.95, CGRectGetMinY(frame) + 6.37) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 32.11, CGRectGetMinY(frame) + 6.35)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 28.66, CGRectGetMinY(frame) + 6.4) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 30.27, CGRectGetMinY(frame) + 6.35) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 29.42, CGRectGetMinY(frame) + 6.37)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 26.74, CGRectGetMinY(frame) + 6.54) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 27.89, CGRectGetMinY(frame) + 6.43) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 27.25, CGRectGetMinY(frame) + 6.48)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 26.74, CGRectGetMinY(frame) + 4.98)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 28.64, CGRectGetMinY(frame) + 5.13) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 27.25, CGRectGetMinY(frame) + 5.05) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 27.88, CGRectGetMinY(frame) + 5.1)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 31.15, CGRectGetMinY(frame) + 5.18) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 29.4, CGRectGetMinY(frame) + 5.16) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 30.24, CGRectGetMinY(frame) + 5.18)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 33.71, CGRectGetMinY(frame) + 5.13) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 32.1, CGRectGetMinY(frame) + 5.18) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 32.95, CGRectGetMinY(frame) + 5.16)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 35.62, CGRectGetMinY(frame) + 4.98) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 34.47, CGRectGetMinY(frame) + 5.1) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 35.1, CGRectGetMinY(frame) + 5.05)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 35.62, CGRectGetMinY(frame) + 6.54)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 57.55, CGRectGetMinY(frame) + 20.39)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 52.91, CGRectGetMinY(frame) + 21.44) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 55.66, CGRectGetMinY(frame) + 20.79) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 54.12, CGRectGetMinY(frame) + 21.14)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 50.04, CGRectGetMinY(frame) + 22.24) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 51.7, CGRectGetMinY(frame) + 21.73) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 50.74, CGRectGetMinY(frame) + 22)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 49.81, CGRectGetMinY(frame) + 21.3) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 49.99, CGRectGetMinY(frame) + 21.9) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 49.92, CGRectGetMinY(frame) + 21.59)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 49.34, CGRectGetMinY(frame) + 20.39) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 49.71, CGRectGetMinY(frame) + 21.02) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 49.55, CGRectGetMinY(frame) + 20.71)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 51.31, CGRectGetMinY(frame) + 20.24) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 50.02, CGRectGetMinY(frame) + 20.36) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 50.67, CGRectGetMinY(frame) + 20.31)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 53.23, CGRectGetMinY(frame) + 19.96) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 51.95, CGRectGetMinY(frame) + 20.16) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 52.59, CGRectGetMinY(frame) + 20.07)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 55.21, CGRectGetMinY(frame) + 19.55) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 53.87, CGRectGetMinY(frame) + 19.85) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 54.53, CGRectGetMinY(frame) + 19.71)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 57.38, CGRectGetMinY(frame) + 19) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 55.89, CGRectGetMinY(frame) + 19.39) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 56.62, CGRectGetMinY(frame) + 19.21)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 57.55, CGRectGetMinY(frame) + 20.39) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 57.37, CGRectGetMinY(frame) + 19.42) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 57.42, CGRectGetMinY(frame) + 19.88)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 51.53, CGRectGetMinY(frame) + 11.25)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 50.6, CGRectGetMinY(frame) + 11.39) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 51.22, CGRectGetMinY(frame) + 11.28) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 50.92, CGRectGetMinY(frame) + 11.33)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 49.8, CGRectGetMinY(frame) + 11.63) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 50.29, CGRectGetMinY(frame) + 11.46) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 50.02, CGRectGetMinY(frame) + 11.54)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 49.61, CGRectGetMinY(frame) + 10.71) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 49.78, CGRectGetMinY(frame) + 11.34) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 49.72, CGRectGetMinY(frame) + 11.04)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 49.22, CGRectGetMinY(frame) + 9.9) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 49.5, CGRectGetMinY(frame) + 10.38) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 49.37, CGRectGetMinY(frame) + 10.11)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 50.92, CGRectGetMinY(frame) + 8.08) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 49.69, CGRectGetMinY(frame) + 9.81) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 50.25, CGRectGetMinY(frame) + 9.2)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 53.3, CGRectGetMinY(frame) + 2.8) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 51.58, CGRectGetMinY(frame) + 6.96) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 52.38, CGRectGetMinY(frame) + 5.2)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 54.13, CGRectGetMinY(frame) + 3.29) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 53.58, CGRectGetMinY(frame) + 3.01) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 53.85, CGRectGetMinY(frame) + 3.17)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 54.96, CGRectGetMinY(frame) + 3.57) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 54.41, CGRectGetMinY(frame) + 3.41) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 54.69, CGRectGetMinY(frame) + 3.5)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 55.34, CGRectGetMinY(frame) + 3.82) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 55.2, CGRectGetMinY(frame) + 3.62) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 55.33, CGRectGetMinY(frame) + 3.7)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 55.01, CGRectGetMinY(frame) + 4.12) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 55.36, CGRectGetMinY(frame) + 3.94) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 55.25, CGRectGetMinY(frame) + 4.04)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 54.6, CGRectGetMinY(frame) + 4.36) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 54.88, CGRectGetMinY(frame) + 4.17) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 54.74, CGRectGetMinY(frame) + 4.25)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 54, CGRectGetMinY(frame) + 5.13) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 54.46, CGRectGetMinY(frame) + 4.47) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 54.26, CGRectGetMinY(frame) + 4.73)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 52.98, CGRectGetMinY(frame) + 6.88) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 53.74, CGRectGetMinY(frame) + 5.53) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 53.4, CGRectGetMinY(frame) + 6.11)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 51.26, CGRectGetMinY(frame) + 10.05) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 52.56, CGRectGetMinY(frame) + 7.65) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 51.98, CGRectGetMinY(frame) + 8.7)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 54.79, CGRectGetMinY(frame) + 9.88)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 55.69, CGRectGetMinY(frame) + 8.28) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 55.21, CGRectGetMinY(frame) + 9.19) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 55.51, CGRectGetMinY(frame) + 8.66)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 56.11, CGRectGetMinY(frame) + 7.22) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 55.88, CGRectGetMinY(frame) + 7.91) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 56.02, CGRectGetMinY(frame) + 7.55)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 56.92, CGRectGetMinY(frame) + 7.84) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 56.37, CGRectGetMinY(frame) + 7.44) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 56.64, CGRectGetMinY(frame) + 7.65)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 57.67, CGRectGetMinY(frame) + 8.3) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 57.2, CGRectGetMinY(frame) + 8.03) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 57.45, CGRectGetMinY(frame) + 8.18)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 57.58, CGRectGetMinY(frame) + 8.8) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 58.07, CGRectGetMinY(frame) + 8.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 58.04, CGRectGetMinY(frame) + 8.67)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 57.13, CGRectGetMinY(frame) + 9.04) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 57.43, CGRectGetMinY(frame) + 8.83) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 57.28, CGRectGetMinY(frame) + 8.91)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 56.36, CGRectGetMinY(frame) + 9.95) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 56.98, CGRectGetMinY(frame) + 9.17) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 56.72, CGRectGetMinY(frame) + 9.47)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 54.83, CGRectGetMinY(frame) + 12.1) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 56, CGRectGetMinY(frame) + 10.43) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 55.49, CGRectGetMinY(frame) + 11.15)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 52.1, CGRectGetMinY(frame) + 16.07) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 54.16, CGRectGetMinY(frame) + 13.05) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 53.26, CGRectGetMinY(frame) + 14.38)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 56.88, CGRectGetMinY(frame) + 15.45)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 56.81, CGRectGetMinY(frame) + 16.77) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 56.75, CGRectGetMinY(frame) + 15.91) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 56.73, CGRectGetMinY(frame) + 16.35)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 52.37, CGRectGetMinY(frame) + 17.27)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 50.14, CGRectGetMinY(frame) + 17.82) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 51.34, CGRectGetMinY(frame) + 17.42) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 50.6, CGRectGetMinY(frame) + 17.6)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 49.63, CGRectGetMinY(frame) + 16.26) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 50.07, CGRectGetMinY(frame) + 17.25) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 49.9, CGRectGetMinY(frame) + 16.73)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 50.8, CGRectGetMinY(frame) + 15.68) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 50.08, CGRectGetMinY(frame) + 16.14) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 50.47, CGRectGetMinY(frame) + 15.94)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 51.7, CGRectGetMinY(frame) + 14.66) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 51.12, CGRectGetMinY(frame) + 15.41) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 51.42, CGRectGetMinY(frame) + 15.07)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 53.03, CGRectGetMinY(frame) + 12.64) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 52.21, CGRectGetMinY(frame) + 13.89) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 52.65, CGRectGetMinY(frame) + 13.22)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 54.05, CGRectGetMinY(frame) + 11.08) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 53.4, CGRectGetMinY(frame) + 12.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 53.74, CGRectGetMinY(frame) + 11.54)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 51.53, CGRectGetMinY(frame) + 11.25)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 60.1, CGRectGetMinY(frame) + 22.14)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 60.1, CGRectGetMinY(frame) + 24.02)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 58.44, CGRectGetMinY(frame) + 24.02)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 58.62, CGRectGetMinY(frame) + 22.13) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 58.52, CGRectGetMinY(frame) + 23.42) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 58.58, CGRectGetMinY(frame) + 22.8)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 58.68, CGRectGetMinY(frame) + 20.18) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 58.66, CGRectGetMinY(frame) + 21.47) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 58.68, CGRectGetMinY(frame) + 20.82)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 58.68, CGRectGetMinY(frame) + 17.63)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 58.67, CGRectGetMinY(frame) + 16.94) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 58.68, CGRectGetMinY(frame) + 17.42) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 58.68, CGRectGetMinY(frame) + 17.19)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 58.63, CGRectGetMinY(frame) + 16.17) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 58.66, CGRectGetMinY(frame) + 16.68) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 58.65, CGRectGetMinY(frame) + 16.42)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 58.58, CGRectGetMinY(frame) + 15.46) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 58.62, CGRectGetMinY(frame) + 15.91) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 58.6, CGRectGetMinY(frame) + 15.68)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 58.54, CGRectGetMinY(frame) + 14.92) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 58.57, CGRectGetMinY(frame) + 15.24) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 58.55, CGRectGetMinY(frame) + 15.06)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 59.4, CGRectGetMinY(frame) + 15) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 58.82, CGRectGetMinY(frame) + 14.95) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 59.11, CGRectGetMinY(frame) + 14.98)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 60.42, CGRectGetMinY(frame) + 15.05) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 59.69, CGRectGetMinY(frame) + 15.03) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 60.03, CGRectGetMinY(frame) + 15.04)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 61.84, CGRectGetMinY(frame) + 15.08) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 60.81, CGRectGetMinY(frame) + 15.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 61.28, CGRectGetMinY(frame) + 15.07)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 63.89, CGRectGetMinY(frame) + 15.09) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 62.39, CGRectGetMinY(frame) + 15.08) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 63.07, CGRectGetMinY(frame) + 15.09)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 66.01, CGRectGetMinY(frame) + 15.08) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 64.74, CGRectGetMinY(frame) + 15.09) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 65.44, CGRectGetMinY(frame) + 15.08)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 67.44, CGRectGetMinY(frame) + 15.05) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 66.58, CGRectGetMinY(frame) + 15.07) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 67.06, CGRectGetMinY(frame) + 15.06)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 68.44, CGRectGetMinY(frame) + 15) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 67.82, CGRectGetMinY(frame) + 15.04) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 68.16, CGRectGetMinY(frame) + 15.03)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 69.26, CGRectGetMinY(frame) + 14.92) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 68.72, CGRectGetMinY(frame) + 14.98) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 68.99, CGRectGetMinY(frame) + 14.95)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 69.14, CGRectGetMinY(frame) + 16.13) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 69.22, CGRectGetMinY(frame) + 15.19) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 69.18, CGRectGetMinY(frame) + 15.6)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 69.1, CGRectGetMinY(frame) + 17.63) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 69.11, CGRectGetMinY(frame) + 16.67) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 69.1, CGRectGetMinY(frame) + 17.17)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 69.1, CGRectGetMinY(frame) + 20.39)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 69.14, CGRectGetMinY(frame) + 22) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 69.1, CGRectGetMinY(frame) + 20.86) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 69.11, CGRectGetMinY(frame) + 21.39)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 69.29, CGRectGetMinY(frame) + 23.85) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 69.18, CGRectGetMinY(frame) + 22.61) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 69.22, CGRectGetMinY(frame) + 23.22)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 67.7, CGRectGetMinY(frame) + 23.85)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 67.7, CGRectGetMinY(frame) + 22.14)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 60.1, CGRectGetMinY(frame) + 22.14)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 67.7, CGRectGetMinY(frame) + 20.97)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 67.7, CGRectGetMinY(frame) + 16.24)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 60.1, CGRectGetMinY(frame) + 16.24)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 60.1, CGRectGetMinY(frame) + 20.97)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 67.7, CGRectGetMinY(frame) + 20.97)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 64.61, CGRectGetMinY(frame) + 11.34)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 67.75, CGRectGetMinY(frame) + 11.27) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 65.82, CGRectGetMinY(frame) + 11.33) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 66.87, CGRectGetMinY(frame) + 11.3)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 70.1, CGRectGetMinY(frame) + 11.1) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 68.63, CGRectGetMinY(frame) + 11.24) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 69.42, CGRectGetMinY(frame) + 11.18)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 70.1, CGRectGetMinY(frame) + 12.74)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 67.48, CGRectGetMinY(frame) + 12.56) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 69.34, CGRectGetMinY(frame) + 12.66) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 68.46, CGRectGetMinY(frame) + 12.6)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 63.89, CGRectGetMinY(frame) + 12.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 66.49, CGRectGetMinY(frame) + 12.52) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 65.3, CGRectGetMinY(frame) + 12.5)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 60.3, CGRectGetMinY(frame) + 12.56) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 62.48, CGRectGetMinY(frame) + 12.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 61.28, CGRectGetMinY(frame) + 12.52)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 57.67, CGRectGetMinY(frame) + 12.74) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 59.32, CGRectGetMinY(frame) + 12.6) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 58.44, CGRectGetMinY(frame) + 12.66)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 57.67, CGRectGetMinY(frame) + 11.1)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 60.01, CGRectGetMinY(frame) + 11.27) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 58.36, CGRectGetMinY(frame) + 11.18) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 59.14, CGRectGetMinY(frame) + 11.24)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 63.12, CGRectGetMinY(frame) + 11.34) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 60.88, CGRectGetMinY(frame) + 11.3) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 61.92, CGRectGetMinY(frame) + 11.33)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 63.12, CGRectGetMinY(frame) + 7.58)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 61.26, CGRectGetMinY(frame) + 7.6) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 62.43, CGRectGetMinY(frame) + 7.58) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 61.81, CGRectGetMinY(frame) + 7.58)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 59.74, CGRectGetMinY(frame) + 7.65) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 60.71, CGRectGetMinY(frame) + 7.62) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 60.2, CGRectGetMinY(frame) + 7.63)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 58.43, CGRectGetMinY(frame) + 7.72) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 59.27, CGRectGetMinY(frame) + 7.66) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 58.84, CGRectGetMinY(frame) + 7.69)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 57.19, CGRectGetMinY(frame) + 7.82) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 58.02, CGRectGetMinY(frame) + 7.75) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 57.61, CGRectGetMinY(frame) + 7.78)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 57.19, CGRectGetMinY(frame) + 6.16)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 58.43, CGRectGetMinY(frame) + 6.26) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 57.61, CGRectGetMinY(frame) + 6.19) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 58.02, CGRectGetMinY(frame) + 6.22)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 59.74, CGRectGetMinY(frame) + 6.33) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 58.84, CGRectGetMinY(frame) + 6.29) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 59.27, CGRectGetMinY(frame) + 6.31)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 61.26, CGRectGetMinY(frame) + 6.38) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 60.2, CGRectGetMinY(frame) + 6.34) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 60.71, CGRectGetMinY(frame) + 6.36)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 63.12, CGRectGetMinY(frame) + 6.4) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 61.81, CGRectGetMinY(frame) + 6.39) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 62.43, CGRectGetMinY(frame) + 6.4)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 63.12, CGRectGetMinY(frame) + 5.68)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 63.06, CGRectGetMinY(frame) + 3.64) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 63.12, CGRectGetMinY(frame) + 4.91) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 63.1, CGRectGetMinY(frame) + 4.23)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 62.95, CGRectGetMinY(frame) + 2.46) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 63.02, CGRectGetMinY(frame) + 3.05) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 62.98, CGRectGetMinY(frame) + 2.66)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 63.94, CGRectGetMinY(frame) + 2.6) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 63.29, CGRectGetMinY(frame) + 2.53) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 63.62, CGRectGetMinY(frame) + 2.57)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 64.82, CGRectGetMinY(frame) + 2.63) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 64.26, CGRectGetMinY(frame) + 2.62) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 64.55, CGRectGetMinY(frame) + 2.63)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 65.15, CGRectGetMinY(frame) + 2.75) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 65.02, CGRectGetMinY(frame) + 2.63) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 65.12, CGRectGetMinY(frame) + 2.67)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 64.97, CGRectGetMinY(frame) + 2.97) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 65.17, CGRectGetMinY(frame) + 2.83) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 65.11, CGRectGetMinY(frame) + 2.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 64.72, CGRectGetMinY(frame) + 3.24) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 64.87, CGRectGetMinY(frame) + 3) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 64.79, CGRectGetMinY(frame) + 3.09)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 64.61, CGRectGetMinY(frame) + 3.71) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 64.64, CGRectGetMinY(frame) + 3.4) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 64.61, CGRectGetMinY(frame) + 3.55)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 64.61, CGRectGetMinY(frame) + 6.4)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 66.58, CGRectGetMinY(frame) + 6.39) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 65.34, CGRectGetMinY(frame) + 6.4) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 66, CGRectGetMinY(frame) + 6.4)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 68.16, CGRectGetMinY(frame) + 6.34) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 67.15, CGRectGetMinY(frame) + 6.38) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 67.68, CGRectGetMinY(frame) + 6.36)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 69.5, CGRectGetMinY(frame) + 6.27) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 68.64, CGRectGetMinY(frame) + 6.32) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 69.09, CGRectGetMinY(frame) + 6.29)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 70.78, CGRectGetMinY(frame) + 6.16) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 69.92, CGRectGetMinY(frame) + 6.24) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 70.34, CGRectGetMinY(frame) + 6.21)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 70.78, CGRectGetMinY(frame) + 7.82)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 69.49, CGRectGetMinY(frame) + 7.71) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 70.34, CGRectGetMinY(frame) + 7.77) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 69.92, CGRectGetMinY(frame) + 7.73)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 68.14, CGRectGetMinY(frame) + 7.64) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 69.07, CGRectGetMinY(frame) + 7.68) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 68.62, CGRectGetMinY(frame) + 7.66)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 66.55, CGRectGetMinY(frame) + 7.59) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 67.66, CGRectGetMinY(frame) + 7.61) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 67.13, CGRectGetMinY(frame) + 7.6)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 64.61, CGRectGetMinY(frame) + 7.58) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 65.98, CGRectGetMinY(frame) + 7.58) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 65.33, CGRectGetMinY(frame) + 7.58)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 64.61, CGRectGetMinY(frame) + 11.34)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 84.77, CGRectGetMinY(frame) + 13.77)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 90.38, CGRectGetMinY(frame) + 13.77)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 90.38, CGRectGetMinY(frame) + 9.81)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 84.77, CGRectGetMinY(frame) + 9.81)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 84.77, CGRectGetMinY(frame) + 13.77)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 83.28, CGRectGetMinY(frame) + 9.81)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 77.71, CGRectGetMinY(frame) + 9.81)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 77.71, CGRectGetMinY(frame) + 13.77)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 83.28, CGRectGetMinY(frame) + 13.77)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 83.28, CGRectGetMinY(frame) + 9.81)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 82.92, CGRectGetMinY(frame) + 14.92)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 81.32, CGRectGetMinY(frame) + 17.3) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 82.42, CGRectGetMinY(frame) + 15.78) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 81.89, CGRectGetMinY(frame) + 16.58)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 79.43, CGRectGetMinY(frame) + 19.34) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 80.76, CGRectGetMinY(frame) + 18.02) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 80.12, CGRectGetMinY(frame) + 18.7)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 77.08, CGRectGetMinY(frame) + 21.2) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 78.73, CGRectGetMinY(frame) + 19.98) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 77.95, CGRectGetMinY(frame) + 20.6)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 74.14, CGRectGetMinY(frame) + 23.03) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.2, CGRectGetMinY(frame) + 21.8) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 75.22, CGRectGetMinY(frame) + 22.41)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 73.67, CGRectGetMinY(frame) + 22.26) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 74.01, CGRectGetMinY(frame) + 22.71) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 73.85, CGRectGetMinY(frame) + 22.46)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 72.82, CGRectGetMinY(frame) + 21.71) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 73.48, CGRectGetMinY(frame) + 22.07) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 73.2, CGRectGetMinY(frame) + 21.89)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 75.32, CGRectGetMinY(frame) + 20.57) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 73.63, CGRectGetMinY(frame) + 21.44) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 74.47, CGRectGetMinY(frame) + 21.06)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 77.78, CGRectGetMinY(frame) + 18.93) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.18, CGRectGetMinY(frame) + 20.08) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 77, CGRectGetMinY(frame) + 19.54)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 79.93, CGRectGetMinY(frame) + 16.98) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 78.57, CGRectGetMinY(frame) + 18.32) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 79.28, CGRectGetMinY(frame) + 17.67)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 81.53, CGRectGetMinY(frame) + 14.92) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 80.58, CGRectGetMinY(frame) + 16.3) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 81.11, CGRectGetMinY(frame) + 15.61)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 79.75, CGRectGetMinY(frame) + 14.93) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 80.86, CGRectGetMinY(frame) + 14.92) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 80.26, CGRectGetMinY(frame) + 14.92)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 78.35, CGRectGetMinY(frame) + 14.96) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 79.24, CGRectGetMinY(frame) + 14.94) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 78.77, CGRectGetMinY(frame) + 14.95)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 77.16, CGRectGetMinY(frame) + 15) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 77.92, CGRectGetMinY(frame) + 14.96) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 77.53, CGRectGetMinY(frame) + 14.98)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 76.03, CGRectGetMinY(frame) + 15.06) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.79, CGRectGetMinY(frame) + 15.03) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 76.42, CGRectGetMinY(frame) + 15.05)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 76.12, CGRectGetMinY(frame) + 14.42) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.06, CGRectGetMinY(frame) + 14.84) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 76.09, CGRectGetMinY(frame) + 14.62)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 76.16, CGRectGetMinY(frame) + 13.73) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.14, CGRectGetMinY(frame) + 14.21) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 76.16, CGRectGetMinY(frame) + 13.98)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 76.19, CGRectGetMinY(frame) + 12.87) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.17, CGRectGetMinY(frame) + 13.48) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 76.18, CGRectGetMinY(frame) + 13.2)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 76.2, CGRectGetMinY(frame) + 11.7) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.2, CGRectGetMinY(frame) + 12.54) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 76.2, CGRectGetMinY(frame) + 12.15)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 76.19, CGRectGetMinY(frame) + 10.6) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.2, CGRectGetMinY(frame) + 11.27) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 76.2, CGRectGetMinY(frame) + 10.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 76.16, CGRectGetMinY(frame) + 9.78) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.18, CGRectGetMinY(frame) + 10.3) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 76.17, CGRectGetMinY(frame) + 10.02)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 76.12, CGRectGetMinY(frame) + 9.12) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.16, CGRectGetMinY(frame) + 9.54) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 76.14, CGRectGetMinY(frame) + 9.32)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 76.03, CGRectGetMinY(frame) + 8.49) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.09, CGRectGetMinY(frame) + 8.92) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 76.06, CGRectGetMinY(frame) + 8.71)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 77.47, CGRectGetMinY(frame) + 8.58) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.5, CGRectGetMinY(frame) + 8.52) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 76.98, CGRectGetMinY(frame) + 8.55)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 79.08, CGRectGetMinY(frame) + 8.66) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 77.97, CGRectGetMinY(frame) + 8.62) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 78.5, CGRectGetMinY(frame) + 8.64)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 80.98, CGRectGetMinY(frame) + 8.69) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 79.66, CGRectGetMinY(frame) + 8.67) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 80.29, CGRectGetMinY(frame) + 8.68)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 83.28, CGRectGetMinY(frame) + 8.7) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 81.66, CGRectGetMinY(frame) + 8.7) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 82.43, CGRectGetMinY(frame) + 8.7)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 83.28, CGRectGetMinY(frame) + 6.52)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 77.9, CGRectGetMinY(frame) + 6.57) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 81.17, CGRectGetMinY(frame) + 6.52) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 79.38, CGRectGetMinY(frame) + 6.54)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 73.97, CGRectGetMinY(frame) + 6.71) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.43, CGRectGetMinY(frame) + 6.6) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 75.12, CGRectGetMinY(frame) + 6.65)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 73.97, CGRectGetMinY(frame) + 5.18)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 75.86, CGRectGetMinY(frame) + 5.27) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 74.58, CGRectGetMinY(frame) + 5.21) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 75.21, CGRectGetMinY(frame) + 5.24)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 77.96, CGRectGetMinY(frame) + 5.36) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 76.52, CGRectGetMinY(frame) + 5.3) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 77.22, CGRectGetMinY(frame) + 5.33)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 80.39, CGRectGetMinY(frame) + 5.4) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 78.71, CGRectGetMinY(frame) + 5.38) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 79.52, CGRectGetMinY(frame) + 5.4)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 83.28, CGRectGetMinY(frame) + 5.42) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 81.26, CGRectGetMinY(frame) + 5.41) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 82.22, CGRectGetMinY(frame) + 5.42)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 83.24, CGRectGetMinY(frame) + 3.62) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 83.28, CGRectGetMinY(frame) + 4.73) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 83.27, CGRectGetMinY(frame) + 4.13)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 83.11, CGRectGetMinY(frame) + 2.3) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 83.22, CGRectGetMinY(frame) + 3.1) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 83.18, CGRectGetMinY(frame) + 2.66)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 84.07, CGRectGetMinY(frame) + 2.46) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 83.45, CGRectGetMinY(frame) + 2.38) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 83.77, CGRectGetMinY(frame) + 2.43)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 84.91, CGRectGetMinY(frame) + 2.49) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 84.38, CGRectGetMinY(frame) + 2.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 84.66, CGRectGetMinY(frame) + 2.5)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 85.45, CGRectGetMinY(frame) + 2.57) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 85.23, CGRectGetMinY(frame) + 2.47) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 85.41, CGRectGetMinY(frame) + 2.5)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 85.15, CGRectGetMinY(frame) + 3.04) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 85.49, CGRectGetMinY(frame) + 2.64) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 85.39, CGRectGetMinY(frame) + 2.8)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 84.77, CGRectGetMinY(frame) + 4) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 84.9, CGRectGetMinY(frame) + 3.3) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 84.77, CGRectGetMinY(frame) + 3.62)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 84.77, CGRectGetMinY(frame) + 5.42)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 90.14, CGRectGetMinY(frame) + 5.37) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 86.88, CGRectGetMinY(frame) + 5.42) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 88.67, CGRectGetMinY(frame) + 5.4)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 94.08, CGRectGetMinY(frame) + 5.22) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 91.62, CGRectGetMinY(frame) + 5.34) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 92.93, CGRectGetMinY(frame) + 5.29)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 94.08, CGRectGetMinY(frame) + 6.71)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 90.14, CGRectGetMinY(frame) + 6.57) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 92.93, CGRectGetMinY(frame) + 6.65) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 91.62, CGRectGetMinY(frame) + 6.6)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 84.77, CGRectGetMinY(frame) + 6.52) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 88.67, CGRectGetMinY(frame) + 6.54) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 86.88, CGRectGetMinY(frame) + 6.52)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 84.77, CGRectGetMinY(frame) + 8.7)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 87.1, CGRectGetMinY(frame) + 8.69) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 85.63, CGRectGetMinY(frame) + 8.7) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 86.41, CGRectGetMinY(frame) + 8.7)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 88.99, CGRectGetMinY(frame) + 8.66) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 87.78, CGRectGetMinY(frame) + 8.68) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 88.42, CGRectGetMinY(frame) + 8.67)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 90.6, CGRectGetMinY(frame) + 8.6) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 89.57, CGRectGetMinY(frame) + 8.64) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 90.1, CGRectGetMinY(frame) + 8.62)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 92.06, CGRectGetMinY(frame) + 8.49) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 91.1, CGRectGetMinY(frame) + 8.57) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 91.58, CGRectGetMinY(frame) + 8.54)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 91.93, CGRectGetMinY(frame) + 9.86) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 92, CGRectGetMinY(frame) + 8.94) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 91.96, CGRectGetMinY(frame) + 9.39)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 91.9, CGRectGetMinY(frame) + 11.7) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 91.91, CGRectGetMinY(frame) + 10.32) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 91.9, CGRectGetMinY(frame) + 10.94)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 91.93, CGRectGetMinY(frame) + 13.64) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 91.9, CGRectGetMinY(frame) + 12.47) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 91.91, CGRectGetMinY(frame) + 13.12)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 92.06, CGRectGetMinY(frame) + 15.11) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 91.96, CGRectGetMinY(frame) + 14.16) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 92, CGRectGetMinY(frame) + 14.65)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 89.44, CGRectGetMinY(frame) + 14.97) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 91.3, CGRectGetMinY(frame) + 15.05) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 90.42, CGRectGetMinY(frame) + 15)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 86.3, CGRectGetMinY(frame) + 14.92) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 88.45, CGRectGetMinY(frame) + 14.94) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 87.41, CGRectGetMinY(frame) + 14.92)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 88.57, CGRectGetMinY(frame) + 17.22) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 87.1, CGRectGetMinY(frame) + 15.8) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 87.86, CGRectGetMinY(frame) + 16.57)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 90.7, CGRectGetMinY(frame) + 18.95) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 89.28, CGRectGetMinY(frame) + 17.88) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 89.99, CGRectGetMinY(frame) + 18.46)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 92.84, CGRectGetMinY(frame) + 20.27) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 91.4, CGRectGetMinY(frame) + 19.45) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 92.12, CGRectGetMinY(frame) + 19.89)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 95.18, CGRectGetMinY(frame) + 21.38) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 93.57, CGRectGetMinY(frame) + 20.66) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 94.35, CGRectGetMinY(frame) + 21.02)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 94.4, CGRectGetMinY(frame) + 22.01) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 94.85, CGRectGetMinY(frame) + 21.58) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 94.59, CGRectGetMinY(frame) + 21.8)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 93.94, CGRectGetMinY(frame) + 22.86) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 94.22, CGRectGetMinY(frame) + 22.23) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 94.06, CGRectGetMinY(frame) + 22.51)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 91.24, CGRectGetMinY(frame) + 21.17) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 92.96, CGRectGetMinY(frame) + 22.3) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 92.06, CGRectGetMinY(frame) + 21.74)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 88.93, CGRectGetMinY(frame) + 19.37) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 90.41, CGRectGetMinY(frame) + 20.6) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 89.64, CGRectGetMinY(frame) + 20)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 86.9, CGRectGetMinY(frame) + 17.33) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 88.22, CGRectGetMinY(frame) + 18.74) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 87.54, CGRectGetMinY(frame) + 18.06)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 85.01, CGRectGetMinY(frame) + 14.92) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 86.26, CGRectGetMinY(frame) + 16.6) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 85.63, CGRectGetMinY(frame) + 15.8)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 84.77, CGRectGetMinY(frame) + 14.92)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 84.77, CGRectGetMinY(frame) + 20.01)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 84.8, CGRectGetMinY(frame) + 22.31) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 84.77, CGRectGetMinY(frame) + 20.87) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 84.78, CGRectGetMinY(frame) + 21.64)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 84.94, CGRectGetMinY(frame) + 24.52) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 84.83, CGRectGetMinY(frame) + 22.98) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 84.87, CGRectGetMinY(frame) + 23.72)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 83.09, CGRectGetMinY(frame) + 24.52)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 83.23, CGRectGetMinY(frame) + 22.31) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 83.15, CGRectGetMinY(frame) + 23.74) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 83.2, CGRectGetMinY(frame) + 23)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 83.28, CGRectGetMinY(frame) + 20.01) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 83.26, CGRectGetMinY(frame) + 21.62) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 83.28, CGRectGetMinY(frame) + 20.86)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 83.28, CGRectGetMinY(frame) + 14.92)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 82.92, CGRectGetMinY(frame) + 14.92)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 108.17, CGRectGetMinY(frame) + 14.2)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 108.17, CGRectGetMinY(frame) + 17.94)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 110.4, CGRectGetMinY(frame) + 17.94)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 110.4, CGRectGetMinY(frame) + 14.2)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 108.17, CGRectGetMinY(frame) + 14.2)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 110.4, CGRectGetMinY(frame) + 13.05)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 110.4, CGRectGetMinY(frame) + 9.59)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 108.17, CGRectGetMinY(frame) + 9.59)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 108.17, CGRectGetMinY(frame) + 13.05)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 110.4, CGRectGetMinY(frame) + 13.05)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 111.74, CGRectGetMinY(frame) + 14.2)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 111.74, CGRectGetMinY(frame) + 17.94)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 114, CGRectGetMinY(frame) + 17.94)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 114, CGRectGetMinY(frame) + 14.2)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 111.74, CGRectGetMinY(frame) + 14.2)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 114, CGRectGetMinY(frame) + 13.05)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 114, CGRectGetMinY(frame) + 9.59)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 111.74, CGRectGetMinY(frame) + 9.59)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 111.74, CGRectGetMinY(frame) + 13.05)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 114, CGRectGetMinY(frame) + 13.05)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 110.4, CGRectGetMinY(frame) + 5.73)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 109.16, CGRectGetMinY(frame) + 5.88) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 109.94, CGRectGetMinY(frame) + 5.79) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 109.52, CGRectGetMinY(frame) + 5.84)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 108.12, CGRectGetMinY(frame) + 6) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 108.8, CGRectGetMinY(frame) + 5.92) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 108.46, CGRectGetMinY(frame) + 5.96)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 107.09, CGRectGetMinY(frame) + 6.11) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 107.78, CGRectGetMinY(frame) + 6.04) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 107.44, CGRectGetMinY(frame) + 6.08)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 105.89, CGRectGetMinY(frame) + 6.21) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 106.74, CGRectGetMinY(frame) + 6.14) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 106.34, CGRectGetMinY(frame) + 6.18)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 105.61, CGRectGetMinY(frame) + 5.38) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 105.81, CGRectGetMinY(frame) + 5.89) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 105.72, CGRectGetMinY(frame) + 5.61)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 105.19, CGRectGetMinY(frame) + 4.7) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 105.51, CGRectGetMinY(frame) + 5.15) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 105.37, CGRectGetMinY(frame) + 4.92)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 110.53, CGRectGetMinY(frame) + 4.42) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 107.1, CGRectGetMinY(frame) + 4.73) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 108.88, CGRectGetMinY(frame) + 4.64)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 115.54, CGRectGetMinY(frame) + 3.47) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 112.19, CGRectGetMinY(frame) + 4.2) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 113.86, CGRectGetMinY(frame) + 3.89)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 116.4, CGRectGetMinY(frame) + 4.94) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 115.78, CGRectGetMinY(frame) + 4.13) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 116.06, CGRectGetMinY(frame) + 4.62)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 116.53, CGRectGetMinY(frame) + 5.31) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 116.56, CGRectGetMinY(frame) + 5.08) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 116.6, CGRectGetMinY(frame) + 5.2)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 116.14, CGRectGetMinY(frame) + 5.34) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 116.46, CGRectGetMinY(frame) + 5.41) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 116.33, CGRectGetMinY(frame) + 5.42)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 115.02, CGRectGetMinY(frame) + 5.2) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 115.86, CGRectGetMinY(frame) + 5.25) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 115.49, CGRectGetMinY(frame) + 5.2)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 113.02, CGRectGetMinY(frame) + 5.39) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 114.55, CGRectGetMinY(frame) + 5.2) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 113.88, CGRectGetMinY(frame) + 5.26)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 112.36, CGRectGetMinY(frame) + 5.48) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 112.79, CGRectGetMinY(frame) + 5.42) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 112.57, CGRectGetMinY(frame) + 5.45)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 111.74, CGRectGetMinY(frame) + 5.56) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 112.14, CGRectGetMinY(frame) + 5.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 111.94, CGRectGetMinY(frame) + 5.53)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 111.74, CGRectGetMinY(frame) + 8.49)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 114.38, CGRectGetMinY(frame) + 8.49)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 115.92, CGRectGetMinY(frame) + 8.43) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 114.9, CGRectGetMinY(frame) + 8.49) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 115.41, CGRectGetMinY(frame) + 8.47)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 117.53, CGRectGetMinY(frame) + 8.25) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 116.43, CGRectGetMinY(frame) + 8.39) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 116.97, CGRectGetMinY(frame) + 8.33)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 117.53, CGRectGetMinY(frame) + 9.78)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 116.38, CGRectGetMinY(frame) + 9.65) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 117.11, CGRectGetMinY(frame) + 9.72) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 116.73, CGRectGetMinY(frame) + 9.68)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 115.27, CGRectGetMinY(frame) + 9.62) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 116.02, CGRectGetMinY(frame) + 9.63) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 115.66, CGRectGetMinY(frame) + 9.62)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 115.27, CGRectGetMinY(frame) + 13.05)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 116.88, CGRectGetMinY(frame) + 12.99) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 115.88, CGRectGetMinY(frame) + 13.05) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 116.42, CGRectGetMinY(frame) + 13.03)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 118.34, CGRectGetMinY(frame) + 12.81) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 117.34, CGRectGetMinY(frame) + 12.95) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 117.83, CGRectGetMinY(frame) + 12.89)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 118.34, CGRectGetMinY(frame) + 14.39)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 116.89, CGRectGetMinY(frame) + 14.24) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 117.83, CGRectGetMinY(frame) + 14.31) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 117.35, CGRectGetMinY(frame) + 14.26)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 115.27, CGRectGetMinY(frame) + 14.2) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 116.44, CGRectGetMinY(frame) + 14.21) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 115.9, CGRectGetMinY(frame) + 14.2)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 115.27, CGRectGetMinY(frame) + 17.94)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 116.48, CGRectGetMinY(frame) + 17.86) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 115.67, CGRectGetMinY(frame) + 17.93) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 116.08, CGRectGetMinY(frame) + 17.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 117.77, CGRectGetMinY(frame) + 17.7) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 116.89, CGRectGetMinY(frame) + 17.82) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 117.32, CGRectGetMinY(frame) + 17.77)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 117.77, CGRectGetMinY(frame) + 19.24)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 116.17, CGRectGetMinY(frame) + 19.08) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 117.21, CGRectGetMinY(frame) + 19.16) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 116.68, CGRectGetMinY(frame) + 19.11)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 114.62, CGRectGetMinY(frame) + 19.05) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 115.67, CGRectGetMinY(frame) + 19.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 115.15, CGRectGetMinY(frame) + 19.05)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 111.74, CGRectGetMinY(frame) + 19.05)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 111.74, CGRectGetMinY(frame) + 21.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 113.11, CGRectGetMinY(frame) + 21.89) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 112.26, CGRectGetMinY(frame) + 21.9) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 112.71, CGRectGetMinY(frame) + 21.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 114.28, CGRectGetMinY(frame) + 21.86) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 113.51, CGRectGetMinY(frame) + 21.88) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 113.9, CGRectGetMinY(frame) + 21.87)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 115.42, CGRectGetMinY(frame) + 21.78) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 114.65, CGRectGetMinY(frame) + 21.84) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 115.03, CGRectGetMinY(frame) + 21.82)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 116.71, CGRectGetMinY(frame) + 21.66) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 115.8, CGRectGetMinY(frame) + 21.75) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 116.23, CGRectGetMinY(frame) + 21.71)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 116.71, CGRectGetMinY(frame) + 23.18)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 115.32, CGRectGetMinY(frame) + 23.07) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 116.2, CGRectGetMinY(frame) + 23.13) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 115.74, CGRectGetMinY(frame) + 23.09)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 114.05, CGRectGetMinY(frame) + 23.02) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 114.9, CGRectGetMinY(frame) + 23.04) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 114.48, CGRectGetMinY(frame) + 23.03)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 112.66, CGRectGetMinY(frame) + 23) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 113.62, CGRectGetMinY(frame) + 23.01) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 113.15, CGRectGetMinY(frame) + 23)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 110.9, CGRectGetMinY(frame) + 22.98) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 112.16, CGRectGetMinY(frame) + 22.99) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 111.58, CGRectGetMinY(frame) + 22.98)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 109.31, CGRectGetMinY(frame) + 23) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 110.3, CGRectGetMinY(frame) + 22.98) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 109.76, CGRectGetMinY(frame) + 22.99)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 108.02, CGRectGetMinY(frame) + 23.02) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 108.85, CGRectGetMinY(frame) + 23) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 108.42, CGRectGetMinY(frame) + 23.01)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 106.81, CGRectGetMinY(frame) + 23.07) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 107.62, CGRectGetMinY(frame) + 23.03) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 107.22, CGRectGetMinY(frame) + 23.04)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 105.41, CGRectGetMinY(frame) + 23.18) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 106.4, CGRectGetMinY(frame) + 23.09) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 105.94, CGRectGetMinY(frame) + 23.13)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 105.41, CGRectGetMinY(frame) + 21.66)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 106.73, CGRectGetMinY(frame) + 21.78) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 105.9, CGRectGetMinY(frame) + 21.71) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 106.34, CGRectGetMinY(frame) + 21.75)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 107.87, CGRectGetMinY(frame) + 21.86) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 107.11, CGRectGetMinY(frame) + 21.82) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 107.49, CGRectGetMinY(frame) + 21.84)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 109.02, CGRectGetMinY(frame) + 21.89) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 108.24, CGRectGetMinY(frame) + 21.87) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 108.63, CGRectGetMinY(frame) + 21.88)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 110.4, CGRectGetMinY(frame) + 21.9) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 109.41, CGRectGetMinY(frame) + 21.9) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 109.87, CGRectGetMinY(frame) + 21.9)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 110.4, CGRectGetMinY(frame) + 19.05)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 107.83, CGRectGetMinY(frame) + 19.05)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 106.08, CGRectGetMinY(frame) + 19.08) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 107.16, CGRectGetMinY(frame) + 19.05) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 106.58, CGRectGetMinY(frame) + 19.06)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 104.5, CGRectGetMinY(frame) + 19.24) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 105.58, CGRectGetMinY(frame) + 19.11) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 105.06, CGRectGetMinY(frame) + 19.16)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 104.5, CGRectGetMinY(frame) + 17.7)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 105.68, CGRectGetMinY(frame) + 17.87) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 104.91, CGRectGetMinY(frame) + 17.78) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 105.31, CGRectGetMinY(frame) + 17.84)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 106.9, CGRectGetMinY(frame) + 17.92) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 106.06, CGRectGetMinY(frame) + 17.9) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 106.46, CGRectGetMinY(frame) + 17.92)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 106.9, CGRectGetMinY(frame) + 14.22)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 105.46, CGRectGetMinY(frame) + 14.28) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 106.38, CGRectGetMinY(frame) + 14.24) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 105.9, CGRectGetMinY(frame) + 14.26)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 104.16, CGRectGetMinY(frame) + 14.39) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 105.01, CGRectGetMinY(frame) + 14.31) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 104.58, CGRectGetMinY(frame) + 14.34)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 104.16, CGRectGetMinY(frame) + 12.81)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 106.9, CGRectGetMinY(frame) + 13.02) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 104.99, CGRectGetMinY(frame) + 12.95) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 105.9, CGRectGetMinY(frame) + 13.02)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 106.9, CGRectGetMinY(frame) + 9.62)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 105.77, CGRectGetMinY(frame) + 9.65) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 106.53, CGRectGetMinY(frame) + 9.62) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 106.15, CGRectGetMinY(frame) + 9.63)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 104.62, CGRectGetMinY(frame) + 9.78) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 105.38, CGRectGetMinY(frame) + 9.68) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 105, CGRectGetMinY(frame) + 9.72)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 104.62, CGRectGetMinY(frame) + 8.25)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 106.19, CGRectGetMinY(frame) + 8.43) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 105.18, CGRectGetMinY(frame) + 8.33) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 105.7, CGRectGetMinY(frame) + 8.39)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 108, CGRectGetMinY(frame) + 8.49) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 106.68, CGRectGetMinY(frame) + 8.47) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 107.28, CGRectGetMinY(frame) + 8.49)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 110.4, CGRectGetMinY(frame) + 8.49)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 110.4, CGRectGetMinY(frame) + 5.73)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 99.17, CGRectGetMinY(frame) + 23.3)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 97.66, CGRectGetMinY(frame) + 23.3)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 97.79, CGRectGetMinY(frame) + 21.72) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 97.72, CGRectGetMinY(frame) + 22.78) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 97.76, CGRectGetMinY(frame) + 22.26)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 97.82, CGRectGetMinY(frame) + 20.03) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 97.81, CGRectGetMinY(frame) + 21.19) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 97.82, CGRectGetMinY(frame) + 20.62)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 97.82, CGRectGetMinY(frame) + 8.25)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 97.68, CGRectGetMinY(frame) + 4.77) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 97.82, CGRectGetMinY(frame) + 6.68) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 97.78, CGRectGetMinY(frame) + 5.52)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 98.76, CGRectGetMinY(frame) + 4.94) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 97.95, CGRectGetMinY(frame) + 4.85) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 98.31, CGRectGetMinY(frame) + 4.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 100.7, CGRectGetMinY(frame) + 4.98) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 99.21, CGRectGetMinY(frame) + 4.97) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 99.86, CGRectGetMinY(frame) + 4.98)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 102.64, CGRectGetMinY(frame) + 4.94) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 101.54, CGRectGetMinY(frame) + 4.98) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 102.18, CGRectGetMinY(frame) + 4.97)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 103.73, CGRectGetMinY(frame) + 4.77) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 103.09, CGRectGetMinY(frame) + 4.9) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 103.46, CGRectGetMinY(frame) + 4.85)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 103.67, CGRectGetMinY(frame) + 5.32) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 103.7, CGRectGetMinY(frame) + 4.96) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 103.68, CGRectGetMinY(frame) + 5.14)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 103.63, CGRectGetMinY(frame) + 5.96) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 103.66, CGRectGetMinY(frame) + 5.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 103.65, CGRectGetMinY(frame) + 5.71)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 103.61, CGRectGetMinY(frame) + 6.87) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 103.62, CGRectGetMinY(frame) + 6.2) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 103.61, CGRectGetMinY(frame) + 6.51)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 103.61, CGRectGetMinY(frame) + 8.25) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 103.61, CGRectGetMinY(frame) + 7.23) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 103.61, CGRectGetMinY(frame) + 7.69)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 103.61, CGRectGetMinY(frame) + 19.5)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 103.75, CGRectGetMinY(frame) + 22.79) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 103.61, CGRectGetMinY(frame) + 20.64) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 103.66, CGRectGetMinY(frame) + 21.74)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 102.29, CGRectGetMinY(frame) + 22.79)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 102.29, CGRectGetMinY(frame) + 20.85)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 99.17, CGRectGetMinY(frame) + 20.85)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 99.17, CGRectGetMinY(frame) + 23.3)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 99.17, CGRectGetMinY(frame) + 19.72)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 102.29, CGRectGetMinY(frame) + 19.72)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 102.29, CGRectGetMinY(frame) + 16)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 99.17, CGRectGetMinY(frame) + 16)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 99.17, CGRectGetMinY(frame) + 19.72)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 99.17, CGRectGetMinY(frame) + 11.1)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 99.17, CGRectGetMinY(frame) + 14.9)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 102.29, CGRectGetMinY(frame) + 14.9)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 102.29, CGRectGetMinY(frame) + 11.1)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 99.17, CGRectGetMinY(frame) + 11.1)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 102.29, CGRectGetMinY(frame) + 10)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 102.29, CGRectGetMinY(frame) + 6.16)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 99.17, CGRectGetMinY(frame) + 6.16)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 99.17, CGRectGetMinY(frame) + 10)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 102.29, CGRectGetMinY(frame) + 10)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 138.96, CGRectGetMinY(frame) + 9.26)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 138.96, CGRectGetMinY(frame) + 5.32)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 131.28, CGRectGetMinY(frame) + 5.32)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 131.28, CGRectGetMinY(frame) + 9.26)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 138.96, CGRectGetMinY(frame) + 9.26)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 136.75, CGRectGetMinY(frame) + 13.98)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 139.76, CGRectGetMinY(frame) + 13.95) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 137.92, CGRectGetMinY(frame) + 13.98) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 138.92, CGRectGetMinY(frame) + 13.97)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 142.08, CGRectGetMinY(frame) + 13.84) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 140.6, CGRectGetMinY(frame) + 13.92) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 141.38, CGRectGetMinY(frame) + 13.89)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 142.08, CGRectGetMinY(frame) + 15.3)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 139.82, CGRectGetMinY(frame) + 15.2) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 141.39, CGRectGetMinY(frame) + 15.26) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 140.64, CGRectGetMinY(frame) + 15.22)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 136.92, CGRectGetMinY(frame) + 15.16) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 139.01, CGRectGetMinY(frame) + 15.17) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 138.04, CGRectGetMinY(frame) + 15.16)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 137.12, CGRectGetMinY(frame) + 16.35) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 136.98, CGRectGetMinY(frame) + 15.58) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 137.05, CGRectGetMinY(frame) + 15.97)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 137.38, CGRectGetMinY(frame) + 17.44) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 137.2, CGRectGetMinY(frame) + 16.72) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 137.28, CGRectGetMinY(frame) + 17.09)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 138.3, CGRectGetMinY(frame) + 20.02) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 137.66, CGRectGetMinY(frame) + 18.51) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 137.97, CGRectGetMinY(frame) + 19.37)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 139.22, CGRectGetMinY(frame) + 21.4) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 138.63, CGRectGetMinY(frame) + 20.67) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 138.94, CGRectGetMinY(frame) + 21.13)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 140.09, CGRectGetMinY(frame) + 22.14) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 139.58, CGRectGetMinY(frame) + 21.74) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 139.86, CGRectGetMinY(frame) + 21.98)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 140.6, CGRectGetMinY(frame) + 22.29) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 140.31, CGRectGetMinY(frame) + 22.3) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 140.48, CGRectGetMinY(frame) + 22.35)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 140.84, CGRectGetMinY(frame) + 21.72) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 140.72, CGRectGetMinY(frame) + 22.22) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 140.8, CGRectGetMinY(frame) + 22.04)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 140.9, CGRectGetMinY(frame) + 20.39) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 140.88, CGRectGetMinY(frame) + 21.41) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 140.9, CGRectGetMinY(frame) + 20.97)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 141.59, CGRectGetMinY(frame) + 20.92) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 141.11, CGRectGetMinY(frame) + 20.65) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 141.34, CGRectGetMinY(frame) + 20.82)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 142.42, CGRectGetMinY(frame) + 21.02) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 141.84, CGRectGetMinY(frame) + 21.02) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 142.11, CGRectGetMinY(frame) + 21.05)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 142, CGRectGetMinY(frame) + 23.01) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 142.29, CGRectGetMinY(frame) + 21.88) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 142.15, CGRectGetMinY(frame) + 22.54)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 141.47, CGRectGetMinY(frame) + 23.97) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 141.84, CGRectGetMinY(frame) + 23.47) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 141.67, CGRectGetMinY(frame) + 23.79)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 140.76, CGRectGetMinY(frame) + 24.12) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 141.27, CGRectGetMinY(frame) + 24.14) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 141.03, CGRectGetMinY(frame) + 24.2)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 139.78, CGRectGetMinY(frame) + 23.68) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 140.49, CGRectGetMinY(frame) + 24.05) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 140.16, CGRectGetMinY(frame) + 23.9)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 138.47, CGRectGetMinY(frame) + 22.6) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 139.28, CGRectGetMinY(frame) + 23.39) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 138.84, CGRectGetMinY(frame) + 23.03)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 137.45, CGRectGetMinY(frame) + 21.15) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 138.09, CGRectGetMinY(frame) + 22.17) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 137.75, CGRectGetMinY(frame) + 21.68)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 136.64, CGRectGetMinY(frame) + 19.4) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 137.14, CGRectGetMinY(frame) + 20.61) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 136.88, CGRectGetMinY(frame) + 20.03)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 135.98, CGRectGetMinY(frame) + 17.39) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 136.41, CGRectGetMinY(frame) + 18.76) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 136.19, CGRectGetMinY(frame) + 18.1)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 135.58, CGRectGetMinY(frame) + 15.16) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 135.84, CGRectGetMinY(frame) + 16.88) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 135.7, CGRectGetMinY(frame) + 16.14)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 131.28, CGRectGetMinY(frame) + 15.16)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 131.28, CGRectGetMinY(frame) + 21.86)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 132.98, CGRectGetMinY(frame) + 20.64) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 131.87, CGRectGetMinY(frame) + 21.47) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 132.44, CGRectGetMinY(frame) + 21.07)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 134.5, CGRectGetMinY(frame) + 19.38) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 133.53, CGRectGetMinY(frame) + 20.22) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 134.03, CGRectGetMinY(frame) + 19.8)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 135.05, CGRectGetMinY(frame) + 20.73) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 134.59, CGRectGetMinY(frame) + 19.86) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 134.78, CGRectGetMinY(frame) + 20.31)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 131.71, CGRectGetMinY(frame) + 23.08)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 130.87, CGRectGetMinY(frame) + 23.72) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 131.39, CGRectGetMinY(frame) + 23.3) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 131.11, CGRectGetMinY(frame) + 23.52)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 130.15, CGRectGetMinY(frame) + 24.38) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 130.63, CGRectGetMinY(frame) + 23.92) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 130.39, CGRectGetMinY(frame) + 24.14)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 129.61, CGRectGetMinY(frame) + 23.63) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 130.01, CGRectGetMinY(frame) + 24.1) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 129.83, CGRectGetMinY(frame) + 23.86)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 128.93, CGRectGetMinY(frame) + 23.13) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 129.4, CGRectGetMinY(frame) + 23.41) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 129.17, CGRectGetMinY(frame) + 23.24)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 129.35, CGRectGetMinY(frame) + 22.72) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 129.09, CGRectGetMinY(frame) + 23.02) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 129.23, CGRectGetMinY(frame) + 22.88)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 129.66, CGRectGetMinY(frame) + 22.11) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 129.47, CGRectGetMinY(frame) + 22.56) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 129.57, CGRectGetMinY(frame) + 22.36)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 129.85, CGRectGetMinY(frame) + 21.18) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 129.75, CGRectGetMinY(frame) + 21.86) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 129.81, CGRectGetMinY(frame) + 21.55)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 129.91, CGRectGetMinY(frame) + 19.84) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 129.89, CGRectGetMinY(frame) + 20.82) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 129.91, CGRectGetMinY(frame) + 20.37)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 129.91, CGRectGetMinY(frame) + 6.57)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 129.91, CGRectGetMinY(frame) + 5.74) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 129.91, CGRectGetMinY(frame) + 6.25) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 129.91, CGRectGetMinY(frame) + 5.97)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 129.89, CGRectGetMinY(frame) + 5.09) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 129.91, CGRectGetMinY(frame) + 5.51) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 129.9, CGRectGetMinY(frame) + 5.29)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 129.84, CGRectGetMinY(frame) + 4.52) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 129.87, CGRectGetMinY(frame) + 4.89) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 129.86, CGRectGetMinY(frame) + 4.7)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 129.79, CGRectGetMinY(frame) + 3.93) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 129.82, CGRectGetMinY(frame) + 4.33) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 129.81, CGRectGetMinY(frame) + 4.14)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 130.51, CGRectGetMinY(frame) + 4.02) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 130, CGRectGetMinY(frame) + 3.96) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 130.24, CGRectGetMinY(frame) + 3.99)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 131.56, CGRectGetMinY(frame) + 4.1) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 130.78, CGRectGetMinY(frame) + 4.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 131.13, CGRectGetMinY(frame) + 4.08)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 133.12, CGRectGetMinY(frame) + 4.13) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 131.98, CGRectGetMinY(frame) + 4.11) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 132.5, CGRectGetMinY(frame) + 4.12)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 135.38, CGRectGetMinY(frame) + 4.14) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 133.73, CGRectGetMinY(frame) + 4.14) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 134.49, CGRectGetMinY(frame) + 4.14)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 137.35, CGRectGetMinY(frame) + 4.13) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 136.15, CGRectGetMinY(frame) + 4.14) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 136.81, CGRectGetMinY(frame) + 4.14)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 138.74, CGRectGetMinY(frame) + 4.1) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 137.9, CGRectGetMinY(frame) + 4.12) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 138.36, CGRectGetMinY(frame) + 4.11)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 139.72, CGRectGetMinY(frame) + 4.02) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 139.13, CGRectGetMinY(frame) + 4.08) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 139.45, CGRectGetMinY(frame) + 4.06)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 140.4, CGRectGetMinY(frame) + 3.93) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 139.98, CGRectGetMinY(frame) + 3.99) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 140.21, CGRectGetMinY(frame) + 3.96)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 140.32, CGRectGetMinY(frame) + 5.28) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 140.37, CGRectGetMinY(frame) + 4.33) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 140.34, CGRectGetMinY(frame) + 4.78)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 140.28, CGRectGetMinY(frame) + 6.64) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 140.29, CGRectGetMinY(frame) + 5.79) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 140.28, CGRectGetMinY(frame) + 6.24)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 140.28, CGRectGetMinY(frame) + 8.42)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 140.42, CGRectGetMinY(frame) + 10.58) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 140.28, CGRectGetMinY(frame) + 9.02) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 140.33, CGRectGetMinY(frame) + 9.74)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 139.86, CGRectGetMinY(frame) + 10.49) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 140.25, CGRectGetMinY(frame) + 10.54) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 140.06, CGRectGetMinY(frame) + 10.52)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 139.13, CGRectGetMinY(frame) + 10.44) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 139.66, CGRectGetMinY(frame) + 10.47) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 139.42, CGRectGetMinY(frame) + 10.45)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 138.07, CGRectGetMinY(frame) + 10.42) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 138.84, CGRectGetMinY(frame) + 10.44) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 138.49, CGRectGetMinY(frame) + 10.43)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 136.56, CGRectGetMinY(frame) + 10.41) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 137.66, CGRectGetMinY(frame) + 10.41) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 137.15, CGRectGetMinY(frame) + 10.41)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 136.61, CGRectGetMinY(frame) + 12.28) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 136.56, CGRectGetMinY(frame) + 11.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 136.58, CGRectGetMinY(frame) + 11.69)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 136.75, CGRectGetMinY(frame) + 13.98) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 136.64, CGRectGetMinY(frame) + 12.87) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 136.69, CGRectGetMinY(frame) + 13.44)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 135.43, CGRectGetMinY(frame) + 13.98)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 135.25, CGRectGetMinY(frame) + 12.21) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 135.35, CGRectGetMinY(frame) + 13.41) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 135.29, CGRectGetMinY(frame) + 12.82)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 135.17, CGRectGetMinY(frame) + 10.41) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 135.21, CGRectGetMinY(frame) + 11.6) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 135.18, CGRectGetMinY(frame) + 11)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 131.28, CGRectGetMinY(frame) + 10.41)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 131.28, CGRectGetMinY(frame) + 13.98)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 135.43, CGRectGetMinY(frame) + 13.98)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 123.12, CGRectGetMinY(frame) + 22.14)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 121.56, CGRectGetMinY(frame) + 22.14)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 121.69, CGRectGetMinY(frame) + 20.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 121.62, CGRectGetMinY(frame) + 21.54) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 121.67, CGRectGetMinY(frame) + 20.99)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 121.73, CGRectGetMinY(frame) + 18.88) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 121.72, CGRectGetMinY(frame) + 20.01) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 121.73, CGRectGetMinY(frame) + 19.47)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 121.73, CGRectGetMinY(frame) + 7.36)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 121.69, CGRectGetMinY(frame) + 5.24) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 121.73, CGRectGetMinY(frame) + 6.48) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 121.72, CGRectGetMinY(frame) + 5.77)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 121.58, CGRectGetMinY(frame) + 3.88) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 121.67, CGRectGetMinY(frame) + 4.7) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 121.63, CGRectGetMinY(frame) + 4.25)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 124.9, CGRectGetMinY(frame) + 4.1) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 122.13, CGRectGetMinY(frame) + 4.02) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 123.23, CGRectGetMinY(frame) + 4.1)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 126.94, CGRectGetMinY(frame) + 4.05) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 125.73, CGRectGetMinY(frame) + 4.1) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 126.41, CGRectGetMinY(frame) + 4.08)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 128.14, CGRectGetMinY(frame) + 3.88) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 127.46, CGRectGetMinY(frame) + 4.02) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 127.86, CGRectGetMinY(frame) + 3.96)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 128.08, CGRectGetMinY(frame) + 4.42) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 128.1, CGRectGetMinY(frame) + 4.07) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 128.08, CGRectGetMinY(frame) + 4.25)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 128.04, CGRectGetMinY(frame) + 5.04) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 128.07, CGRectGetMinY(frame) + 4.59) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 128.06, CGRectGetMinY(frame) + 4.8)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 128.02, CGRectGetMinY(frame) + 5.97) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 128.02, CGRectGetMinY(frame) + 5.29) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 128.02, CGRectGetMinY(frame) + 5.6)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 128.02, CGRectGetMinY(frame) + 7.36) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 128.02, CGRectGetMinY(frame) + 6.34) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 128.02, CGRectGetMinY(frame) + 6.8)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 128.02, CGRectGetMinY(frame) + 18.45)];
    [textPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 128.16, CGRectGetMinY(frame) + 21.74) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 128.02, CGRectGetMinY(frame) + 19.58) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 128.06, CGRectGetMinY(frame) + 20.68)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 126.7, CGRectGetMinY(frame) + 21.74)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 126.7, CGRectGetMinY(frame) + 19.91)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 123.12, CGRectGetMinY(frame) + 19.91)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 123.12, CGRectGetMinY(frame) + 22.14)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 123.12, CGRectGetMinY(frame) + 18.78)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 126.7, CGRectGetMinY(frame) + 18.78)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 126.7, CGRectGetMinY(frame) + 15.06)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 123.12, CGRectGetMinY(frame) + 15.06)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 123.12, CGRectGetMinY(frame) + 18.78)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 123.12, CGRectGetMinY(frame) + 10.14)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 123.12, CGRectGetMinY(frame) + 13.98)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 126.7, CGRectGetMinY(frame) + 13.98)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 126.7, CGRectGetMinY(frame) + 10.14)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 123.12, CGRectGetMinY(frame) + 10.14)];
    [textPath closePath];
    [textPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 126.7, CGRectGetMinY(frame) + 9.14)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 126.7, CGRectGetMinY(frame) + 5.27)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 123.12, CGRectGetMinY(frame) + 5.27)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 123.12, CGRectGetMinY(frame) + 9.14)];
    [textPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 126.7, CGRectGetMinY(frame) + 9.14)];
    [textPath closePath];
    pc = textPath;
    return textPath;
}
@end
