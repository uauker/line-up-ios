//
//  MyScheduleViewController.h
//  Line-Up RiR
//
//  Created by Alexandre Marones on 7/26/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"
#import "FacebookHelper.h"

@interface MyScheduleViewController : PKRevealController <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)showLeftView:(id)sender;

@end
