//
//  RockInRio.m
//  Line-Up RiR
//
//  Created by Alexandre Santos on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "RockInRio.h"

@implementation RockInRio

/**
* Arquivo nome, sem extensao, do arquivo local
*/
NSString *const FILENAME_WITH_PLACES = @"events";

/**
 * Extensao do arquivo local que contenha locais
 */
NSString *const EXTENSION_OF_FILENAME_WITH_PLACES = @"json";


/**
 * Retorna uma lista de Places com os itens existentes no arquivo local
 */
+ (NSArray *)allEvents {
    NSMutableArray *allEvents = [[NSMutableArray alloc] init];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:FILENAME_WITH_PLACES
                                                     ofType:EXTENSION_OF_FILENAME_WITH_PLACES];
    
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    for (NSDictionary *item in [[content objectFromJSONString] objectForKey:@"events"]) {
        Event *event = [[Event alloc] initWithDictionary:item];
        [allEvents addObject:event];
    }
    
    return allEvents;
}

@end
