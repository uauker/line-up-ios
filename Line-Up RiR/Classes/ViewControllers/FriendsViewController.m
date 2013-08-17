//
//  FriendsViewController.m
//  Line-Up RiR
//
//  Created by Alexandre Marones on 8/8/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.spinnerFBFriends startAnimating];
	
    [FacebookHelper friendsFromHerokuWithEventDate:self.event.startAt block:^(NSArray *responseData, NSError *error) {
        
        [self.spinnerFBFriends stopAnimating];
        [self.spinnerFBFriends setHidden:YES];
        
        self.fbUsers = responseData;
        [self.tableView reloadData];
        
        if (error) {
            [ErrorMessageHelper showFacebookErrorMessageInViewController:self];
        } else {
            self.labelFriendsNotFound.hidden = ([self.fbUsers count] > 0) ? YES : NO;
        }
    }];
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
    return [self.fbUsers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"myFriendsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FBUser *fbUser = [self.fbUsers objectAtIndex:[indexPath row]];
    
    UILabel *friendName = (UILabel *)[cell viewWithTag:151];
    UIImageView *friendPicture = (UIImageView *)[cell viewWithTag:152];
    
//    [friendPicture setImageWithURL:[NSURL URLWithString:[fbUser profileImage]]
//                   placeholderImage:[UIImage imageNamed:@"icon.png"]];
    
    friendName.text = [fbUser name];
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
