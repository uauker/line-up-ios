//
//  LineUpViewController.m
//  Line-Up RiR
//
//  Created by Alexandre Santos on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "LineUpViewController.h"

@interface LineUpViewController ()

@end

@implementation LineUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.allEvents = [RockInRio allEvents];
    
    if (self.event == nil) {
        self.event = [self.allEvents objectAtIndex:0];
        self.palcos = [self.event palcos];
        self.musicians = [[[self.event palcos] objectAtIndex:0] musicians];
    }
    
    if (self.palco == nil) {
        self.palco = [self.palcos objectAtIndex:0];
    }
    
    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error) {
                                          
                                          NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                         @"160682260790269",@"id",
                                                                         nil];
                                          
                                          [FBRequestConnection startWithGraphPath:@"events" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                              NSLog(@"error %@", [error description]);
                                              NSLog(@"result %@", result);
                                          }];
                                          
                                      }];
    }
    
    //    static NSString *PublishStreamPermission = @"user_events";
    //    [FBSession
    //     openActiveSessionWithPublishPermissions:@[PublishStreamPermission]
    //     defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES
    //     completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
    //         if ([session state] != FBSessionStateOpen) {
    //             // failed to open a valid session
    //             NSLog(@"failed to open a valid session");
    //         } else if ([[session permissions] containsObject:PublishStreamPermission]) {
    //             // session opened, permissions granted, now you can post
    //              NSLog(@"session opened, permissions granted, now you can post");
    //         } else {
    //             // session opened, but requested permissions not granted
    //             NSLog(@"session opened, but requested permissions not granted");
    //         }
    //     }];
    
    //    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    //
    //    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
    //                                                  graphPath:@"me/events"];
    //    
    //    [request sta];
}

- (void)viewWillAppear:(BOOL)animated
{

}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ###################################################################################################################
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.musicians count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"lineUpCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Musician *musician = [self.musicians objectAtIndex:[indexPath row]];
    
    UILabel *eventName = (UILabel *)[cell viewWithTag:121];
        
    eventName.text = [musician name];
    
    return cell;
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


- (IBAction)selectPalco:(id)sender {
    NSInteger initialSelection = 0;
    
    for (int i = 0; i < [self.palcos count]; i++) {
        if ([[self.palco name] isEqualToString:[[self.palcos objectAtIndex:i] name]]) {
            initialSelection = i;
        }
    }
    
    [ActionSheetStringPicker showPickerWithTitle:nil
                                            rows:K_ARRAY_PALCOS
                                initialSelection:initialSelection
                                          target:self
                                   successAction:@selector(selectedPalco:element:)
                                    cancelAction:nil
                                          origin:sender];
}

- (void)selectedPalco:(NSNumber *)selectedIndex element:(id)element {
    self.palcoIndicator.text = [K_ARRAY_PALCOS objectAtIndex:[selectedIndex intValue]];
    self.musicians = [[self.palcos objectAtIndex:([selectedIndex intValue])] musicians];
    [self.tableView reloadData];
}

@end
