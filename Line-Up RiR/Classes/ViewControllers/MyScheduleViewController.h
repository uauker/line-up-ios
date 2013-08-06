//
//  MyScheduleViewController.h
//  Line-Up RiR
//
//  Created by Alexandre Marones on 7/26/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"
#import "Event.h"
#import "FacebookHelper.h"

@interface MyScheduleViewController : PKRevealController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray *events;
@property (nonatomic, strong) NSMutableArray *mySchedule;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)showLeftView:(id)sender;
- (IBAction)shareMySchedule:(id)sender;

@end
