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
#import "FBUser.h"
#import "JSONKit.h"
#import "AppDelegate.h"

#define FB_PERMISSIONS @[@"publish_stream"]
#define FB_ME_PARAMETERS_FIELDS @"id,name,username"

#define HEROKU_ME @"http://line-up-rails.herokuapp.com/api/facebook/v1/events/me/%@"
#define HEROKU_SUBSCRIBE @"http://line-up-rails.herokuapp.com/api/facebook/v1/events/subscribe"
#define HEROKU_UNSUBSCRIBE @"http://line-up-rails.herokuapp.com/api/facebook/v1/events/unsubscribe"
#define HEROKU_FRIENDS @"http://line-up-rails.herokuapp.com/api/facebook/v1/events/friends"

typedef void(^FacebookHelperCallback)(NSArray *responseData, NSError *error);
typedef void(^FacebookStatusHelperCallback)(BOOL status, NSError *error);

@interface FacebookHelper : NSObject

+ (void)post;
+ (void)shareFromViewController:(UIViewController *)viewController withText:(NSString *)shareText;

+ (void)openActiveSessionWithBlock:(FacebookStatusHelperCallback)callback;;
+ (void)myScheduleFromHeroku:(FacebookHelperCallback)callback;
+ (void)subscribeFromHerokuWithEventDate:(NSString *)eventDate block:(FacebookStatusHelperCallback)callback;
+ (void)unsubscribeFromHerokuWithEventDate:(NSString *)eventDate block:(FacebookStatusHelperCallback)callback;
+ (void)friendsFromHerokuWithEventDate:(NSString *)eventDate block:(FacebookHelperCallback)callback;

@end
