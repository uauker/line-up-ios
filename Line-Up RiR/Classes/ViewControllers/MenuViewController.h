//
//  MenuViewController.h
//  Line-Up RiR
//
//  Created by Uauker on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RockInRio.h"
#import "Global.h"
#import "PKRevealController.h"
#import "LineUpViewController.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray *events;
@property int selectedIndex;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (UIColor *)getEventColorFromPosition:(int)position;

@end
