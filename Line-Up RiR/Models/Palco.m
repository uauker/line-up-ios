//
//  Palco.m
//  Line-Up RiR
//
//  Created by Alexandre Santos on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "Palco.h"

@implementation Palco

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.name = [dictionary objectForKey:@"name"];
        self.startAt = [dictionary objectForKey:@"startAt"];
        self.musicians = [dictionary objectForKey:@"mainEvent"];
    }
    
    return self;
}

+ (NSArray *)allMusiciansWithArray:(NSArray *)array {
    NSMutableArray *allMusicians = [[NSMutableArray alloc] init];

    for (NSDictionary *item in array) {
        Palco *palco = [[Palco alloc] initWithDictionary:item];
        [allMusicians addObject:palco];
    }
    
    return allMusicians;
}

@end
