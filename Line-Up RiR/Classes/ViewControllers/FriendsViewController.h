//
//  FriendsViewController.h
//  Line-Up RiR
//
//  Created by Alexandre Marones on 8/8/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventHelper.h"
#import "FBUser.h"
#import "FacebookHelper.h"

@interface FriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Event *event;
@property (nonatomic, copy) NSArray *fbUsers;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
