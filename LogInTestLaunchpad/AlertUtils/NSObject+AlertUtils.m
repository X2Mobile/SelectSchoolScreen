//
//  NSObject+AlertUtils.m
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 01/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "NSObject+AlertUtils.h"

//used for showing alertcontroller from nonviewcontrollers using the UIALert Category to get the shown Window
@implementation NSObject (AlertUtils)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message completionHandler:(void (^)(void))completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                         if (completion) {
                                                             completion();
                                                         }
                                                     }];
    [alert addAction:okAction];
    [[alert getCurrentVisibleWindow] presentViewController:alert animated:YES completion:nil];
}

- (void)showError:(NSError *)error {
    [self showErrorWithMessage:error.localizedDescription];
}

- (void)showErrorWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [alert dismissViewControllerAnimated:YES
                                                                                           completion:nil];
                                                   }];
    [alert addAction:action];
    
    [[alert getCurrentVisibleWindow]  presentViewController:alert
                       animated:YES
                     completion:nil];

}

@end
