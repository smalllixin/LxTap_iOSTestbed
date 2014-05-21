//
//  RoundCornerView.h
//  DemoCollect
//
//  Created by lixin on 3/18/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundCornerView : UIView

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) float cornerRadius;
@property (nonatomic, assign) BOOL tl;//top left
@property (nonatomic, assign) BOOL tr;//top right
@property (nonatomic, assign) BOOL bl;//bottom left
@property (nonatomic, assign) BOOL br;//bottom right

- (void)setRoundCornerWithTl:(BOOL)tl tr:(BOOL)tr bl:(BOOL)bl br:(BOOL)br;
@end
