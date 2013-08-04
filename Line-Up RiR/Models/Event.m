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
        self.palcos = [self allPalcosWithArray:[dictionary objectForKey:@"palcos"]];
        self.startAt = [dictionary objectForKey:@"startAt"];
    }
    
    return self;
}

- (NSString *)name {
    NSString *name = [[NSString alloc] init];
    name = [NSString stringWithFormat:@"%@ %@", [self.weekDay uppercaseString], self.date];
    return name;
}

- (NSArray *)allPalcosWithArray:(NSArray *)array {
    NSMutableArray *allPalcos = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in array) {
        Palco *palco = [[Palco alloc] initWithDictionary:item];
        [allPalcos addObject:palco];
    }
    
    return allPalcos;
}

@end
