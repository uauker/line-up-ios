//
//  FBUser.m
//  Line-Up RiR
//
//  Created by Uauker on 7/30/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "FBUser.h"

@implementation FBUser

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.identifier = [dictionary objectForKey:@"facebook_user_id"];
        self.name = [dictionary objectForKey:@"facebook_name"];
        self.eventDate = [dictionary objectForKey:@"event_date"];
        self.username = [dictionary objectForKey:@"facebook_username"];
    }
    
    return self;
}

//https://developers.facebook.com/docs/reference/api/using-pictures/
- (NSString *)profileImage {
    return [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200&height=200", self.username];
}

@end
