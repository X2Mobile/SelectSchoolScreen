//
//  UIAlertController+TopViewController.m
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 01/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "UIAlertController+TopViewController.h"
#import "AppDelegate.h"

@implementation UIAlertController (TopViewController)

- (UIViewController *)visibleViewController:(UIViewController *)rootViewController {
    if (rootViewController.presentedViewController == nil)
    {
        return rootViewController;
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [self visibleViewController:lastViewController];
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController.presentedViewController;
        UIViewController *selectedViewController = tabBarController.selectedViewController;
        
        return [self visibleViewController:selectedViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    
    return [self visibleViewController:presentedViewController];
}

- (UIViewController *)getCurrentVisibleWindow {
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    return [self visibleViewController:vc];
}
@end
