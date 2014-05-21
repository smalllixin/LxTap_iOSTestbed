//
//  LedTestViewController.m
//  DemoCollect
//
//  Created by lixin on 4/28/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "LedTestViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LedTestViewController ()
{
    AVCaptureSession *session;
}
@property (weak, nonatomic) IBOutlet UISlider *torchLevelSlider;
@end

@implementation LedTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _torchLevelSlider.maximumValue = 0.99f;
    _torchLevelSlider.minimumValue = 0.01f;
    [_torchLevelSlider setContinuous:YES];
    [_torchLevelSlider addTarget:self action:@selector(sliderValChange:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self releaseTorch];
}
- (IBAction)ledPress:(id)sender {
    [self lightButtonPressed];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initialiseTorch {
    
    if (!session) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        session = [[AVCaptureSession alloc] init];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error: nil];
        [session addInput:input];
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        [session addOutput:output];
        [session startRunning];
    }
}

- (void)releaseTorch {
    if (session) {
        [session stopRunning];
        session = nil;
    }
}

- (void)sliderValChange:(UISlider*)slider
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchModeOnWithLevel:slider.value error:NULL];
    [device unlockForConfiguration];
}

- (void)lightButtonPressed {
    if (!session) {
        [self initialiseTorch];
    }
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [session beginConfiguration];
    [device lockForConfiguration:nil];
    if ([device torchMode] == AVCaptureTorchModeOn) {
        [device setTorchMode:AVCaptureTorchModeOff];
    } else {
        [device setTorchMode:AVCaptureTorchModeOn];
        if ([device setTorchModeOnWithLevel:0.2f error:nil]){
            NSLog(@"setTorch Level Success");
        } else {
            NSLog(@"setTorch Level Failure");
        }
    }
    [device unlockForConfiguration];
    [session commitConfiguration];
}
@end
