//
//  Page1ViewController.h
//  DemoCollect
//
//  Created by lixin on 3/31/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bolts.h"
@protocol ScrollPageTask<NSObject>
- (BFTask*)loadingTask;
@end
@interface Page1ViewController : UIViewController<ScrollPageTask>

- (BFTask*)loadingTask;
@end
