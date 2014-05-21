//
//  PopTestViewController.m
//  DemoCollect
//
//  Created by lixin on 4/30/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "PopTestViewController.h"
#import <POP/POP.h>
#import "PopButton.h"
@interface PopTestViewController ()

@property (weak, nonatomic) IBOutlet UIView *animBlockView;
@property (weak, nonatomic) IBOutlet PopButton *popBtn;
@end

@implementation PopTestViewController

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
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
    [self.view addGestureRecognizer:recognizer];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandle:)];
    [self.animBlockView addGestureRecognizer:pinch];
    
    self.popBtn.maxScale = 2;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)pinchHandle:(UIPinchGestureRecognizer*)recognizer
{
    CGFloat beganScale;
    CGRect b;
    if (UIGestureRecognizerStateBegan == recognizer.state) {
        beganScale = recognizer.scale;
        b = self.animBlockView.bounds;
    } else if(UIGestureRecognizerStateChanged == recognizer.state) {
        CGRect bod = b;
        bod.size.width *= recognizer.scale;
        bod.size.height *= recognizer.scale;
        self.animBlockView.bounds = bod;
    } else if(UIGestureRecognizerStateEnded == recognizer.state) {
        POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
//        spring.velocity = [NSValue valueWithCGPoint:velocity];
        [_animBlockView.layer pop_addAnimation:spring forKey:@"bbAnimation"];
    }
}

- (void)panHandle:(UIPanGestureRecognizer*)recognizer
{
    static CGRect beganPos;
    UIGestureRecognizerState s = recognizer.state;
    if (s == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:[self.view window]];
        
        POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
        spring.velocity = [NSValue valueWithCGPoint:velocity];
        [_animBlockView.layer pop_addAnimation:spring forKey:@"posAnimation"];
    } else if (s == UIGestureRecognizerStateChanged) {
        CGPoint trans = [recognizer translationInView:[self.view window]];
        CGRect c = beganPos;
        c.size.width += trans.x;
        c.size.height += trans.y;
        self.animBlockView.bounds = c;
    } else if (s == UIGestureRecognizerStateBegan) {
        beganPos = self.animBlockView.bounds;
    }

//    static CGPoint beganPos;
//    UIGestureRecognizerState s = recognizer.state;
//    if (s == UIGestureRecognizerStateEnded) {
//        CGPoint velocity = [recognizer velocityInView:[self.view window]];
//        
//        POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
//        spring.velocity = [NSValue valueWithCGPoint:velocity];
//        [_animBlockView.layer pop_addAnimation:spring forKey:@"posAnimation"];
//    } else if (s == UIGestureRecognizerStateChanged) {
//        CGPoint trans = [recognizer translationInView:[self.view window]];
//        CGPoint c = beganPos;
//        c.x += trans.x;
//        c.y += trans.y;
//        self.animBlockView.center = c;
//    } else if (s == UIGestureRecognizerStateBegan) {
//        beganPos = self.animBlockView.center;
//    }
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

@end
