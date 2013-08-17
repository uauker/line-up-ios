//
//  FacebookHelper.m
//  Line-Up RiR
//
//  Created by Uauker on 7/30/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "FacebookHelper.h"

@implementation FacebookHelper

+ (void)openActiveSessionWithBlock:(FacebookStatusHelperCallback)callback {
    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithPublishPermissions:FB_PERMISSIONS defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            AppDelegate *app = [[UIApplication sharedApplication] delegate];
            [app setupMySchedule];
            
            callback(session.state == FBSessionStateOpen, error);
            return ;
        }];
    }
    
    callback(YES, nil);
}

+ (void)post {
    if (FBSession.activeSession.isOpen) {
        NSDictionary *dic = [@{
                             @"link" : @"https://developers.facebook.com/ios",
                             @"picture" : @"https://developers.facebook.com/attachment/iossdk_logo.png",
                             @"name" : @"Facebook SDK for iOS",
                             @"caption" : @"Build great social apps and get more installs.",
                             @"description" : @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps."
                             } mutableCopy];
        
        [FBRequestConnection startWithGraphPath:@"me/feed" parameters:dic HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    //TODO: error ao marcar que o usuario vai no dia
                }
                else {
                    //TODO: Success
                }
            }];
    }
}

+ (void)shareFromViewController:(UIViewController *)viewController withText:(NSString *)shareText {
    BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:viewController initialText:shareText image:[UIImage imageNamed:@"icon"] url:[NSURL URLWithString:K_URL_APPSTORE] handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
        
        // TODO: Tratar erro ao tentar compartilhar um evento no facebook!!
        NSString *alertText = @"";
        if ([[error userInfo][FBErrorDialogReasonKey] isEqualToString:FBErrorDialogNotSupported]) {
            alertText = @"iOS Share Sheet not supported.";
        } else if (error) {
            alertText = [NSString stringWithFormat:@"error: domain = %@, code = %d", error.domain, error.code];
        } else if (result == FBNativeDialogResultSucceeded) {
            alertText = @"Posted successfully.";
        }
        
        if (![alertText isEqualToString:@""]) {
            // Show the result in an alert
            [[[UIAlertView alloc] initWithTitle:@"Result"
                                        message:alertText
                                       delegate:self
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil]
             show];
        }
    }];
    
    if (!displayedNativeDialog) {
        /*
         Fallback to web-based Feed dialog:
         https://developers.facebook.com/docs/howtos/feed-dialog-using-ios-sdk/
         */
    }
}

+ (void)myScheduleFromHeroku:(FacebookHelperCallback)callback {
    NSMutableArray *mySchedule = [[NSMutableArray alloc] init];
    
    if (FBSession.activeSession.isOpen) {
        NSDictionary *params = [NSDictionary dictionaryWithObject:FB_ME_PARAMETERS_FIELDS forKey:@"fields"];
        
        [FBRequestConnection startWithGraphPath:@"me" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                callback(mySchedule, error);
                return ;
            }
            
            NSString *urlString = [NSString stringWithFormat:HEROKU_ME, [result objectForKey:@"id"]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
            
            [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *json = [operation.responseString objectFromJSONString];
                
                for (NSDictionary *item in json) {
                    [mySchedule addObject:[[FBUser alloc] initWithDictionary:item]];
                }
                
                callback(mySchedule, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                callback(mySchedule, error);
            }];
            
            [operation start];
        }];
    }

    NSError *error = [[NSError alloc] initWithDomain:FBErrorReauthorizeFailedReasonSessionClosed code:nil userInfo:nil];
    
    callback(mySchedule, error);
}

+ (void)subscribeFromHerokuWithEventDate:(NSString *)eventDate block:(FacebookStatusHelperCallback)callback {
    if (FBSession.activeSession.isOpen) {
        __block BOOL status = NO;
        NSDictionary *params = [NSDictionary dictionaryWithObject:FB_ME_PARAMETERS_FIELDS forKey:@"fields"];
        
        [FBRequestConnection startWithGraphPath:@"me" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                callback(status, nil);
                return ;
            }
            
            NSString *userID = [result objectForKey:@"id"];
            NSString *name = [result objectForKey:@"name"];
            NSString *username = [result objectForKey:@"username"];
            
            NSString *json = [NSString stringWithFormat:@"{\"facebook_user_id\":\"%@\",\"event_date\":\"%@\",\"facebook_name\":\"%@\",\"facebook_username\":\"%@\"}", userID, eventDate, name, username];
            
            NSURLRequest *request = [self requestWithUrl:HEROKU_SUBSCRIBE body:json];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
            
            [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *json = [operation.responseString objectFromJSONString];
                status = [[json objectForKey:@"status"] isEqualToString:@"success"];
                
                callback(status, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                callback(status, error);
            }];
            
            [operation start];
        }];
    }
}

+ (void)unsubscribeFromHerokuWithEventDate:(NSString *)eventDate block:(FacebookStatusHelperCallback)callback {
    if (FBSession.activeSession.isOpen) {
        __block BOOL status = NO;
        NSDictionary *params = [NSDictionary dictionaryWithObject:FB_ME_PARAMETERS_FIELDS forKey:@"fields"];
        
        [FBRequestConnection startWithGraphPath:@"me" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                callback(status, nil);
                return ;
            }
            
            NSString *json = [NSString stringWithFormat:@"{\"facebook_user_id\":\"%@\",\"event_date\":\"%@\"}", [result objectForKey:@"id"], eventDate];
            
            NSURLRequest *request = [self requestWithUrl:HEROKU_UNSUBSCRIBE body:json];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
            
            [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *json = [operation.responseString objectFromJSONString];
                status = [[json objectForKey:@"status"] isEqualToString:@"success"];
                
                callback(status, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                callback(status, error);
            }];
            
            [operation start];
        }];
    }
}

+ (void)friendsFromHerokuWithEventDate:(NSString *)eventDate block:(FacebookHelperCallback)callback {
    NSMutableArray *friends = [[NSMutableArray alloc] init];
    NSMutableArray *friendsInHeroku = [[NSMutableArray alloc] init];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:@"id" forKey:@"fields"];
    
    if (FBSession.activeSession.isOpen) {
        [FBRequestConnection startWithGraphPath:@"me/friends" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                callback(friendsInHeroku, error);
                return ;
            }
            
            for (NSDictionary *friend in [result objectForKey:@"data"]) {
                [friends addObject:[friend objectForKey:@"id"]];
            }
            
            NSArray *f = [NSArray arrayWithArray:friends];
            NSString *json = [NSString stringWithFormat:@"{\"facebook_users_id\":\"%@\",\"event_date\":\"%@\"}", [f componentsJoinedByString:@","], eventDate];
            
            NSURLRequest *request = [self requestWithUrl:HEROKU_FRIENDS body:json];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
            
            [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *json = [operation.responseString objectFromJSONString];
                
                for (NSDictionary *item in json) {
                    [friendsInHeroku addObject:[[FBUser alloc] initWithDictionary:item]];
                }
                
                callback(friendsInHeroku, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                callback(friendsInHeroku, error);
            }];
            
            [operation start];
        }];
    }
}

+ (NSURLRequest *)requestWithUrl:(NSString *)urlString body:(NSString *)body {
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (body) {
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return request;
}

@end
