//
//  UIAlertController+TopViewController.h
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 01/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (TopViewController)
- (UIViewController *)visibleViewController:(UIViewController *)rootViewController;
- (UIViewController *)getCurrentVisibleWindow;
@end
