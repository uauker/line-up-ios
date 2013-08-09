//
//  LineUpViewController.m
//  Line-Up RiR
//
//  Created by Alexandre Santos on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "LineUpViewController.h"

@interface LineUpViewController ()

@property (nonatomic) NSUserDefaults *userPreferences;

@end

@implementation LineUpViewController

#define RIR_YEAR 2013
#define RIR_MONTH 9
#define RIR_DAY 13
#define RIR_HOUR 00
#define RIR_MINUTE 00
#define RIR_SECOND 00
#define ALERT_TITLE_SHARE_EVENT_ON_FACEBOOK @"Deseja compartilhar com seus amigos do Facebook?"
#define SHARE_EVENT_ON_FACEBOOK @"Acabei de adicionar o dia %@1 na minha agenda do aplicativo Line Up - Rock in Rio 2013.\n\n"

NSDate *rirDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userPreferences = [NSUserDefaults standardUserDefaults];
    
    [FacebookHelper openActiveSession];
    [FacebookHelper myScheduleFromHeroku:^(NSArray *responseData, NSError *error) {
        NSArray *mySchedule = [EventHelper bindToEventsFromFBUsers:responseData];
        [self.userPreferences setObject:mySchedule forKey:@"mySchedule"];
        [self checkIfEventIsInMySchedule];
    }];
    
    if (self.event == nil) {
        self.event = [[EventHelper getAllEvents] objectAtIndex:0];
    }
    
    [self setupMySchedule];
    
//    [self.mySchedule addObject:[self.event startAt]];
    
    [self checkIfEventIsInMySchedule];
    
    self.hasToOpenMenu = YES;
    
    self.buttonToSelectPalco.titleLabel.text = @"PALCO MUNDO";
        
    self.title = [self.event date];
    
    self.palcos = [self.event palcos];
    self.palco = [self.palcos objectAtIndex:0];
    self.musicians = [[[self.event palcos] objectAtIndex:0] musicians];
    
    [self.buttonToSelectPalco addTarget:self action:@selector(showPalcoOptions:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.palcoSelector addTarget:self action:@selector(showPalcoOptions:) forControlEvents:UIControlEventTouchUpInside];
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
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self shareEventOnFacebook];
    }
}


#pragma ###################################################################################################################
#pragma mark - Actions

- (IBAction)addToMySchedule:(id)sender {
    [self checkIfEventIsInMySchedule];
    
    NSString *eventDate = self.event.startAt;
    
    if (self.isEventInMySchedule) {
        [self.buttonRirEuVou setBackgroundImage:[UIImage imageNamed:@"rir_eu_vou_clicked.png"]
                                       forState:UIControlStateNormal];
        
        [self removeEventFromMySchedule:eventDate];
        [FacebookHelper unsubscribeToAppServerWithEventDate:eventDate];
    } else {
        [self.buttonRirEuVou setBackgroundImage:[UIImage imageNamed:@"rir_eu_vou.png"]
                                       forState:UIControlStateNormal];
        
        [self addEventToMySchedule:eventDate];
        [FacebookHelper subscribeToAppServerWithEventDate:eventDate];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE_SHARE_EVENT_ON_FACEBOOK
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancelar"
                                              otherButtonTitles:@"Compartilhar", nil];
        [alert show];
    }
}

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
    NSArray *filterItems =
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
                 menuItems:filterItems];
    
    if (self.hasToOpenMenu) {
        self.hasToOpenMenu = NO;
    } else {
        [KxMenu dismissMenu];
        self.hasToOpenMenu = YES;
    }
}


#pragma ###################################################################################################################
#pragma mark - Internal Methods


- (void)setupMySchedule {
    
    self.mySchedule = [[NSMutableArray alloc] init];
    [self.mySchedule addObjectsFromArray:[self.userPreferences objectForKey:@"mySchedule"]];
    
    if (self.mySchedule == nil) {
        self.mySchedule = [[NSMutableArray alloc] init];
    }
    
    [self checkIfEventIsInMySchedule];
    [self setRiRButtonBackground];
}

- (void)removeEventFromMySchedule:(NSString *)eventDate {
    [self.mySchedule removeObject:eventDate];
    [self updateMySchedule];
}

- (void)addEventToMySchedule:(NSString *)eventDate {
    [self.mySchedule addObject:eventDate];
    [self updateMySchedule];
}

- (void)updateMySchedule {
    [self.userPreferences setObject:self.mySchedule forKey:@"mySchedule"];
}

- (void)shareEventOnFacebook {
    
    NSString *shareText = [SHARE_EVENT_ON_FACEBOOK stringByReplacingOccurrencesOfString:@"%@1" withString:[self.event date]];
    
    [FacebookHelper shareFromViewController:self withText:shareText];
    
}

- (void)setRiRButtonBackground {
    [self checkIfEventIsInMySchedule];
    
    NSString *imgName = (self.isEventInMySchedule) ? @"rir_eu_vou.png" : @"rir_eu_vou_clicked.png";
    
    [self.buttonRirEuVou setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

- (void)checkIfEventIsInMySchedule {
    
    self.isEventInMySchedule = [self.mySchedule containsObject:[self.event startAt]];
    
    if (!self.isEventInMySchedule) {
        self.isEventInMySchedule = NO;
    }
}

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
