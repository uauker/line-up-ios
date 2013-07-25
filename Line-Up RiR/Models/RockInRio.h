//
//  RockInRio.h
//  Line-Up RiR
//
//  Created by Alexandre Santos on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "Event.h"

@interface RockInRio : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSMutableArray *events;

+ (NSArray *)allEvents;

@end
