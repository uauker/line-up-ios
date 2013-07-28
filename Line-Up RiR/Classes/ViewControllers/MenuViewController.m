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
	
    self.events = [RockInRio allEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (UIColor *)getEventColorFromPosition:(int)position {
    switch (position) {
        case 0:
            return [UIColor colorWithRed:(255/255.f) green:(105/255.f) blue:(180/255.f) alpha:1.0];
            break;
        case 1:
            return [UIColor colorWithRed:(236/255.f) green:(176/255.f) blue:(16/255.f) alpha:1.0];
            break;
        case 2:
            return [UIColor colorWithRed:(12/255.f) green:(183/255.f) blue:(226/255.f) alpha:1.0];
            break;
        case 3:
            return [UIColor colorWithRed:(228/255.f) green:(0/255.f) blue:(0/255.f) alpha:1.0];
            break;
        case 4:
            return [UIColor colorWithRed:(255/255.f) green:(114/255.f) blue:(0/255.f) alpha:1.0];
            break;
        case 5:
            return [UIColor colorWithRed:(138/255.f) green:(43/255.f) blue:(226/255.f) alpha:1.0];
            break;
        case 6:
            return [UIColor colorWithRed:(50/255.f) green:(205/255.f) blue:(50/255.f) alpha:1.0];
            break;
            
        default:
            return [UIColor colorWithRed:(0/255.f) green:(0/255.f) blue:(0/255.f) alpha:1.0];
            break;
    }
}


#pragma ###################################################################################################################
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.events count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
        
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIColor *eventColor = [self getEventColorFromPosition:[indexPath row]];
    
    Event *event = [self.events objectAtIndex:[indexPath row]];
    
    UILabel *eventName = (UILabel *)[cell viewWithTag:101];
    UILabel *mainEvent = (UILabel *)[cell viewWithTag:102];
    
    eventName.textColor = eventColor;
    
    eventName.text = [event name];
    mainEvent.text = [event mainEvent];
    
    if ([indexPath row] == self.selectedIndex) {
        [cell setBackgroundColor:eventColor];
        eventName.textColor = [UIColor whiteColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


#pragma ###################################################################################################################
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
    self.selectedIndex = [indexPath row];
    
    Event *event = [self.events objectAtIndex:[indexPath row]];
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    LineUpViewController *lineUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"LineUpViewController"];
    lineUpViewController.event = event;
        
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:lineUpViewController];
    
    [self.revealController setFrontViewController:navigationController];
    
    [self.revealController showViewController:self.revealController.frontViewController];
}


@end
