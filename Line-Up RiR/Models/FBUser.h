//
//  FBUser.h
//  Line-Up RiR
//
//  Created by Uauker on 7/30/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBUser : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *eventDate;
@property (nonatomic, copy) NSString *username;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
