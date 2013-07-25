//
//  LineUpViewController.m
//  Line-Up RiR
//
//  Created by Alexandre Santos on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "LineUpViewController.h"

@interface LineUpViewController ()

@end

@implementation LineUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSArray *allEvents = [[NSArray alloc] init];
    allEvents = [RockInRio allEvents];
    
}

#pragma mark - Actions

- (IBAction)showLeftView:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
