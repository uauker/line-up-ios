//
//  MenuViewController.m
//  Line-Up RiR
//
//  Created by Uauker on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
