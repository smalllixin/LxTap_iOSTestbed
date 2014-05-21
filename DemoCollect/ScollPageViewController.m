//
//  ScollPageViewController.m
//  DemoCollect
//
//  Created by lixin on 3/31/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "ScollPageViewController.h"
#import "Page1ViewController.h"
#import "Bolts.h"

@interface ScollPageViewController ()<UIScrollViewDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (assign, nonatomic) NSInteger currentPage;
@end

@implementation ScollPageViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
    /**
     Several things should be considered
     [ok]1. Use Verticle Scroll As PageView
     [ok]2. Use View Controller As PageView
     3. Scroll From 1 To 9 do not means need to Load Everything
     */
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.scroll.backgroundColor = [UIColor blackColor];
    
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    
//    [self.scroll setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.scroll.contentInset = UIEdgeInsetsZero;
    self.scroll.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    self.scroll.pagingEnabled = YES;
    self.scroll.delegate = self;
    self.currentPage = 0;
    [self reloadPages];
    
    NSLog(@"scrollview height:%f",self.scroll.frame.size.height);
}

-(BFTask*)loadingPageTask:(int)idx {
    BFTaskCompletionSource *tcs = [BFTaskCompletionSource taskCompletionSource];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *pageVC = [self loadViewControllerAtPage:idx];
        pageVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        pageVC.view.frame = CGRectMake(idx*CGRectGetWidth(self.scroll.frame), 0, CGRectGetWidth(self.scroll.frame), CGRectGetHeight(self.scroll.frame));
        [tcs setResult:pageVC];
    });
    [self setPageLoadingIndicator:idx];
    return tcs.task;
}

-(void)setPageLoadingIndicator:(int)idx {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    CGRect f = indicator.frame;
//    f.origin.x = idx * CGRectGetWidth(self.scroll.frame);
    indicator.center = CGPointMake(CGRectGetWidth(self.scroll.bounds)/2,CGRectGetHeight(self.scroll.bounds)/2);
    CGRect f = indicator.frame;
    f.origin.x = idx * CGRectGetWidth(self.scroll.frame);
    indicator.frame = f;
    indicator.hidden = NO;
    [indicator startAnimating];
    indicator.hidesWhenStopped = YES;
    indicator.tag = 233+idx;
    [self.scroll addSubview:indicator];
}

- (void)pageTo:(NSInteger)iPage {
    self.currentPage = iPage;
    [[[self loadingPageTask:iPage] continueWithExecutor:[BFExecutor mainThreadExecutor] withSuccessBlock:^id(BFTask *task) {
        Page1ViewController *pageVC = task.result;
        [self.scroll addSubview:pageVC.view];
        [pageVC didMoveToParentViewController:pageVC];
        id<ScrollPageTask> pageTask = pageVC;
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.scroll viewWithTag:233 + iPage];
        [self.scroll bringSubviewToFront:indicator];
//        return nil;
        return [pageTask loadingTask];
    }] continueWithExecutor:[BFExecutor mainThreadExecutor] withSuccessBlock:^id(BFTask *task) {
//        NSLog(@"wow");
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.scroll viewWithTag:233 + iPage];
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        return nil;
    }];
}

- (void)reloadPages
{
    int totalPage = 5;
//    for (int i = 0; i < totalPage; i ++) {
//        [[[self loadingPageTask:i] continueWithExecutor:[BFExecutor mainThreadExecutor] withSuccessBlock:^id(BFTask *task) {
//            UIViewController *pageVC = task.result;
//            [self.scroll addSubview:pageVC.view];
//            [pageVC didMoveToParentViewController:pageVC];
//            return nil;
//        }] continueWithExecutor:[BFExecutor mainThreadExecutor] withSuccessBlock:^id(BFTask *task) {
//            UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.scroll viewWithTag:233 + i];
//            [indicator stopAnimating];
//            [indicator removeFromSuperview];
//            return nil;
//        }];
//    }
    self.scroll.contentSize = CGSizeMake(totalPage*CGRectGetWidth(self.scroll.frame), 1);
//    UIViewController *pageVC = [self loadViewControllerAtPage:0];
//    [self addChildViewController:pageVC];
//    [self.scroll addSubview:pageVC.view];
//    [pageVC didMoveToParentViewController:pageVC];
//    pageVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    pageVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.scroll.frame), CGRectGetHeight(self.scroll.frame));
//    
//    int totalPage = 5;
//    
//    for (int i = 1; i < totalPage; i ++) {
//        UIView *v = [self genRandomView];
//        [self.scroll addSubview:v];
//        CGRect f = v.frame;
//        f.origin.x = i * CGRectGetWidth(self.scroll.frame);
//        v.frame = f;
//    }
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"scrollview real height:%f",self.scroll.frame.size.height);
    self.scroll.contentInset = UIEdgeInsetsZero;
}

- (void)toPage:(NSInteger)idx
{
    CGRect frame = self.scroll.frame;
    frame.origin.x = frame.size.width * idx;
    frame.origin.y = 0;
    frame.size.height = 1;
    [self.scroll scrollRectToVisible:frame animated:YES];
}

- (UIView*)genRandomView
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scroll.frame), CGRectGetHeight(self.scroll.frame))];
    UIColor *c = [UIColor colorWithRed:(arc4random()%256)/255.0f green:(arc4random()%256)/255.0f blue:(arc4random()%256)/255.0f alpha:1];
    v.backgroundColor = c;
    return v;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Willbe callbacks
//delegate callbacks
- (UIViewController*)loadViewControllerAtPage:(NSInteger)idx
{
    Page1ViewController *page = [[Page1ViewController alloc] initWithNibName:@"Page1ViewController" bundle:nil];
    return page;
}


#pragma mark - ScrollDelegates
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageLabel.text = [NSString stringWithFormat:@"Page:%d", page];
    if (page != self.currentPage) {
        [self pageTo:page];
    }
}
#pragma mark - Events
- (IBAction)to3Tap:(id)sender {
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.pageLabel]];
    [self.animator addBehavior:gravity];
    [self toPage:3];
}

@end
