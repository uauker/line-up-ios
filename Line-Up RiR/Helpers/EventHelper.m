//
//  BindFBUserToEventHelper.m
//  Line-Up RiR
//
//  Created by Alexandre Marones on 8/6/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "EventHelper.h"

@implementation EventHelper

+ (NSArray *)getAllEvents {
    return [RockInRio allEvents];
}

+ (NSMutableArray *)bindToEventsFromFBUsers:(NSArray *)fbUsers {
    
    NSMutableArray *eventsFromMySchedule = [[NSMutableArray alloc] init];
    
    NSArray *allEvents = [self getAllEvents];
    
    for (Event *event in allEvents) {
        for (FBUser *user in fbUsers) {
            if ([event.startAt isEqualToString:[user eventDate]]) {
                [eventsFromMySchedule addObject:event.startAt];
            }
        }
    }
    
    return eventsFromMySchedule;
}

+ (NSMutableArray *)getEventsFromMySchedule {
    
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    NSArray *eventDates = [[NSArray alloc] initWithArray:[userPreferences objectForKey:@"mySchedule"]];
    
    NSMutableArray *eventsFromMySchedule = [[NSMutableArray alloc] init];
    
    NSArray *allEvents = [self getAllEvents];
    
    for (Event *event in allEvents) {
        for (NSString *eventDate in eventDates) {
            if ([event.startAt isEqualToString:eventDate]) {
                [eventsFromMySchedule addObject:event];
            }
        }
    }
    
    return eventsFromMySchedule;
}

@end
