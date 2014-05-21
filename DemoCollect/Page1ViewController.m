//
//  Page1ViewController.m
//  DemoCollect
//
//  Created by lixin on 3/31/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "Page1ViewController.h"

@interface Page1ViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;
@end

@implementation Page1ViewController

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
    self.table.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"blah blah %d", indexPath.row];
    return cell;
}

- (BFTask*)loadingTask {
    return [[BFTask taskWithDelay:2000] continueWithSuccessBlock:^id(BFTask *task) {
        NSLog(@"loading complete");
        return @YES;
    }];
}

@end
