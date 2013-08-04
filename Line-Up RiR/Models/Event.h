//
//  Event.h
//  Line-Up RiR
//
//  Created by Alexandre Santos on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "Palco.h"

@interface Event : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSDate *startAt;
@property (nonatomic, copy) NSString *weekDay;
@property (nonatomic, copy) NSString *mainEvent;
@property (nonatomic, copy) NSArray *palcos;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)name;

- (NSArray *)allPalcosWithArray:(NSArray *)array;

@end
