//
//  TrainingViewController.m
//  PetsAlliance
//
//  Created by Mark Miyashita on 6/12/13.
//  Copyright (c) 2013 Mark Miyashita. All rights reserved.
//

#import "TrainingViewController.h"

@interface TrainingViewController ()

@end

@implementation TrainingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Training";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PetStatusView *petStatusView = [[PetStatusView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [self.view addSubview:petStatusView];
    
    UITableView *trainingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 320, 400)];
    [self.view addSubview:trainingTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
