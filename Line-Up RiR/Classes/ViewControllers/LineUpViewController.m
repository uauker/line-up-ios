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

#define RIR_YEAR 2013
#define RIR_MONTH 9
#define RIR_DAY 13
#define RIR_HOUR 00
#define RIR_MINUTE 00
#define RIR_SECOND 00

NSDate *rirDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hasToOpenMenu = YES;
    
    self.buttonToSelectPalco.titleLabel.text = @"PALCO MUNDO";
    
    self.allEvents = [RockInRio allEvents];
    
    if (self.event == nil) {
        self.event = [self.allEvents objectAtIndex:0];
    }
    
    self.title = [self.event date];
    
    self.palcos = [self.event palcos];
    self.palco = [self.palcos objectAtIndex:0];
    self.musicians = [[[self.event palcos] objectAtIndex:0] musicians];
    
    [self.buttonToSelectPalco addTarget:self action:@selector(showPalcoOptions:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.palcoSelector addTarget:self action:@selector(showPalcoOptions:) forControlEvents:UIControlEventTouchUpInside];

    
    NSDictionary *dic = [@{
                         @"link" : @"https://developers.facebook.com/ios",
                         @"picture" : @"https://developers.facebook.com/attachment/iossdk_logo.png",
                         @"name" : @"Facebook SDK for iOS",
                         @"caption" : @"Build great social apps and get more installs.",
                         @"description" : @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps."
                         } mutableCopy];
    
    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_stream"] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            if (error != nil) {
                //TODO: Error? o que fazer?
                //Nem autentiaccao teve
            }
        }];
    }
    
    if (FBSession.activeSession.isOpen) {
        [FBRequestConnection startWithGraphPath:@"me" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                //TODO: error ao marcar que o usuario vai no dia
            }
            else {
                NSLog(@"%@", [result description]);
                NSString *UserAndPostID = [result objectForKey:@"id"];
                NSString *userID = [[UserAndPostID componentsSeparatedByString:@"_"] objectAtIndex:0];
                
                NSString *name = [[result objectForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:
                           NSASCIIStringEncoding];
                
                NSString *urlString = [NSString stringWithFormat:@"http://line-up-rails.herokuapp.com/api/facebook/v1/events/new?facebook_user_id=%@&event_date=2013-01-31&facebook_name=%@", userID, name];
                NSLog(@"%@", urlString);
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
                
                [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"success: %@", operation.responseString);
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error: %@",  operation.responseString);
                }];
                
                [operation start];
            }
        }];
        
//        [FBRequestConnection startWithGraphPath:@"me/feed" parameters:dic HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                if (error) {
//                    //TODO: error ao marcar que o usuario vai no dia
//                }
//                else {
//                    NSString *UserAndPostID = [result objectForKey:@"id"];
//                    NSString *userID = [[UserAndPostID componentsSeparatedByString:@"_"] objectAtIndex:0];
//                    
//                    NSString *urlString = [NSString stringWithFormat:@"http://line-up-rails.herokuapp.com/api/facebook/v1/events/new?facebook_user_id=%@&event_date=2013-01-31&facebook_name=Paulo+Guilherme", userID];
//                    NSLog(@"%@", urlString);
//                    NSURL *url = [NSURL URLWithString:urlString];
//                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//                    
//                    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//                    
//                    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                        NSLog(@"success: %@", operation.responseString);
//                    } 
//                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                        NSLog(@"error: %@",  operation.responseString);
//                    }];
//                    
//                    [operation start];
//                }
//            }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setTimer];
    if ([self rirNotStarted]) {
        [self.viewRIRTimer setHidden:NO];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabels) userInfo:nil repeats:YES];
    } else {
        [self.viewRIRTimer setHidden:YES];
        self.verticalPositionTableView.constant = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)showPalcoOptions:(UIButton *)sender
{        
    NSArray *menuItems =
    @[
      
      
      [KxMenuItem menuItem:@"PALCO MUNDO"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(selectOtherPalco:)],
      
      [KxMenuItem menuItem:@"PALCO SUNSET"
                     image:[UIImage imageNamed:@"check_icon"]
                    target:self
                    action:@selector(selectOtherPalco:)],
      
      [KxMenuItem menuItem:@"ELETRÔNICA"
                     image:[UIImage imageNamed:@"reload"]
                    target:self
                    action:@selector(selectOtherPalco:)],
      
      [KxMenuItem menuItem:@"ROCK STREET"
                     image:[UIImage imageNamed:@"search_icon"]
                    target:self
                    action:@selector(selectOtherPalco:)],
      ];
    
//    KxMenuItem *first = menuItems[0];
//    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
//    first.alignment = NSTextAlignmentCenter;
        
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(228, -15, 87, 21)
                 menuItems:menuItems];
    
    if (self.hasToOpenMenu) {
        self.hasToOpenMenu = NO;
    } else {
        [KxMenu dismissMenu];
        self.hasToOpenMenu = YES;
    }
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


#pragma ###################################################################################################################
#pragma mark - Internal Methods

- (void)selectedPalco:(NSNumber *)selectedIndex element:(id)element {
    self.palcoIndicator.text = [K_ARRAY_PALCOS objectAtIndex:[selectedIndex intValue]];
    self.musicians = [[self.palcos objectAtIndex:([selectedIndex intValue])] musicians];
    [self.tableView reloadData];
}

- (void)selectOtherPalco:(KxMenuItem *)sender {
    
    self.buttonToSelectPalco.titleLabel.text = sender.title;
    
    int index = [K_ARRAY_PALCOS indexOfObject:sender.title];
    
    if (index == 3) {
        [self.tableView setHidden:YES];
        [self.labelRockStreet setHidden:NO];
    } else {
        [self.tableView setHidden:NO];
        [self.labelRockStreet setHidden:YES];
        self.musicians = [[self.palcos objectAtIndex:index] musicians];
        [self.tableView reloadData];
    }
    
    self.hasToOpenMenu = YES;
}

- (void)setTimer {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:RIR_YEAR];
    [comps setMonth:RIR_MONTH];
    [comps setDay:RIR_DAY];
    [comps setHour:RIR_HOUR];
    [comps setMinute:RIR_MINUTE];
    [comps setSecond:RIR_SECOND];
    
    [comps setTimeZone:[NSTimeZone defaultTimeZone]];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    rirDate = [cal dateFromComponents:comps];
}

- (void)updateLabels {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [currentCalendar components:(NSMonthCalendarUnit | NSDayCalendarUnit |
                                                                NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit |
                                                                NSTimeZoneCalendarUnit) fromDate:[NSDate date] toDate:rirDate options:0];
    
    
    int daysFromMonth = [self getDaysFromMonth:components.month];
    
    NSString *timer = [NSString stringWithFormat:@"%.2id %.2ih %.2im %.2is", daysFromMonth + components.day, components.hour, components.minute, components.second];;

    self.rirTimer.text = timer;
}

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);
}

- (BOOL)rirNotStarted {
    switch ([rirDate compare:[NSDate date]]) {
        case NSOrderedAscending:
            // dateOne is earlier in time than dateTwo
            return NO;
            break;
        case NSOrderedSame:
            // The dates are the same
            return YES;
            break;
        case NSOrderedDescending:
            // dateOne is later in time than dateTwo
            return YES;
            break;
    }
}

- (int)getDaysFromMonth:(int)month {
    switch (month) {
        case 1:
            return 31;
            break;
        case 2:
            return 29;
            break;
        case 3:
            return 31;
            break;
        case 4:
            return 30;
            break;
        case 5:
            return 31;
            break;
        case 6:
            return 30;
            break;
        case 7:
            return 31;
            break;
        case 8:
            return 31;
            break;
        case 9:
            return 30;
            break;
        case 10:
            return 31;
            break;
        case 11:
            return 30;
            break;
        case 12:
            return 31;
            break;
            
        default:
            return 0;
            break;
    }
}

@end
