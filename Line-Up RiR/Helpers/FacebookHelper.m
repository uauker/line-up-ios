//
//  FacebookHelper.m
//  Line-Up RiR
//
//  Created by Uauker on 7/30/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "FacebookHelper.h"

@implementation FacebookHelper

+ (void)openActiveSession {
    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithPublishPermissions:FB_PERMISSIONS defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            if (error != nil) {
                //TODO: Error? o que fazer?
                //Nem autentiaccao teve
            }
        }];
    }
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
    if (FBSession.activeSession.isOpen) {
        NSMutableArray *mySchedule = [[NSMutableArray alloc] init];
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
}

//TODO: APAGAR EM BREVE
+ (NSArray *)getMyScheduleFromHeroku {
    
    if (FBSession.activeSession.isOpen) {
        
        NSMutableArray *mySchedule = [[NSMutableArray alloc] init];
        
        NSDictionary *params = [NSDictionary dictionaryWithObject:FB_ME_PARAMETERS_FIELDS forKey:@"fields"];
        //        https://developers.facebook.com/docs/reference/api/using-pictures/
        
        [FBRequestConnection startWithGraphPath:@"me" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                //TODO: error ao marcar que o usuario vai no dia
            }
            else {
                NSString *urlString = [NSString stringWithFormat:HEROKU_ME, [result objectForKey:@"id"]];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
                
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
                
                [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSString *jsonString = [operation responseString];
                    
                    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    
                    for (NSDictionary *item in jsonDictionary) {
                        [mySchedule addObject:[item objectForKey:@"event_date"]];
                    }
                    
                    //Conseguiu registrar
                    NSLog(@"SUCESSO");
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    //erro ao registrar no nosso host
                    NSLog(@"ERRO, %@", [error description]);
                }];
                
                [operation start];
            }
        }];
        
        return mySchedule;
    }
    
//    if ([mySchedule count] > 0) {
//    }
    
    return nil;
}


+ (void)subscribeToAppServerWithEventDate:(NSString *)eventDate block:(FacebookHelperCallback)callback {
    if (FBSession.activeSession.isOpen) {
        NSMutableArray *users = [[NSMutableArray alloc] init];
        NSDictionary *params = [NSDictionary dictionaryWithObject:FB_ME_PARAMETERS_FIELDS forKey:@"fields"];
        
        [FBRequestConnection startWithGraphPath:@"me" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                callback(users, nil);
                return ;
            }
            
            NSString *userID = [result objectForKey:@"id"];
            NSString *name = [result objectForKey:@"name"];
            NSString *username = [result objectForKey:@"username"];
            
            NSString *json = [NSString stringWithFormat:@"{\"facebook_user_id\":\"%@\",\"event_date\":\"%@\",\"facebook_name\":\"%@\",\"facebook_username\":\"%@\"}", userID, eventDate, name, username];
            
            NSURLRequest *request = [self requestWithUrl:HEROKU_SUBSCRIBE body:json];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
            
            [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                callback(users, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                callback(users, error);
            }];
            
            [operation start];
        }];
    }
}

//TODO: APAGAR EM BREVE
+ (void)subscribeToAppServerWithEventDate:(NSString *)eventDate {
    if (FBSession.activeSession.isOpen) {
        NSDictionary *params = [NSDictionary dictionaryWithObject:FB_ME_PARAMETERS_FIELDS forKey:@"fields"];
        //        https://developers.facebook.com/docs/reference/api/using-pictures/
        
        [FBRequestConnection startWithGraphPath:@"me" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                //TODO: error ao marcar que o usuario vai no dia
            }
            else {
                NSString *UserAndPostID = [result objectForKey:@"id"];
                NSString *userID = [[UserAndPostID componentsSeparatedByString:@"_"] objectAtIndex:0];
                
                NSString *name = [result objectForKey:@"name"];
                NSString *username = [result objectForKey:@"username"];
                
                NSString *json = [NSString stringWithFormat:@"{\"facebook_user_id\":\"%@\",\"event_date\":\"%@\",\"facebook_name\":\"%@\",\"facebook_username\":\"%@\"}", userID, eventDate, name, username];

                NSURLRequest *request = [self requestWithUrl:HEROKU_SUBSCRIBE body:json];
                
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
                
                [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //Conseguiu registrar
                    NSLog(@"SUCESSO");
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    //erro ao registrar no nosso host
                    NSLog(@"ERRO, %@", [error description]);
                }];
                
                [operation start];
            }
        }];
    }
}

+ (void)unsubscribeToAppServerWithEventDate:(NSString *)eventDate {
    if (FBSession.activeSession.isOpen) {
        NSDictionary *params = [NSDictionary dictionaryWithObject:FB_ME_PARAMETERS_FIELDS forKey:@"fields"];
        
        [FBRequestConnection startWithGraphPath:@"me" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                //TODO: error ao marcar que o usuario vai no dia
            }
            else {
                NSString *json = [NSString stringWithFormat:@"{\"facebook_user_id\":\"%@\",\"event_date\":\"%@\"}", [result objectForKey:@"id"], eventDate];

                NSURLRequest *request = [self requestWithUrl:HEROKU_UNSUBSCRIBE body:json];
                
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
                
                [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //Conseguiu registrar
                    NSLog(@"SUCESSO");
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    //erro ao registrar no nosso host
                    NSLog(@"ERRO, %@", [error description]);
                }];
                
                [operation start];
            }
        }];
    }
}

+ (NSArray *)friendsToAppServerWithEventDate:(NSString *)eventDate {
    NSMutableArray *friends = [[NSMutableArray alloc] init];
    NSDictionary *params = [NSDictionary dictionaryWithObject:@"id" forKey:@"fields"];
    
    if (FBSession.activeSession.isOpen) {
        [FBRequestConnection startWithGraphPath:@"me/friends" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                //TODO: tratar error
            }
            else {
                for (NSDictionary *friend in [result objectForKey:@"data"]) {
                    [friends addObject:[friend objectForKey:@"id"]];
                }
                
                NSArray *f = [NSArray arrayWithArray:friends];

                NSString *json = [NSString stringWithFormat:@"{\"facebook_users_id\":\"%@\",\"event_date\":\"%@\"}", [f componentsJoinedByString:@","], eventDate];
                NSLog(@"%@", json);
                
                NSURLRequest *request = [self requestWithUrl:HEROKU_FRIENDS body:json];
                
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
                
                [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //Conseguiu registrar
                    NSLog(@"SUCESSO: %@", operation.responseString);
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    //erro ao registrar no nosso host
                    NSLog(@"ERRO %@", [error description]);
                }];
                
                [operation start];
            }
            
            NSLog(@"%@", friends);
            NSLog(@"eu nao tenho um milhao de amigos, tenho %i amigo", [friends count]);
        }];
    }
    
    return friends;
}

+ (NSURLRequest *)requestWithUrl:(NSString *)urlString body:(NSString *)body {
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (body) {
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return request;
}

@end
