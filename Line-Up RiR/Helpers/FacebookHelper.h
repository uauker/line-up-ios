//
//  FacebookHelper.h
//  Line-Up RiR
//
//  Created by Uauker on 7/30/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AFHTTPRequestOperation.h"

#define FB_PERMISSIONS @[@"publish_stream"]
#define FB_ME_PARAMETERS_FIELDS @"id,name,username"

#define HEROKU_REGISTER @"http://line-up-rails.herokuapp.com/api/facebook/v1/events/new?facebook_user_id=%@&event_date=2013-01-31&facebook_name=%@&facebook_username=%@"
#define HEROKU_FRIENDS @"http://line-up-rails.herokuapp.com/api/facebook/v1/events/%@?facebook_users_id=%@&event_date=2013-01-31"

@interface FacebookHelper : NSObject

+ (void)openActiveSession;
+ (void)post;

+ (void)registerMeToAppServer;
+ (NSArray *)friendsToAppServer;

@end
