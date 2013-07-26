//
//  Palco.h
//  Line-Up RiR
//
//  Created by Alexandre Santos on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Musician.h"

@interface Palco : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *startAt;
@property (nonatomic, copy) NSArray *musicians;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSArray *)allMusiciansWithArray:(NSArray *)array;

@end
