//
//  AppDelegate.m
//  Line-Up RiR
//
//  Created by Uauker on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FacebookHelper openActiveSession];
    
    [self customizeNavBar];
    
    [self setupMySchedule];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    LineUpViewController *lineUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"LineUpViewController"];
    MenuViewController *menuViewController = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:lineUpViewController];
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:navigationController leftViewController:menuViewController options:nil];
    
    self.window.rootViewController = self.revealController;
    
    [[self window] makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Customize Methods

- (void)customizeNavBar {
    UIImage *navigationPortraitBackground = [[UIImage imageNamed:@"navbar-portrait.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [[UINavigationBar appearance] setBackgroundImage:navigationPortraitBackground forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: [UIColor whiteColor],
//                          UITextAttributeTextShadowColor: [UIColor redColor],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
                                     UITextAttributeFont: [UIFont fontWithName:@"Avenir-Black" size:20.0f]
     }];
}

- (void)setupMySchedule {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [FacebookHelper myScheduleFromHeroku:^(NSArray *responseData, NSError *error) {
            NSArray *mySchedule = [EventHelper bindToEventsFromFBUsers:responseData];
            NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
            [userPreferences setObject:mySchedule forKey:@"mySchedule"];
        }];

    });
}

@end
