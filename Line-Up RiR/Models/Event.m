//
//  Event.m
//  Line-Up RiR
//
//  Created by Alexandre Santos on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "Event.h"

@implementation Event

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.date = [dictionary objectForKey:@"date"];
        self.weekDay = [dictionary objectForKey:@"weekDay"];
        self.mainEvent = [dictionary objectForKey:@"mainEvent"];
        self.palcos = [Palco allPalcosWithArray:[dictionary objectForKey:@"palcos"]];
    }
    
    return self;
}

@end
