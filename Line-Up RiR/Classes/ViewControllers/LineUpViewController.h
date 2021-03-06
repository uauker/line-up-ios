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
#import "Palco.h"
#import "Global.h"
#import "KxMenu.h"
#import "ActionSheetStringPicker.h"
#import "FacebookHelper.h"
#import "EventHelper.h"
#import "ErrorMessageHelper.h"

@interface LineUpViewController : PKRevealController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) Palco *palco;
@property (nonatomic, copy) NSArray *palcos;
@property (nonatomic, copy) NSArray *musicians;
@property (nonatomic, strong) NSMutableArray *mySchedule;
@property (nonatomic, assign) BOOL hasToOpenMenu;
@property (nonatomic, assign) BOOL isEventInMySchedule;

@property (weak, nonatomic) IBOutlet UIView *viewRIRTimer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *palcoSelector;
@property (weak, nonatomic) IBOutlet UILabel *palcoIndicator;
@property (weak, nonatomic) IBOutlet UILabel *rirTimer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalPositionTableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonToSelectPalco;
@property (weak, nonatomic) IBOutlet UILabel *labelRockStreet;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinnerToLoadMySchedule;

@property (weak, nonatomic) IBOutlet UIButton *buttonRirEuVou;

- (IBAction)addToMySchedule:(id)sender;
- (IBAction)showLeftView:(id)sender;
- (IBAction)selectPalco:(id)sender;
- (int)getDaysFromMonth:(int)month;

@end
