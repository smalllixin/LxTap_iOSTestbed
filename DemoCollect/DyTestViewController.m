//
//  DyTestViewController.m
//  DemoCollect
//
//  Created by lixin on 3/31/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "DyTestViewController.h"

@interface DyTestViewController ()<UICollisionBehaviorDelegate>

@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@end

@implementation DyTestViewController

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
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)gravityDownPress:(id)sender {
    [self.animator removeAllBehaviors];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.blackView,self.redView]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    
    UIGravityBehavior *behavior = [[UIGravityBehavior alloc] initWithItems:@[self.blackView]];
    [self.animator addBehavior:behavior];
}

- (IBAction)gravityUpPress:(id)sender {
    [self.animator removeAllBehaviors];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.blackView,self.redView]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    
    UIGravityBehavior *behavior = [[UIGravityBehavior alloc] init];
    [behavior addItem:self.blackView];
    CGVector gravityDirection = {-1.0, -1.0f};
    [behavior setGravityDirection:gravityDirection];
    [self.animator addBehavior:behavior];
}
- (IBAction)collisionPress:(id)sender {
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.blackView,self.redView]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    collision.collisionDelegate = self;
//    collision.collisionMode = UICollisionBehaviorModeBoundaries;
    [self.animator addBehavior:collision];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    [gravity addItem:self.blackView];
    CGVector gravityDirection = {1.0f, 1.0f};
    [gravity setGravityDirection:gravityDirection];
    [self.animator addBehavior:gravity];
    
    CGPoint point = CGPointMake(320.0, 0.0);
    UIAttachmentBehavior *attachment;
    attachment = [[UIAttachmentBehavior alloc] initWithItem:self.redView attachedToAnchor:point];
    [attachment setLength:300];
    [attachment setFrequency:100];
    [attachment setDamping:10];
    [self.animator addBehavior:attachment];
}
- (IBAction)attachmentPress:(id)sender {
    CGPoint point = CGPointMake(320.0, 0.0);
    UIAttachmentBehavior *attachment;
    attachment = [[UIAttachmentBehavior alloc] initWithItem:self.redView attachedToAnchor:point];
    [attachment setLength:300];
    [attachment setFrequency:100];
    [attachment setDamping:10];
    [self.animator addBehavior:attachment];
}

@end
