//
//  LineUpViewController.h
//  Line-Up RiR
//
//  Created by Alexandre Santos on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RockInRio.h"
#import "PKRevealController.h"
#import "Musician.h"

@interface LineUpViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray *musicians;
@property (nonatomic, copy) NSArray *allEvents;

- (id)initWithArray:(NSArray *)array;
- (IBAction)showLeftView:(id)sender;

@end
