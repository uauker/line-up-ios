//
//  MyScheduleViewController.m
//  Line-Up RiR
//
//  Created by Alexandre Marones on 7/26/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "MyScheduleViewController.h"

@interface MyScheduleViewController ()

@property (nonatomic) NSUserDefaults *userPreferences;

@end

@implementation MyScheduleViewController

#define SHARE_MY_SCHEDULE_ON_FACEBOOK @"Essa é a minha agenda de eventos no aplicativo Line Up - Rock in Rio 2013:\n%@1"


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [FacebookHelper openActiveSession];
    
    self.userPreferences = [NSUserDefaults standardUserDefaults];
    
    if (!self.mySchedule) {
        self.mySchedule = [[NSMutableArray alloc] init];
    }
    
    [self setupMySchedule];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma ###################################################################################################################
#pragma mark - Internal Methods

- (void)setupMySchedule {
    for (Event *event in self.events) {
        if ([self.userPreferences boolForKey:event.date]) {
            [self.mySchedule addObject:event];
        }
    }
}


#pragma ###################################################################################################################
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mySchedule count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"myScheduleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

        Event *event = [self.events objectAtIndex:[indexPath row]];
        
        UILabel *eventDate = (UILabel *)[cell viewWithTag:121];    
        eventDate.text = [event name];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


#pragma ###################################################################################################################
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
    [self.revealController showViewController:self.revealController.frontViewController];
}


#pragma ###################################################################################################################
#pragma mark - Actions

- (IBAction)showLeftView:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
}

- (IBAction)shareMySchedule:(id)sender {
    NSString *myEventDates = [[NSString alloc] init];
    
    for (Event *event in self.mySchedule) {
        myEventDates = [NSString stringWithFormat:@"%@ %@\n", myEventDates, event.name];
    }
    
    NSString *shareText = [SHARE_MY_SCHEDULE_ON_FACEBOOK stringByReplacingOccurrencesOfString:@"%@1" withString:myEventDates];
    
    [FacebookHelper shareFromViewController:self withText:shareText];
}

@end
