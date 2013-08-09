//
//  BindFBUserToEventHelper.h
//  Line-Up RiR
//
//  Created by Alexandre Marones on 8/6/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RockInRio.h"
#import "Event.h"
#import "FBUser.h"

@interface EventHelper : NSObject

+ (NSArray *)getAllEvents;
+ (NSMutableArray *)bindToEventsFromFBUsers:(NSArray *)fbUsers;
+ (NSMutableArray *)getEventsFromMySchedule;

@end
