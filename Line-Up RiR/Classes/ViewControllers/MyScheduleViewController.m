//
//  MyScheduleViewController.m
//  Line-Up RiR
//
//  Created by Alexandre Marones on 7/26/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "MyScheduleViewController.h"

@interface MyScheduleViewController ()

@end

@implementation MyScheduleViewController

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
	
//    [self.view1 setHidden:YES];
    
    [self.view2 setFrame:CGRectMake(0, 0, self.view2.frame.size.width, self.view2.frame.size.height)];
    self.teste.constant = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
