//
//  Musician.h
//  Line-Up RiR
//
//  Created by Alexandre Santos on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Musician : NSObject

@property (nonatomic, copy) NSString *name;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
