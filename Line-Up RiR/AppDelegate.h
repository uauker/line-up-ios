//
//  AppDelegate.h
//  Line-Up RiR
//
//  Created by Uauker on 7/25/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"
#import "MenuViewController.h"
#import "LineUpViewController.h"
#import "EventHelper.h"
#import "FacebookHelper.h"

@class PKRevealController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong, readwrite) PKRevealController *revealController;
@property (strong, nonatomic) UIWindow *window;

@end
