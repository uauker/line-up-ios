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
#import "Event.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LineUpViewController : PKRevealController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Event *event;
@property (nonatomic, copy) NSArray *palcos;
@property (nonatomic, copy) NSArray *musicians;
@property (nonatomic, copy) NSArray *allEvents;

- (IBAction)showLeftView:(id)sender;

@end
