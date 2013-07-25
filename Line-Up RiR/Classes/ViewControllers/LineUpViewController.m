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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
