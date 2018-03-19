//
//  NSObject+AlertUtils.h
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 01/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAlertController+TopViewController.h"

@interface NSObject (AlertUtils)
- (void)showAlertWithTitle:(NSString *)title message:(NSString *) message completionHandler:(void (^)(void))completion;
- (void)showError:(NSError *)error;
- (void)showErrorWithMessage:(NSString *)message;
@end
