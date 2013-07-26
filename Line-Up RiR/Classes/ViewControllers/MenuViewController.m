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

- (UIColor *)getEventColorFromPosition:(int)position {
    switch (position) {
        case 0:
            return [UIColor colorWithRed:(226/255.f) green:(155/255.f) blue:(196/255.f) alpha:1.0];
            break;
        case 1:
            return [UIColor colorWithRed:(230/255.f) green:(197/255.f) blue:(16/255.f) alpha:1.0];
            break;
        case 2:
            return [UIColor colorWithRed:(99/255.f) green:(189/255.f) blue:(224/255.f) alpha:1.0];
            break;
        case 3:
            return [UIColor colorWithRed:(233/255.f) green:(26/255.f) blue:(26/255.f) alpha:1.0];
            break;
        case 4:
            return [UIColor colorWithRed:(216/255.f) green:(158/255.f) blue:(44/255.f) alpha:1.0];
            break;
        case 5:
            return [UIColor colorWithRed:(98/255.f) green:(82/255.f) blue:(147/255.f) alpha:1.0];
            break;
        case 6:
            return [UIColor colorWithRed:(137/255.f) green:(184/255.f) blue:(66/255.f) alpha:1.0];
            break;
            
        default:
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
    
    Event *event = [self.events objectAtIndex:[indexPath row]];
    
    UILabel *eventName = (UILabel *)[cell viewWithTag:101];
    UILabel *mainEvent = (UILabel *)[cell viewWithTag:102];
    
    eventName.textColor = [self getEventColorFromPosition:[indexPath row]];
    
    eventName.text = [event name];
    mainEvent.text = [event mainEvent];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


#pragma ###################################################################################################################
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}


@end
