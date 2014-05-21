//
//  DetailViewController.h
//  DemoCollect
//
//  Created by lixin on 3/18/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
