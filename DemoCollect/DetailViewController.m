//
//  DetailViewController.m
//  DemoCollect
//
//  Created by lixin on 3/18/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "DetailViewController.h"
#import "LxUI.h"

@interface DetailViewController ()
{
    UILabel *topAlignLabel;
    UILabel *bottomAlignLabel;
}
- (void)configureView;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redViewHeightConstraint;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self configureView];
//    [LxUI poRect:self.testLabel.frame];
//    self.testLabel.frame = CGRectZero;
//    [LxUI poRect:self.testLabel.frame];
    self.testLabel.text = @"没有什么能够阻挡，你对自由的向往，天马星空的生涯";
//    [LxUI poRect:self.testLabel.frame];
//    [LxUI autoJustLabelFrame:self.testLabel];
//    UILabel *label1 = self.detailDescriptionLabel;
//    NSArray *c = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[label1]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(label1)];
//    [self.view addConstraints:c];
//    c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label1(>=50)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(label1)];
//    [self.view addConstraints:c];
//    UIView *red = self.redView;
//    [self.view removeConstraints:red.constraints];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[red]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(red)]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[red(20)]-50-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(red)]];

    self.redViewHeightConstraint.constant = 200;
    id topGuide;
    NSString *topGuideStr;
    id bottomGuide;
    NSString *bottomGuideStr;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        topGuide = self.topLayoutGuide;
        topGuideStr = @"[topGuide]";
        bottomGuide = self.bottomLayoutGuide;
        bottomGuideStr = @"[bottomGuide]";
    } else {
        topGuide = self.view;
        bottomGuide = self.view;
        topGuideStr = @"|";
        bottomGuideStr = @"|";
    }
    float padding = 10.0f;
    NSDictionary *metrics = @{@"padding":@(padding)};
    topAlignLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    topAlignLabel.text = @"I am align the top, blah blah blah blah blah123 blah blah blah blah blah123";
    topAlignLabel.textColor = [UIColor whiteColor];
    topAlignLabel.backgroundColor = [UIColor blueColor];
    topAlignLabel.numberOfLines = 0;
    topAlignLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [topAlignLabel setPreferredMaxLayoutWidth:320-padding*2];
    [topAlignLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:topAlignLabel];
    NSString *vf = [NSString stringWithFormat:@"V:%@[topAlignLabel(>=21)]", topGuideStr];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vf
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(topAlignLabel,topGuide)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[topAlignLabel]-padding-|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics
                                                                        views:NSDictionaryOfVariableBindings(topAlignLabel)]];
    [topAlignLabel layoutIfNeeded];
    bottomAlignLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bottomAlignLabel.text = @"I am align the bottom, blah blah blah blah blah123";
    bottomAlignLabel.textColor = [UIColor whiteColor];
    bottomAlignLabel.lineBreakMode = NSLineBreakByWordWrapping;
    bottomAlignLabel.numberOfLines = 0;
    bottomAlignLabel.backgroundColor = [UIColor blueColor];
    bottomAlignLabel.preferredMaxLayoutWidth = 200;
    [bottomAlignLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.view addSubview:bottomAlignLabel];
    vf = [NSString stringWithFormat:@"V:[bottomAlignLabel(>=30)]-10-%@", bottomGuideStr];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vf
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(bottomAlignLabel,bottomGuide)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bottomAlignLabel(200)]->=0-|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(bottomAlignLabel)]];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    [LxUI poRect:self.testLabel.frame];
//    [LxUI autoJustLabelFrame:self.testLabel];
    [LxUI poRect:topAlignLabel.frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
