//
//  LxSlideControl.h
//  DemoCollect
//
//  Created by lixin on 3/18/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxSlideControl : UIControl

@property (nonatomic, strong) UIImage *thumbImg;
@property (nonatomic, strong) UIImage *trackImg;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isAnimateLabel;

- (void)setup;
@end
