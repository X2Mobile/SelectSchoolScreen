//
//  ClassA.m
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 02/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "ClassA.h"

@implementation ClassA

@synthesize delegate;

- (void) basicMethod {
    [self.delegate classDelegateMethod:self];
}

@end
