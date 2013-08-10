//
//  ErrorMessageHelper.m
//  Line-Up RiR
//
//  Created by Alexandre Marones on 8/10/13.
//  Copyright (c) 2013 Uauker Inc. All rights reserved.
//

#import "ErrorMessageHelper.h"

@implementation ErrorMessageHelper

+ (void)showNetworkErrorMessageInViewController:(UIViewController *)viewController {
    NSString *notificationTitle = NSLocalizedString(@"Erro de conexão", nil);
    NSString *notificationDescription = NSLocalizedString(@"Falha ao carregar sua agenda do Rock In Rio 2013. Tente novamente mais tarde.", nil);
    
    [TSMessage showNotificationInViewController:viewController
                                      withTitle:notificationTitle
                                    withMessage:notificationDescription
                                       withType:TSMessageNotificationTypeError
                                   withDuration:-1];
}

+ (void)showFacebookErrorMessageInViewController:(UIViewController *)viewController {
    NSString *notificationTitle = NSLocalizedString(@"Erro de autenticação com o Facebook", nil);
    NSString *notificationDescription = NSLocalizedString(@"Para usar essa funcionalidade é necessário que você esteja conectado ao Facebook.", nil);
    
    [TSMessage showNotificationInViewController:viewController
                                      withTitle:notificationTitle
                                    withMessage:notificationDescription
                                       withType:TSMessageNotificationTypeError
                                   withDuration:-1];
}

@end
