//
//  RoundCornerView.m
//  DemoCollect
//
//  Created by lixin on 3/18/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "RoundCornerView.h"
@interface RoundCornerView()
{
    UIRectCorner corner;
}
@end
@implementation RoundCornerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
    self.fillColor = backgroundColor;
}

- (void)setRoundCornerWithTl:(BOOL)tl tr:(BOOL)tr bl:(BOOL)bl br:(BOOL)br
{
    corner = 0;//clear
    if (tl) {
        corner = UIRectCornerTopLeft;
    }
    if (tr) {
        corner |= UIRectCornerTopRight;
    }
    if (bl) {
        corner |= UIRectCornerBottomLeft;
    }
    if (br) {
        corner |= UIRectCornerBottomRight;
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Frames
    CGRect frame = rect;
    
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corner cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
    [_fillColor setFill];
    [roundedRectanglePath fill];
//    [[UIColor blackColor] setStroke];
//    roundedRectanglePath.lineWidth = 1;
//    [roundedRectanglePath stroke];
}


@end
