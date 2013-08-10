//
//  ErrorMessageHelper.h
//  Line-Up RiR
//
//  Created by Alexandre Marones on 8/10/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSMessage.h"

@interface ErrorMessageHelper : NSObject

+ (void)showNetworkErrorMessageInViewController:(UIViewController *)viewController;
+ (void)showFacebookErrorMessageInViewController:(UIViewController *)viewController;

@end
